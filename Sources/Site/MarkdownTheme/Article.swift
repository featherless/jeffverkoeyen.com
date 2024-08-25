import Foundation

import Markdown
import Slipstream
import SwiftParser
import SwiftSyntax

private enum TableContext {
  case header
  case body
}

private struct TableContextEnvironmentKey: EnvironmentKey {
  static let defaultValue: TableContext = .body
}

extension EnvironmentValues {
  fileprivate var tableContext: TableContext {
    get { self[TableContextEnvironmentKey.self] }
    set { self[TableContextEnvironmentKey.self] = newValue }
  }
}

private struct ContextAwareTableCell<Content: View>: View {
  @Environment(\.tableContext) var tableContext

  @ViewBuilder let content: () -> Content

  var body: some View {
    switch tableContext {
    case .header:
      Slipstream.TableHeaderCell {
        content()
      }
      .padding(8)
      .background(.zinc, darkness: 200)
      .background(.zinc, darkness: 900, condition: .dark)
      .textAlignment(.center)
      .className("first:rounded-tl-lg")
      .className("last:rounded-tr-lg")
    case .body:
      Slipstream.TableCell {
        content()
      }
      .padding(.horizontal, 8)
      .padding(.horizontal, 24, condition: .desktop)
      .padding(.vertical, 16)
      .textAlignment(.center)
    }
  }
}

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

extension Markdown.Heading {
  var headerID: String {
    // From https://docs.gitlab.com/ee/user/markdown.html#header-ids-and-links
    return plainText
      .lowercased()
      .replacingOccurrences(of: " ", with: "-")
      .filter { $0.isLetter || $0.isNumber || $0 == "-" }
      .replacingOccurrences(of: "--", with: "-")
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
        Slipstream.DOMString(text.string)

      case let codeBlock as Markdown.CodeBlock:
        Slipstream.Preformatted {
          if codeBlock.language == "swift" {
            SwiftCode(code: codeBlock.code)
          } else {
            DOMString(codeBlock.code)
          }
        }
        .textColor(.zinc, darkness: 950)
        .textColor(.zinc, darkness: 50, condition: .dark)
        .fontWeight(500)
        .padding(16)
        .border(.init(.zinc, darkness: 300))
        .border(.init(.zinc, darkness: 700), condition: .dark)
        .cornerRadius(.medium)
        .margin(.bottom, Double.sectionMargin)
        .fontDesign(.monospaced)
        .background(.zinc, darkness: 200)
        .background(.black, condition: .dark)
        .fontSize(.extraSmall)
        .fontSize(.small, condition: .desktop)
        .modifier(ClassModifier(add: "overflow-scroll"))

      case let inlineCode as Markdown.InlineCode:
        Slipstream.Code {
          SwiftCode(code: inlineCode.code)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .fontLeading(.loose)
        .background(.zinc, darkness: 200)
        .background(.zinc, darkness: 800, condition: .dark)
        .fontWeight(500)
        .cornerRadius(.medium)

      case let heading as Markdown.Heading:
        let id = heading.headerID
        switch heading.level {
        case 1:
          Slipstream.Heading(level: heading.level) {
            context.recurse()
          }
          .fontSize(.extraExtraExtraLarge)
          .fontLeading(.snug)
          .bold()
          .margin(.bottom, 8)
          .fontDesign("rounded")
          .id(id)
        case 2:
          Slipstream.Heading(level: heading.level) {
            Slipstream.Link(URL(string: "#\(id)")) {
              Slipstream.Text("#")
            }
            .hidden()
            .className("group-hover:flex")
            .position(.absolute)
            .className("-left-4")
            .frame(width: 16, height: 16)
            context.recurse()
          }
          .className("group")
          .position(.relative)
          .fontSize(.large)
          .bold()
          .margin(.bottom, 4)
          .id(id)
        case 3:
          Slipstream.Heading(level: heading.level) {
            Slipstream.Link(URL(string: "#\(id)")) {
              Slipstream.Text("#")
            }
            .hidden()
            .className("group-hover:flex")
            .position(.absolute)
            .className("-left-4")
            .frame(width: 16, height: 16)
            context.recurse()
          }
          .className("group")
          .position(.relative)
          .bold()
          .margin(.bottom, 4)
          .id(id)
        default:
          Slipstream.Heading(level: heading.level) {
            Slipstream.Link(URL(string: "#\(id)")) {
              Slipstream.Text("#")
            }
            .hidden()
            .className("group-hover:flex")
            .position(.absolute)
            .className("-left-4")
            .frame(width: 16, height: 16)
            context.recurse()
          }
          .className("group")
          .position(.relative)
          .id(id)
        }

      case let paragraph as Markdown.Paragraph:
        if paragraph.plainText.hasPrefix("Note:") {
          Div {
            ContextAwareParagraph {
              context.recurse()
            }
            .padding(8)
            .background(.orange, darkness: 200)
            .background(.orange, darkness: 950, condition: .dark)
            .fontWeight(500)
            .cornerRadius(.medium)
            .italic()
            .fontSize(.small)
          }
        } else {
          ContextAwareParagraph {
            context.recurse()
          }
        }

      case let table as Markdown.Table:
        Div {
          Slipstream.Table {
            Slipstream.TableHeader {
              context.recurseDetached(into: table.head)
                .environment(\.tableContext, .header)
            }

            Slipstream.TableBody {
              context.recurseDetached(into: table.body)
                .environment(\.tableContext, .body)
            }
          }
        }
        .display(.table)
        .margin(.horizontal, .auto)
        .fontSize(.extraSmall, condition: .mobileOnly)
        .margin(.bottom, Double.sectionMargin)
        .border(Slipstream.Color(.zinc, darkness: 300))
        .border(Slipstream.Color(.zinc, darkness: 700), condition: .dark)
        .cornerRadius(.large)

      case is Markdown.Table.Row:
        Slipstream.TableRow {
          context.recurse()
        }
        .border(Slipstream.Color(.zinc, darkness: 200), edges: .bottom)
        .border(Slipstream.Color(.zinc, darkness: 800), edges: .bottom, condition: .dark)
        .border(Slipstream.Color(.zinc, darkness: 800), width: 0, edges: .bottom, condition: .init(state: .last))

      case is Markdown.Table.Cell:
        ContextAwareTableCell {
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
              .accessibilityLabel(image.plainText)
              .border(.white, width: 4)
              .border(.init(.zinc, darkness: 700), width: 4, condition: .dark)
              .cornerRadius(.extraExtraLarge)
              .modifier(ClassModifier(add: "shadow-puck"))
              .margin(.horizontal, .auto)
              .frame(maxHeight: 400)
          }
          .padding(.horizontal, 16)
          .margin(.bottom, Double.sectionMargin)
        }

      case let html as Markdown.InlineHTML:
        Slipstream.DOMString(html.plainText)

      case let html as Markdown.HTMLBlock:
        Div {
          Slipstream.RawHTML(html.rawHTML)
        }
        .margin(.bottom, Double.sectionMargin)

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
        Slipstream.DOMString("\n")

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

