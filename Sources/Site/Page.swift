import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(
    path: String,
    title: String? = nil,
    description: String,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.content = content
  }

  private let path: String
  private let title: String?
  private let description: String
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
        Meta(.description, content: description)
        Meta(.generator, content: "Slipstream")
        Meta(.author, content: "Jeff Verkoeyen")
        Preload(URL(string: "/gfx/feather.svg"), as: .image)
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
              VStack(spacing: 16) {
                Link(URL(string: "https://github.com/jverkoey/slipstream")) {
                  Image(URL(string: "/gfx/built-with-slipstream.svg"))
                    .accessibilityLabel("Built with Slipstream")
                }
                .modifier(ClassModifier(add: "cursor-pointer"))
                VStack {
                  Paragraph("Copyright © 2002-\(Calendar.current.component(.year, from: Date())) Jeff Verkoeyen")
                    .textColor(.zinc, darkness: 600)
                }
                .alignItems(.end)
              }
              .justifyContent(.between)
              .alignItems(.center)
            }
            .padding(.vertical, 32)
          }
          .border(.palette(.zinc, darkness: 300), width: 1, edges: .top)
          .background(.zinc, darkness: 200)
        }
      }
      .background(.gray, darkness: 100)
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
