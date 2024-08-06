import Foundation

import Markdown
import Slipstream

let sectionMargin = 16

private struct ContextAwareParagraph<Content: View>: View {
  @Environment(\.disableParagraphMargins) var disableParagraphMargins

  @ViewBuilder let content: () -> Content

  var body: some View {
    Slipstream.Paragraph {
      content()
    }
    .margin(.bottom, disableParagraphMargins ? 0 : sectionMargin)
  }
}

struct Article: View {
  init(_ text: String) {
    self.text = text
  }

  var body: some View {
    MarkdownText(text) { node, context in
      switch node {
      case let text as Markdown.Text:
        Slipstream.Text(text.string)
      case let heading as Markdown.Heading:
        switch heading.level {
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
      case is Markdown.OrderedList:
        Slipstream.List(ordered: true) {
          context.recurse()
            .environment(\.disableParagraphMargins, true)
        }
        .listStyle(.decimal)
        .padding(.left, 20)
        .margin(.bottom, sectionMargin)
      case is Markdown.UnorderedList:
        Slipstream.List(ordered: false) {
          context.recurse()
            .environment(\.disableParagraphMargins, true)
        }
        .listStyle(.disc)
        .padding(.left, 20)
        .margin(.bottom, sectionMargin)
      case is Markdown.ListItem:
        Slipstream.ListItem {
          context.recurse()
        }
      case let link as Markdown.Link:
        if let destination = link.destination {
          Slipstream.Link(URL(string: destination)) {
            context.recurse()
          }
          .textColor(.link, darkness: 700)
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
        .padding(.horizontal, 16)
        .padding(.horizontal, 24, condition: .desktop)
        .italic()
      case is Markdown.SoftBreak:
        Slipstream.Text("\n")
      default:
        let _ = print(node)
        context.recurse()
      }
    }
  }

  private let text: String
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
