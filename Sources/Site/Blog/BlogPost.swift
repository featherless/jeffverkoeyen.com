import Foundation

import Slipstream

struct BlogPost: View {
  let path: String
  let markdown: String
  let date: Date

  let next: BlogPostMetadata?
  let previous: BlogPostMetadata?

  var body: some View {
    Page(
      path: path,
      title: "TODO",
      description: "TODO"
    ) {
      MediumContainer {
        HStack(spacing: 16) {
          if let previous {
            Link("<" + previous.slug, destination: previous.url)
              .textColor(.link, darkness: 700)
              .textColor(.link, darkness: 400, condition: .dark)
              .fontWeight(600)
              .underline(condition: .hover)
          } else {
            Paragraph("No older posts")
          }
          if let next {
            Link(next.slug + " >", destination: next.url)
              .textColor(.link, darkness: 700)
              .textColor(.link, darkness: 400, condition: .dark)
              .fontWeight(600)
              .underline(condition: .hover)
          } else {
            Paragraph("No newer posts")
          }
        }
        .justifyContent(.between)
        .margin(.bottom, 16)

        Paragraph(date.formatted(date: .abbreviated, time: .omitted))
          .subtitleStyle()
        Article(markdown)
      }
      .textColor(.text, darkness: 950)
      .textColor(.text, darkness: 200, condition: .dark)
      .padding(.bottom, 32)
    }
  }
}
