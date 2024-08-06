import Foundation

import Slipstream

struct NavigationBar: View {
  var body: some View {
    NarrowContainer {
      Navigation {
        HStack(alignment: .end) {
          Div {
            NavigationLinks()
          }
          .fontSize(.base, condition: .desktop)
          .fontSize(.large, condition: .desktop)
          .display(.flex)
          .alignItems(.end)

          .flexDirection(.y)
          .flexGap(.y, width: 4)
          .margin(.top, 8, condition: .mobileOnly)

          .flexDirection(.x, condition: .desktop)
          .flexGap(.x, width: 16, condition: .desktop)
          .alignItems(.start, condition: .desktop)

          Div {
            Link(URL(string: "/")) {
              SiteTitle()
            }
          }
          .textAlignment(.right)
          .padding(.bottom, 8, condition: .desktop)
          .margin(.bottom, 1, condition: .desktop)
          .margin(.horizontal, .auto, condition: .desktop)
          .fontLeading(.tight)
          .padding(.top, 44)
          .padding(.left, 51)
          .background(
            URL(string: "/gfx/feather.svg"),
            size: .size(width: 96, height: 96),
            repeat: .no
          )
          .background(URL(string: "/gfx/feather-dark.svg"), condition: .dark)
        }
        .flexDirection(.x, reversed: true, condition: .mobileOnly)
        .justifyContent(.between)
        .fontWeight(300)
        .fontDesign("rounded")
      }
    }
    .textColor(.text, darkness: 950)
    .textColor(.text, darkness: 50, condition: .dark)
    .margin(.bottom, 32)
  }
}
