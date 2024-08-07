import Foundation

import Slipstream

struct About: View {
  var body: some View {
    Page(
      path: "/about",
      title: "about",
      description: "Google Maps for iOS, Google iOS design leadership, Facebook iOS employee #3. Jeff Verkoeyen's professional history."
    ) {
      NarrowContainer {
        Div {
          ImagePuck(
            url: URL(string: "/gfx/jeff.jpg"),
            accessibilityLabel: "Photograph of Jeff Verkoeyen in Sedona",
            caption: "Jeff Verkoeyen, 2024"
          )
          .frame(width: 0.25)
          .frame(width: 0.41, condition: .desktop)

          Div {
            Text("Latest status")
              .fontSize(.small)
              .textColor(.text, darkness: 500)
            Text("Building a stealth startup")
              .textColor(.text, darkness: 950)
          }
          .margin(.top, 4)
          .margin(.bottom, 16)
          .margin(.horizontal, 28)
          .display(.inlineBlock)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .cornerRadius(.medium)
          .background(.white)
          .textAlignment(.center)

          Article("""
Leader. Designer. Polyglot engineer.

---

## Google iOS design leadership

For over a decade, Jeff was a key leader of Google's iOS design and developer
community. Jeff led UX engineering for the [initial launch of Google Maps for iOS](https://www.theverge.com/2012/12/12/3760770/google-maps-iphone-available-features-navigation-transit),
co-founded the team responsible for the company's iOS design and engineering guidance,
and was a vocal champion for building
[great Google products on Apple platforms](https://sixcolors.com/link/2021/10/googles-apps-to-embrace-ios-on-ios/).

> Jeff has one mission, which is to improve the design and user experience of Google products on Apple platforms. This is evident in every facet of his work and is having company wide impact across many PAs, orgs and teams.    
> \\- Leadership feedback, 2023

Jeff's relentless pursuit of quality-first software design empowered Google's iOS community
to tune product UX to people's needs and expectations on iOS.

### Related press

- [Much-needed Gmail redesign greatly simplifies settings on iOS](https://9to5google.com/2022/10/17/gmail-settings-redesign/) — 9to5Google
- [Google will stop trying to make its iOS apps look like Android apps](https://www.engadget.com/google-material-design-uikit-171651054.html) — Engadget, also reported by [The Verge](https://www.theverge.com/2021/10/12/22722130/google-ios-app-material-design-components-uikit), [AppleInsider](https://appleinsider.com/articles/21/10/12/google-dropping-material-design-in-ios-to-make-iphone-apps-look-more-like-they-should), [MacRumors](https://www.macrumors.com/2021/10/11/google-apps-for-ios-to-switch-to-uikit/)

If you've used a Google product on Apple platforms, you've used code built or influenced by Jeff's team.

Jeff quit Google in 2024. Stay tuned :)

---

## Facebook iOS, Three20, Nimbus, Google Maps for iOS

Prior to Google, Jeff was engineer #3 on Facebook's iOS engineering team. Jeff took
ownership of the most popular open source iOS project at the time, [Three20](http://github.com/facebookarchive/three20).
From 2010 to 2011, Jeff built v1 of the Facebook iPad app with [Brandon Walkin](http://brandonwalkin.com)
and had it demoed to Steve Jobs. Jeff left Facebook in 2011 to turn Three20 into
[Nimbus](http://github.com/jverkoey/nimbus), an open source framework whose growth was bounded
by the quality of its documentation.
""")

          Link(URL(string: "http://nimbuskit.info")) {
            Image(URL(string: "/gfx/nimbus128.png"))
              .accessibilityLabel("A red panda, the logo for the Nimbus open source framework")
          }
          .float(.right)
          .frame(width: 0.3)
          .frame(width: 0.25, condition: .desktop)
          .margin([.left, .bottom], 8)

          Article("""
> "Not only is Nimbus incredibly useful, but it serves as an exemplar of responsible development (a “framework whose feature set grows only as fast as its documentation” is an attitude I wish a lot more projects would adopt). Three cheers to Jeff Verkoeyen and all of the contributors for their hard work on this."    
> — Mattt Thompson (of [NSHipster](https://nshipster.com) and [AFNetworking](https://github.com/AFNetworking/AFNetworking))

In 2012 Jeff found himself in a room with [Vic Gundotra](https://en.wikipedia.org/wiki/Vic_Gundotra)
and [Bradley Horowitz](https://en.wikipedia.org/wiki/Bradley_Horowitz). Google+ had just spun up,
and Jeff became one of the few engineers that [left Facebook to join Google](https://www.theverge.com/2011/9/27/2453784/facebook-engineer-hits-the-road-for-google-over-ipad-app)
at the time (most were doing the opposite). After one month on the Google+ iPad project, and
another few months on the Google+ Games SDK, [Apple announced](https://www.theguardian.com/technology/2012/may/11/apple-maps-io6-google)
that they were going to stop using Google Maps for their native Maps app.
""")

          Link(URL(string: "https://apps.apple.com/us/app/google-maps/id585027354")) {
            Image(URL(string: "/gfx/gmm_icon@2x.png"))
              .accessibilityLabel("The original Google Maps for iOS app icon from 2012")
          }
          .float(.right)
          .frame(width: 0.3)
          .frame(width: 0.25, condition: .desktop)
          .margin([.left, .bottom], 16)
          .margin(.top, 4)

          Article("""
Within a week, Jeff found and joined the team that would end up launching six months later
one of the industry’s most well received, stable, and polished v1 apps to date:
[Google Maps for iOS](https://apps.apple.com/us/app/google-maps/id585027354). He was lucky to
join what became Google’s internal "iOS mafia", a crew of whom many were still at Google more than a
decade later, and many continued to lead critical iOS efforts across the company.

> Jeff not only designed and implemented a large chunk of the Maps UI, but he was also a key
> player in doing code reviews for the other members of the team. Basically any change to the
> UI has Jeff's name on it as either the implementor or the reviewer.    
> — Leadership feedback, 2012

As one of the team’s most experienced UX/UI engineers, Jeff worked closely with design and
engineering to build a set of modular UI components that would go on to form the
foundation of the company’s iOS apps, eventually becoming a core part of what is now
publicly known as [Material design](http://material.io).

### Related press

- [Google Maps is now available for iPhone](https://blog.google/products/maps/google-maps-is-now-available-for-iphone/) — Google, 2012
- [Google Maps for iPhone](https://daringfireball.net/2012/12/google_maps_iphone) — Daring Fireball, 2012
- [Google Maps for iPhone is here: how data and design beat Apple](https://www.theverge.com/2012/12/12/3760770/google-maps-iphone-available-features-navigation-transit) — The Verge, 2012
- [Webby and People’s Voice for Best User Experience](https://www.webbyawards.com/press/press-releases/the-17th-annual-webby-award-winners-announced/) — Webby Awards, 2013
""")

          ImagePuck(
            url: URL(string: "/gfx/family.jpg"),
            accessibilityLabel: "Photograph of Jeff with his wife and daughter",
            caption: "Family, 2023"
          )
          .frame(width: 0.41)

          Article("""
---

## Family and travel

Jeff lives in [Montecito](https://santabarbaraca.com/explore-and-discover-santa-barbara/neighborhoods-towns/montecito/)
with Nina, Eva, and Buddha (the cat).

Prior to Montecito, Jeff traveled all over the world, from
South America to New Zealand, Europe to Southeast Asia. Of
everywhere he's been, Montecito is his favorite.
""")
        }
        .padding(.left, 8)
        .margin(.bottom, 32)
      }
      .textColor(.text, darkness: 950)
      .textColor(.text, darkness: 200, condition: .dark)
    }
  }
}
