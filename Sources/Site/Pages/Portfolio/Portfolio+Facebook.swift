import Foundation

import Slipstream

extension Portfolio {
  struct Facebook: View {
    var body: some View {
      Div {
        MediumContainer {
          Div {
            H2 {
              HStack(alignment: .baseline, spacing: 8) {
                DOMString("Facebook")
                Small("for iPad")
                  .textColor(.text, darkness: 700)
                  .textColor(.text, darkness: 300, condition: .dark)
              }
            }
            .portfolioSectionHeader()
            .margin(.bottom, 4)

            Article("""
Jeff was the lead engineer on the first version of the Facebook iPad app. As the
person with the most knowledge of both Three20 and Facebook's iPhone codebase, he
was able to quickly and efficiently create a universal app that supported both the
iPad and the iPhone. 
""")
            Text("June 2010 - June 2011")
              .subtitleStyle()
              .margin(.bottom, Double.sectionMargin, condition: .desktop)
          }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 32)
      }
      .border(.init(.blue, darkness: 100), edges: .top)
      .border(.init(.blue, darkness: 900), edges: .top, condition: .dark)
      .border(.white, edges: .bottom)
      .border(.init(.zinc, darkness: 950), edges: .bottom, condition: .dark)
      .background(.blue, darkness: 50)
      .background(.blue, darkness: 950, condition: .dark)
    }
  }
}
