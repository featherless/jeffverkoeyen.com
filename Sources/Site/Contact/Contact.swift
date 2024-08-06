import Foundation

import Slipstream

struct Contact: View {
  var body: some View {
    Page(
      path: "/contact",
      title: "contact",
      description: "Jeff Verkoeyen is best reached by email at jverkoey@gmail.com."
    ) {
      NarrowContainer {
        HStack {
          Link(URL(string: "http://threads.net/@featherless")) {
            HStack(spacing: 8) {
              Image(URL(string: "/gfx/threads.svg"))
                .accessibilityLabel("The Threads app logo")
                .frame(width: 32, height: 32)
              Text("featherless")
            }
          }
          .fontSize(.extraExtraLarge)
          .fontWeight(500)
          .underline(condition: .hover)
          Link("jverkoey@gmail.com", destination: URL(string: "mailto:jverkoey@gmail.com"))
            .fontSize(.extraExtraLarge)
            .fontWeight(500)
            .underline(condition: .hover)
        }
        .justifyContent(.evenly)
        .margin(.bottom, 32)
      }
      .textColor(.zinc, darkness: 900)
    }
  }
}
