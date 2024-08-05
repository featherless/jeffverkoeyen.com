import Foundation

import Slipstream

struct HomeLink: View {
  private let text: String
  private let destination: URL?

  init(_ text: String, destination: URL?) {
    self.text = text
    self.destination = destination
  }

  var body: some View {
    Link(text, destination: destination)
      .padding(4)
      .padding(.horizontal, 16, condition: .desktop)
      .padding(.vertical, 8, condition: .desktop)
      .margin(.top, 8, condition: .desktop)
      .border(
        .init(.zinc, darkness: 300),
        edges: .right,
        condition: .mobileOnly + .hover
      )
      .border(
        .init(.zinc, darkness: 300),
        edges: .bottom,
        condition: .desktop + .hover
      )
  }
}
