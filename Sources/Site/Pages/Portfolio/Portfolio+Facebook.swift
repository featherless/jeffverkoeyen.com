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
                Text("Facebook")
                Small("for iPad")
                  .textColor(.text, darkness: 700)
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
            Paragraph("June 2010 - June 2011")
              .textColor(.text, darkness: 500)
              .margin(.bottom, Double.sectionMargin, condition: .desktop)
          }
        }
        .padding(.vertical, 32)
      }
      .border(.init(.blue, darkness: 100), edges: .top)
      .border(.white, edges: .bottom)
      .background(.blue, darkness: 50)
    }
  }
}
