import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(title: String? = nil, description: String, content: @escaping () -> Content) {
    self.title = title
    self.description = description
    self.content = content
  }

  private let title: String?
  private let description: String
  private let content: () -> Content

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
        content()
      }
      .antialiased()
    }
    .language("en")
  }
}
