import Foundation

import Markdown
import Slipstream

struct BlogPost {
  let fileURL: URL
  let slug: String
  let outputURL: URL
  let url: URL
  let date: Date
  let title: String?
  let content: String
  let document: Document
}

struct BlogPostView: View {
  let post: BlogPost

  let next: BlogPost?
  let previous: BlogPost?

  var body: some View {
    Page(
      path: post.url.path(),
      title: post.title
    ) {
      MediumContainer {
        navigation
        Text(post.date.formatted(date: .abbreviated, time: .omitted))
          .subtitleStyle()
        Article(post.content)
        HorizontalRule()
        navigation
      }
      .textColor(.text, darkness: 950)
      .textColor(.text, darkness: 200, condition: .dark)
      .padding(.horizontal, 8)
      .padding(.bottom, 32)
    }
  }

  private var navigation: some View {
    HStack(spacing: 48) {
      if let previous {
        Link(previous.url) {
          HStack(alignment: .center, spacing: 8) {
            Span("←")
              .textDecoration(.none, condition: .hover)
            Span(previous.title ?? previous.slug)
              .fontLeading(.tight)
          }
        }
        .textColor(.link, darkness: 700)
        .textColor(.link, darkness: 400, condition: .dark)
        .fontWeight(600)
        .underline(condition: .hover)
      } else {
        Text("No older posts")
          .subtitleStyle()
      }
      Div {
        if let next {
          Link(next.url) {
            HStack(alignment: .center, spacing: 8) {
              Span((next.title ?? next.slug))
                .fontLeading(.tight)
              Span("→")
                .textDecoration(.none, condition: .hover)
            }
          }
          .textColor(.link, darkness: 700)
          .textColor(.link, darkness: 400, condition: .dark)
          .fontWeight(600)
          .underline(condition: .hover)
        } else {
          Text("No newer posts")
            .subtitleStyle()
        }
      }
      .textAlignment(.right)
    }
    .justifyContent(.between)
    .margin(.bottom, 16)
  }
}
