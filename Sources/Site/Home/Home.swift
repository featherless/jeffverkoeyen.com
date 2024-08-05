import Foundation

import Slipstream

private struct Hero: View {
  var body: some View {
    H1 {
      Text("featherless")
      Linebreak()
      Text("software design")
    }
    .textAlignment(.right)
    .padding(.bottom, 16)
    .padding(.bottom, 0, condition: .desktop)
    .margin(.horizontal, .auto, condition: .desktop)
    .fontWeight(300)

    // Mobile layout
    .fontSize(40)
    .padding(.top, 75)
    .margin(.left, 45)
    .backgroundImage(
      URL(string: "/gfx/feather.svg"),
      size: .size(width: 184, height: 184),
      repeat: .no
    )

    // Desktop layout
    .fontSize(48, condition: .desktop)
    .padding(.top, 125, condition: .desktop)
    .padding(.left, 150, condition: .desktop)
    .padding(.right, 48, condition: .desktop)
    .backgroundImage(
      URL(string: "/gfx/feather.svg"),
      size: .size(width: 256, height: 256),
      condition: .desktop
    )
  }
}

private struct NavigationLinks: View {
  var body: some View {
    Div {
      HomeLink("portfolio", destination: URL(string: "/portfolio"))
      HomeLink("blog", destination: URL(string: "http://blog.jeffverkoeyen.com/"))
      HomeLink("contact", destination: URL(string: "/contact"))
      HomeLink("about", destination: URL(string: "/about"))
    }
    .fontSize(32)
    .fontWeight(300)
    .textAlignment(.right)
    .display(.flex)
    .flexDirection(.y)
    .flexGap(.y, width: 8)
    .textAlignment(.center, condition: .desktop)
    .flexDirection(.x, condition: .desktop)
    .flexGap(.x, width: 8, condition: .desktop)
    .justifyContent(.center)
    .alignItems(.end)
    .alignItems(.start, condition: .desktop)
  }
}

struct Home: View {
  var body: some View {
    Page(description: "Jeff Verkoeyen is a software designer under the alias featherless@.") {
      Container {
        VStack(spacing: 8) {
          Hero()
          NavigationLinks()
        }
      }
      .textColor(.zinc, darkness: 950)
      .fontDesign("rounded")
    }
  }
}
