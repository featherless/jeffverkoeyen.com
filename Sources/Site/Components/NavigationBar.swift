import Foundation

import Slipstream

struct NavigationBar: View {
  var body: some View {
    NarrowContainer {
      Navigation {
        HStack {
          Div {
            NavigationLinks()
          }
          .fontSize(.base, condition: .desktop)
          .fontSize(.large, condition: .desktop)
          .display(.flex)
          .flexDirection(.y)
          .flexGap(.y, width: 4)
          .flexDirection(.x, condition: .desktop)
          .flexGap(.x, width: 16, condition: .desktop)
          .margin(.top, 8, condition: .mobileOnly)
          
          Div {
            Link(URL(string: "/")) {
              SiteTitle()
            }
          }
          .textAlignment(.right)
          .padding(.bottom, 10)
          .margin(.horizontal, .auto, condition: .desktop)
          .fontLeading(.tight)
          .padding(.top, 44)
          .padding(.left, 51)
          .background(
            URL(string: "/gfx/feather.svg"),
            size: .size(width: 96, height: 96),
            repeat: .no
          )
        }
        .justifyContent(.between)
        .alignItems(.end)
        .fontWeight(300)
        .fontDesign("rounded")
      }
    }
    .textColor(.zinc, darkness: 950)
    .margin(.bottom, 32)
  }
}
