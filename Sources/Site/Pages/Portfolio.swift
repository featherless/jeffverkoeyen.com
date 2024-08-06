import Foundation

import Slipstream

struct Portfolio: View {
  var body: some View {
    Page(
      path: "/portfolio",
      title: "portfolio",
      description: "Jeff Verkoeyen's catalog of open source efforts, company initiatives, teams, and launches."
    ) {
      Container {
        HStack(spacing: 16) {
          VStack(alignment: .center) {
            Image(URL(string: "/gfx/gmm_icon@2x.png"))
              .accessibilityLabel("The original Google Maps for iOS app icon from 2012")
            Link(URL(string: "https://itunes.apple.com/us/app/google-maps/id585027354?mt=8")) {
              Image(URL(string: "/gfx/appstore.svg"))
                .accessibilityLabel("Download Google Maps for iOS on the App Store")
            }
            .padding(16)
          }
          .frame(width: 0.25)

          VStack {
            H2 {
              HStack(alignment: .baseline, spacing: 8) {
                Text("Google Maps")
                Small("for iPhone")
                  .textColor(.text, darkness: 700)
              }
            }
            .fontSize(.fourXLarge)
            .fontDesign("rounded")
            .margin(.bottom, 4)

            Article("""
Jeff led UX engineering for the launch of Google Maps for iOS.

Applying lessons learned from Facebook, Three20, and Nimbus,
Jeff's leadership enabled the code for Google Maps to form the
iOS foundation of what became publicly known as
[Material](http://material.ios). 
""")
            Paragraph("June 2012 - April 2013")
              .textColor(.text, darkness: 500)
              .margin(.bottom, sectionMargin)
          }
          .frame(width: 0.75)
        }

        HorizontalRule()
          .margin(.vertical, 8)

        HStack(spacing: 16) {
          VStack(spacing: 8) {
            HStack(alignment: .baseline, spacing: 16) {
              Link("Mobile App of the Year", destination: URL(string: "https://techcrunch.com/events/crunchies-2012/winners/"))
                .underline(condition: .hover)
              Small("Crunchies 2012")
                .textColor(.text, darkness: 500)
            }
            HStack(alignment: .baseline, spacing: 16) {
              Link("Best User Experience", destination: URL(string: "https://www.webbyawards.com/press/press-releases/the-17th-annual-webby-award-winners-announced/"))
                .underline(condition: .hover)
              Small("Webby Awards 2013")
                .textColor(.text, darkness: 500)
            }
          }
          .fontSize(.extraExtraExtraLarge)
          .frame(width: 0.75)

          Image(URL(string: "/gfx/webby.png"))
            .accessibilityLabel("Webby award winner badge")
            .frame(width: 0.25)
        }
        .margin(.vertical, 16)
      }
      .textColor(.text, darkness: 950)
      .padding(.top, 8)
      .padding(.horizontal, 104, condition: .desktop)
    }
  }
}
