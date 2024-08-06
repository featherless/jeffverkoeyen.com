import Foundation

import Slipstream

struct NavigationLink: View {
  @Environment(\.path) private var path

  private let text: String
  private let destination: URL?

  init(_ text: String, destination: URL?) {
    self.text = text
    self.destination = destination
  }

  var body: some View {
    let link = Link(text, destination: destination)
      .padding(isHomePage ? 4 : 0)
      .padding(.horizontal, isHomePage ? 16 : 8)
      .padding(.vertical, isHomePage ? 8 : 4, condition: .desktop)
      .margin(.top, 8, condition: .desktop)
      .border(
        .init(.zinc, darkness: isCurrent ? 400 : 300),
        edges: isHomePage ? .right : .left,
        condition: .mobileOnly + .hover
      )
      .border(
        .init(.zinc, darkness: isCurrent ? 400 : 300),
        edges: .bottom,
        condition: .desktop + .hover
      )
    if !isHomePage, isCurrent {
      link
        .border(
          .init(.zinc, darkness: 400),
          edges: .left,
          condition: .mobileOnly
        )
        .border(
          .init(.zinc, darkness: 400),
          edges: .bottom,
          condition: .desktop
        )
    } else {
      link
    }
  }

  private var isHomePage: Bool {
    path == "/"
  }

  private var isCurrent: Bool {
    path == destination?.path() && destination?.host(percentEncoded: false) == nil
  }
}
