import Slipstream
import SwiftSyntax
import SwiftParser

struct SwiftCode: View {
  let syntax: SyntaxProtocol

  init(code: String) {
    self.init(syntax: Syntax(Parser.parse(source: code)))
  }

  init(syntax: SyntaxProtocol) {
    self.syntax = syntax
  }

  @ViewBuilder var body: some View {
    for token in syntax.tokens(viewMode: .sourceAccurate) {
      if token.tokenKind != .endOfFile {
        Trivia(pieces: token.leadingTrivia.pieces)
      }
      switch token.tokenKind {
      case .keyword:
        Keyword(string: token.text)
      case .atSign:
        if token.keyPathInParent == \AttributeSyntax.atSign {
          Keyword(string: token.text)
        } else {
          Slipstream.Text(token.text)
        }
      case .identifier:
        Identifier(string: token.text, keyPathInParent: token.keyPathInParent)
      case .endOfFile:
        EmptyView()
      case .floatLiteral,
          .integerLiteral:
        Literal(string: token.text)
      case .prefixOperator,
          .binaryOperator,
          .postfixOperator:
        Slipstream.Text(token.text)
      case .stringQuote, .singleQuote:
        Quotes(string: token.text)
      default:
        if token.tokenKind.isPunctuation {
          Slipstream.Text(token.text)
        } else {
          let _ = print(token.tokenKind)
          EmptyView()
        }
      }
      Trivia(pieces: token.trailingTrivia.pieces)
    }
    for child in syntax.children(viewMode: .sourceAccurate) {
      if let childSyntax = TokenSyntax(child) {
        SwiftCode(syntax: childSyntax)
      }
    }
  }
}

private struct Comment: View {
  let string: String
  var body: some View {
    Slipstream.Span(string)
      .textColor(.gray, darkness: 500)
  }
}

private struct Keyword: View {
  let string: String
  var body: some View {
    Slipstream.Span(string)
      .textColor(.pink, darkness: 700)
      .textColor(.pink, darkness: 400, condition: .dark)
  }
}

private struct Literal: View {
  let string: String
  var body: some View {
    Slipstream.Span(string)
      .textColor(.yellow, darkness: 400)
  }
}

private struct Quotes: View {
  let string: String
  var body: some View {
    Slipstream.Span(string)
      .textColor(.orange, darkness: 400)
  }
}

private struct Identifier: View {
  let string: String
  let keyPathInParent: AnyKeyPath?

  var body: some View {
    let span = Slipstream.Span(string)

    switch keyPathInParent {
    case \IdentifierTypeSyntax.name,
      \FunctionDeclSyntax.name:
      span
        .textColor(.palette(.pink, darkness: 600))
        .textColor(.palette(.pink, darkness: 400), condition: .dark)
    case \DeclReferenceExprSyntax.baseName:
      span
        .textColor(.palette(.purple, darkness: 600))
        .textColor(.palette(.purple, darkness: 400), condition: .dark)
    case \FunctionParameterSyntax.firstName,
      \LabeledExprSyntax.label:
      span
        .textColor(.palette(.purple, darkness: 500))
    case \StructDeclSyntax.name:
      span
        .textColor(.palette(.orange, darkness: 600))
        .textColor(.palette(.orange, darkness: 400), condition: .dark)
    case \IdentifierPatternSyntax.identifier,
      \TypeAliasDeclSyntax.name,
      \ClassDeclSyntax.name:
      span
        .textColor(.palette(.blue, darkness: 700))
        .textColor(.palette(.blue, darkness: 300), condition: .dark)
    case .none, \ObjCSelectorPieceSyntax.name:
      span
        .textColor(.palette(.zinc, darkness: 950))
        .textColor(.palette(.zinc, darkness: 50), condition: .dark)
    default:
      let _ = print("Unstyled key path:", keyPathInParent!, string)
      span
        .textColor(.palette(.green, darkness: 600))
        .textColor(.palette(.green, darkness: 400), condition: .dark)
    }
  }
}

private struct Trivia: View {
  let pieces: [TriviaPiece]
  var body: some View {
    for triviaPiece in pieces {
      switch triviaPiece {
      case .lineComment(let comment):
        Comment(string: comment)
      case .newlines(let count):
        Slipstream.Text(String.init(repeating: "\n", count: count))
      case .spaces(let count):
        Slipstream.Text(String.init(repeating: " ", count: count))
      case .tabs(let count):
        Slipstream.Text(String.init(repeating: " ", count: count * 2))
      default:
        let _ = print(triviaPiece)
        fatalError()
      }
    }
  }
}

