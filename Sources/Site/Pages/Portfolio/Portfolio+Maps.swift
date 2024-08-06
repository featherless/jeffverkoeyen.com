import Foundation

import Slipstream

extension Portfolio {
  struct Maps: View {
    var body: some View {
      MediumContainer {
        ResponsiveStack(.y, spacing: 16) {
          ResponsiveStack(.x) {
            Image(URL(string: "/gfx/gmm_icon@2x.png"))
              .accessibilityLabel("The original Google Maps for iOS app icon from 2012")
              .frame(width: 94, height: 94)
              .frame(width: 172, height: 172, condition: .desktop)
            Link(URL(string: "https://itunes.apple.com/us/app/google-maps/id585027354?mt=8")) {
              Image(URL(string: "/gfx/AppStore.png"))
                .accessibilityLabel("Download Google Maps for iOS on the App Store")
            }
            .frame(width: 0.3, condition: .mobileOnly)
            .modifier(ClassModifier(add: "cursor-pointer"))
            .padding([.top, .horizontal], 16, condition: .desktop)
            .padding(.bottom, 4, condition: .mobileOnly)
          }
          .flexGap(.x, width: 16)
          .alignItems(.end)
          .alignItems(.center, condition: .desktop)
          .frame(width: 0.25, condition: .desktop)

          VStack {
            H2 {
              HStack(alignment: .baseline, spacing: 8) {
                Text("Google Maps")
                Small("for iPhone")
                  .textColor(.text, darkness: 700)
                  .textColor(.text, darkness: 300, condition: .dark)
              }
            }
            .portfolioSectionHeader()
            .margin(.bottom, 4)

            Article("""
Jeff led UX engineering for the launch of Google Maps for iOS.

Applying lessons learned from Facebook, Three20, and Nimbus,
Jeff's leadership enabled the code for Google Maps to form the
iOS foundation of what became publicly known as
[Material](http://material.ios).
""")
            Paragraph("June 2012 - April 2013")
              .subtitleStyle()
              .margin(.bottom, Double.sectionMargin, condition: .desktop)
          }
          .frame(width: 0.75, condition: .desktop)
        }
        .alignItems(.start)
        .alignItems(.center, condition: .desktop)
        .padding(.bottom, 8, condition: .desktop)
        .margin(.bottom, Double.sectionMargin)

        HorizontalRule()
          .margin(.vertical, Double.sectionMargin)

        ResponsiveStack {
          VStack {
            HStack(alignment: .baseline, spacing: 16) {
              Link("Mobile App of the Year", destination: URL(string: "https://techcrunch.com/events/crunchies-2012/winners/"))
                .underline(condition: .hover)
              Small("Crunchies 2012")
                .subtitleStyle()
            }
            HStack(alignment: .baseline, spacing: 16) {
              Link("Best User Experience", destination: URL(string: "https://www.webbyawards.com/press/press-releases/the-17th-annual-webby-award-winners-announced/"))
                .underline(condition: .hover)
              Small("Webby Awards 2013")
                .subtitleStyle()
            }
          }
          .modifier(ClassModifier(add: "max-md:self-stretch"))
          .flexGap(.y, width: 0)
          .flexGap(.y, width: 8, condition: .desktop)
          .fontDesign("rounded")
          .fontSize(.large)
          .fontSize(.extraExtraExtraLarge, condition: .desktop)
          .frame(width: 0.75, condition: .desktop)

          Image(URL(string: "/gfx/webby.png"))
            .accessibilityLabel("Webby award winner badge")
            .frame(width: 64, height: 64)
            .frame(width: 177, height: 177, condition: .desktop)
        }
        .flexGap(.y, width: 8)
        .flexGap(.x, width: .sectionMargin, condition: .desktop)
        .alignItems(.center)
        .margin(.vertical, 16)
      }
      .padding(.horizontal, 16)
      .padding(.top, 8)
    }
  }
}
