import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(
    path: String,
    title: String? = nil,
    description: String? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.content = content
  }

  private let path: String
  private let title: String?
  private let description: String?
  @ViewBuilder private let content: () -> Content

  var body: some View {
    HTML {
      Head {
        Charset(.utf8)
        if let title {
          Title("\(title) — featherless software design")
        } else {
          Title("featherless software design")
        }
        Viewport.mobileFriendly
        if let description {
          Meta(.description, content: description)
        }
        Meta(.generator, content: "Slipstream")
        Meta(.author, content: "Jeff Verkoeyen")
        Preload(URL(string: "/gfx/feather.svg"), as: .image)
        Preload(URL(string: "/gfx/feather-dark.svg"), as: .image)
        Stylesheet(URL(string: "/css/main.css"))
      }
      Body {
        Div {
          if path != "/" {
            NavigationBar()
          }
          content()
        }
        .frame(minHeight: .screen)

        if path != "/" {
          Footer {
            Container {
              VStack(alignment: .center, spacing: 16) {
                Link(URL(string: "https://github.com/jverkoey/slipstream")) {
                  Image(URL(string: "/gfx/built-with-slipstream.svg"))
                    .accessibilityLabel("Built with Slipstream")
                }
                .modifier(ClassModifier(add: "cursor-pointer"))
                VStack(alignment: .end) {
                  Paragraph("Copyright © 2002-\(Calendar.current.component(.year, from: Date())) Jeff Verkoeyen")
                    .textColor(.text, darkness: 600)
                    .textColor(.text, darkness: 300, condition: .dark)
                }
              }
              .justifyContent(.between)
            }
            .padding(.vertical, 32)
          }
          .border(.palette(.border, darkness: 300), width: 1, edges: .top)
          .border(.palette(.border, darkness: 700), width: 1, edges: .top, condition: .dark)
          .background(.zinc, darkness: 200)
          .background(.zinc, darkness: 800, condition: .dark)
        }
      }
      .background(.gray, darkness: 100)
      .background(.zinc, darkness: 950, condition: .dark)
      .antialiased()
    }
    .language("en")
    .environment(\.path, path)
  }
}

private struct PathEnvironmentKey: EnvironmentKey {
  static let defaultValue: String = "/"
}

extension EnvironmentValues {
  var path: String {
    get { self[PathEnvironmentKey.self] }
    set { self[PathEnvironmentKey.self] = newValue }
  }
}
