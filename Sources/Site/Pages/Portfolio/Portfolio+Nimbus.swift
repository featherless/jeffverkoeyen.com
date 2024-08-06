import Foundation

import Slipstream

extension Portfolio {
  struct Nimbus: View {
    var body: some View {
      Div {
        MediumContainer {
          Div {
            VStack(alignment: .center) {
              Image(URL(string: "/gfx/nimbus128.png"))
                .accessibilityLabel("A red panda, the logo for the Nimbus open source framework")
                .margin(.bottom, 4)
              Div {
                Paragraph("1299 forks")
                  .id("nimbus_forks")
                Paragraph("6452 followers")
                  .id("nimbus_followers")
              }
              .textColor(.text, darkness: 500)
              .fontSize(.small, condition: .mobileOnly)
            }
            .float(.right)
            .margin([.left, .bottom], 16)
            .frame(width: 0.25, condition: .desktop)

            Div {
              H2("Nimbus")
                .portfolioSectionHeader()
                .margin(.bottom, 8)

              Article("""
The iOS framework that grew only as fast as its documentation.

Nimbus was the successor to Three20. Its focus on documentation and modular architecture carried into Jeff's work at Google, helping establish a similarly expansive set of components and design guidance for all of Google' iOS applications.

As of 2024, Nimbus is still [one of the top Objective-C
projects on GitHub](https://github.com/EvanLi/Github-Ranking/blob/master/Top100/Objective-C.md).
""")
              Paragraph("June 2011 - May 2024")
                .textColor(.text, darkness: 500)
                .margin(.bottom, Double.sectionMargin, condition: .desktop)
            }
          }
        }
        .padding(.vertical, 32)
      }
      .border(.init(.orange, darkness: 100), edges: .top)
      .border(.white, edges: .bottom)
      .background(.orange, darkness: 50)
    }
  }
}
