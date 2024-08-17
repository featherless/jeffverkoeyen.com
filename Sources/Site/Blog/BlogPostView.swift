import Foundation

import Markdown
import Slipstream

struct TOCHyperlink: View {
  let url: URL?
  let text: String
  var body: some View {
    Slipstream.Link(url) {
      Slipstream.DOMString(text)
    }
    .textColor(.link, darkness: 700)
    .textColor(.link, darkness: 400, condition: .dark)
    .fontWeight(600)
    .fontSize(.small)
    .underline(condition: .hover)
  }
}

struct TOCListItem<Content: View>: View {
  let content: () -> Content

  var body: some View {
    Slipstream.ListItem {
      content()
    }
    .listStyle(.decimal)
  }
}

struct BlogPostView: View {
  let post: BlogPost

  let next: BlogPost?
  let previous: BlogPost?

  var body: some View {
    Page(
      path: post.url.path(),
      title: post.title?.filter({ $0 != "`" }) // Backticks appear to break social sharing title extractors
    ) {
      Div {
        let headings = post.tableOfContents.filter({ $0.level == 2 })
        if !headings.isEmpty {
          Div {
            Slipstream.Paragraph("Content")
            Slipstream.List {
              for heading in headings {
                TOCListItem {
                  TOCHyperlink(url: URL(string: "#\(heading.headerID)"), text: heading.plainText)
                }
              }
            }
          }
          .className("toc-hide")
          .position(.absolute)
          .float(.right)
          .hidden()
          .display(.block, condition: .desktop)
          .padding(.horizontal, 16)
          .className("w-[calc((100vw-796px)/2)]")
          .position(.sticky)
          .placement(top: 16)
        }

        MediumContainer {
          navigation
          Div {
            let postDate = post.date.formatted(date: .abbreviated, time: .omitted)
            if post.draft {
              Slipstream.Text("Draft: " + postDate)
                .bold()
                .textColor(.white)
                .padding(16)
                .background(.red, darkness: 500)
            } else {
              Slipstream.Text("Published: " + postDate)
            }
          }
          .subtitleStyle()
          .margin(.bottom, 8)
          Article(post.content)
          HorizontalRule()
          navigation
        }
        .textColor(.text, darkness: 950)
        .textColor(.text, darkness: 200, condition: .dark)
        .padding(.horizontal, 4)
        .padding(.bottom, 32)
      }
      .position(.relative)
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
