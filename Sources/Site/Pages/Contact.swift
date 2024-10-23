import Foundation

import Slipstream

struct Contact: View {
  var body: some View {
    Page(
      path: "/contact",
      title: "contact",
      description: "Jeff Verkoeyen is best reached by email at jeff@featherless.design."
    ) {
      NarrowContainer {
        ResponsiveStack {
          Link(URL(string: "http://threads.net/@featherless")) {
            HStack(spacing: 8) {
              Image(URL(string: "/gfx/threads.svg"))
                .accessibilityLabel("The Threads app logo")
                .frame(width: 32, height: 32)
              DOMString("featherless")
            }
          }
          .fontSize(.extraExtraLarge)
          .fontWeight(500)
          .underline(condition: .hover)
          Link("jeff@featherless.design", destination: URL(string: "mailto:jeff@featherless.design"))
            .fontSize(.extraExtraLarge)
            .fontWeight(500)
            .underline(condition: .hover)
        }
        .alignItems(.center)
        .justifyContent(.evenly)
        .flexGap(.y, width: 16)
        .margin(.bottom, 32)
      }
      .textColor(.text, darkness: 950)
      .textColor(.text, darkness: 200, condition: .dark)
    }
  }
}
