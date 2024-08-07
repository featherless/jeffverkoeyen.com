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
      if token.tokenKind.isPunctuation {
        Slipstream.Text(token.text)
      } else {
        switch token.tokenKind {
        case .keyword:
          Keyword(string: token.text)
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
        default:
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
      .textColor(.pink, darkness: 400)
  }
}

private struct Literal: View {
  let string: String
  var body: some View {
    Slipstream.Span(string)
      .textColor(.yellow, darkness: 400)
  }
}

private struct Identifier: View {
  let string: String
  let keyPathInParent: AnyKeyPath?

  var body: some View {
    Slipstream.Span(string)
      .textColor(identifierColor)
  }

  var identifierColor: Color {
    switch keyPathInParent {
    case \IdentifierTypeSyntax.name,
      \FunctionDeclSyntax.name,
      \DeclReferenceExprSyntax.baseName:
      return .palette(.purple, darkness: 300)
    case \FunctionParameterSyntax.firstName,
      \LabeledExprSyntax.label:
      return .palette(.purple, darkness: 500)
    case \StructDeclSyntax.name:
      return .palette(.orange, darkness: 400)
    case \IdentifierPatternSyntax.identifier,
      \TypeAliasDeclSyntax.name:
      return .palette(.blue, darkness: 400)
    case .none:
      return .palette(.zinc, darkness: 50)
    default:
      print("Unstyled key path:", keyPathInParent!, string)
      fatalError()
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
