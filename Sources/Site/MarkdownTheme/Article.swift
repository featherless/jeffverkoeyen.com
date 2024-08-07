import Foundation

import Markdown
import Slipstream
import SwiftParser
import SwiftSyntax

private struct ContextAwareParagraph<Content: View>: View {
  @Environment(\.disableParagraphMargins) var disableParagraphMargins

  @ViewBuilder let content: () -> Content

  var body: some View {
    Slipstream.Paragraph {
      content()
    }
    .margin(.bottom, disableParagraphMargins ? 0 : .sectionMargin)
  }
}

struct Article: View {
  init(_ text: String) {
    self.document = Document(parsing: text)
  }

  init(_ document: Document) {
    self.document = document
  }

  var body: some View {
    MarkdownText(document) { node, context in
      switch node {
      case let text as Markdown.Text:
        Slipstream.Text(text.string)

      case let codeBlock as Markdown.CodeBlock:
        Slipstream.Preformatted {
          SwiftCode(code: codeBlock.code)
        }
        .textColor(.zinc, darkness: 950)
        .textColor(.zinc, darkness: 50, condition: .dark)
        .padding(16)
        .border(.init(.zinc, darkness: 300))
        .border(.init(.zinc, darkness: 700), condition: .dark)
        .cornerRadius(.medium)
        .margin(.bottom, Double.sectionMargin)
        .fontDesign(.mono)
        .background(.zinc, darkness: 200)
        .background(.black, condition: .dark)
        .fontSize(.small)
        .modifier(ClassModifier(add: "overflow-scroll"))

      case let inlineCode as Markdown.InlineCode:
        Slipstream.Code {
          SwiftCode(code: inlineCode.code)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(.zinc, darkness: 200)
        .background(.zinc, darkness: 800, condition: .dark)
        .fontWeight(500)
        .cornerRadius(.medium)

      case let heading as Markdown.Heading:
        switch heading.level {
        case 1:
          Slipstream.Heading(level: heading.level) {
            context.recurse()
          }
          .fontSize(.extraExtraExtraLarge)
          .bold()
          .margin(.bottom, 8)
        case 2:
          Slipstream.Heading(level: heading.level) {
            context.recurse()
          }
          .fontSize(.large)
          .bold()
          .margin(.bottom, 4)
        case 3:
          Slipstream.Heading(level: heading.level) {
            context.recurse()
          }
          .bold()
          .margin(.bottom, 4)
        default:
          Slipstream.Heading(level: heading.level) {
            context.recurse()
          }
        }

      case is Markdown.Paragraph:
        ContextAwareParagraph {
          context.recurse()
        }

      case is Markdown.Strong:
        Span {
          context.recurse()
        }
        .bold()

      case is Markdown.Emphasis:
        Span {
          context.recurse()
        }
        .italic()

      case is Markdown.OrderedList:
        Slipstream.List(ordered: true) {
          context.recurse()
            .environment(\.disableParagraphMargins, true)
        }
        .listStyle(.decimal)
        .padding(.left, 32)
        .margin(.bottom, Double.sectionMargin)

      case is Markdown.UnorderedList:
        Slipstream.List(ordered: false) {
          context.recurse()
            .environment(\.disableParagraphMargins, true)
        }
        .listStyle(.disc)
        .padding(.left, 20)
        .margin(.bottom, Double.sectionMargin)

      case is Markdown.ListItem:
        Slipstream.ListItem {
          context.recurse()
        }

      case let image as Markdown.Image:
        if let destination = image.source {
          Div {
            Slipstream.Image(URL(string: destination))
              .accessibilityLabel(image.title ?? "")
              .border(.white, width: 4)
              .border(.init(.zinc, darkness: 700), width: 4, condition: .dark)
              .cornerRadius(.extraExtraLarge)
              .modifier(ClassModifier(add: "shadow-puck"))
          }
          .padding(.horizontal, 16)
          .margin(.bottom, Double.sectionMargin)
        }

      case let html as Markdown.InlineHTML:
        Slipstream.Text(html.plainText)

      case let link as Markdown.Link:
        if let destination = link.destination {
          Slipstream.Link(URL(string: destination)) {
            context.recurse()
          }
          .textColor(.link, darkness: 700)
          .textColor(.link, darkness: 400, condition: .dark)
          .fontWeight(600)
          .underline(condition: .hover)
        } else {
          context.recurse()
        }

      case is Markdown.ThematicBreak:
        HorizontalRule()

      case is Markdown.LineBreak:
        Linebreak()

      case is Markdown.BlockQuote:
        Blockquote {
          context.recurse()
        }
        .border(.palette(.zinc, darkness: 300), width: 1, edges: .left)
        .border(.palette(.zinc, darkness: 500), width: 1, edges: .left, condition: .dark)
        .padding(.horizontal, 16)
        .padding(.horizontal, 24, condition: .desktop)
        .margin(.bottom, Double.sectionMargin)
        .italic()

      case is Markdown.SoftBreak:
        Slipstream.Text("\n")

      default:
        let _ = print(node)
        context.recurse()
      }
    }
  }

  private let document: Document
}

private struct DisableParagraphMarginsEnvironmentKey: EnvironmentKey {
  static let defaultValue: Bool = false
}

extension EnvironmentValues {
  var disableParagraphMargins: Bool {
    get { self[DisableParagraphMarginsEnvironmentKey.self] }
    set { self[DisableParagraphMarginsEnvironmentKey.self] = newValue }
  }
}

