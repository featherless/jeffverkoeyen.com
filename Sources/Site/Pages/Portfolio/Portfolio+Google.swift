import Foundation

import Slipstream

private struct AppView: View {
  let path: String
  let name: String
  var body: some View {
    VStack(alignment: .center) {
      Image(URL(string: path))
        .cornerRadius(.large)
        .frame(width: 64, height: 64)
        .border(.white, width: 4)
        .cornerRadius(.extraExtraLarge)
        .modifier(ClassModifier(add: "shadow-puck"))
        .margin(.bottom, 4)
      Paragraph(name)
        .fontSize(.small)
        .textColor(.text, darkness: 700)
    }
    .margin(8)
  }
}

extension Portfolio {
  struct Google: View {
    let googleApps = [
      "/gfx/google/calendar.webp": "Calendar",
      "/gfx/google/chat.webp": "Chat",
      "/gfx/google/chrome.webp": "Chrome",
      "/gfx/google/docs.webp": "Docs",
      "/gfx/google/drive.webp": "Drive",
      "/gfx/google/gmail.webp": "Gmail",
      "/gfx/google/google.webp": "Google",
      "/gfx/google/home.webp": "Home",
      "/gfx/google/keep.webp": "Keep",
      "/gfx/google/maps.webp": "Maps",
      "/gfx/google/meet.webp": "Meet",
      "/gfx/google/photos.webp": "Photos",
      "/gfx/google/sheets.webp": "Sheets",
      "/gfx/google/slides.webp": "Slides",
      "/gfx/google/tasks.webp": "Tasks",
      "/gfx/google/translate.webp": "Translate",
      "/gfx/google/youtube.webp": "YouTube",
      "/gfx/google/youtubekids.webp": "YT Kids",
      "/gfx/google/youtubemusic.webp": "YT Music",
    ]

    var body: some View {
      Div {
        MediumContainer {
          Div {
            H2 {
              HStack(alignment: .baseline, spacing: 8) {
                Text("Google")
                Small("Apple platforms design leadership")
                  .textColor(.text, darkness: 700)
              }
            }
            .portfolioSectionHeader()
            .margin(.bottom, 8)

            Article("""
For ten years, Jeff played a critical leadership role in Google's Apple platforms community. His
team of engineers and designers set out to strike the balance between Apple's Human Interface
Guidelines and the design guidance coming out of Android.

> Jeff and his team are some of the most responsive and helpful people we have worked with. His dedication to be a reliable center piece of most applications, to help all of us in adopting new UX guidelines, was a cornerstone in my team reaching their goals.    
> — Google Photos leadership feedback

If you've used a Google product on Apple platforms, you've used code owned by Jeff's team.
""")
            Paragraph("2014 - 2024")
              .textColor(.text, darkness: 500)
              .margin(.bottom, Double.sectionMargin)
              .textAlignment(.center)

            HStack {
              for (path, name) in googleApps.sorted(by: { $0.key < $1.key }) {
                AppView(path: path, name: name)
              }
            }
            .justifyContent(.center)
            .modifier(ClassModifier(add: "flex-wrap"))
          }
        }
        .padding(.vertical, 32)
      }
    }
  }
}
