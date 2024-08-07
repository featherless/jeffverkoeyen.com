import Foundation

import Slipstream

struct PortfolioSectionHeader<Content: View>: ViewModifier {
  func body(content: Content) -> some View {
    content
      .fontSize(.extraLarge)
      .fontSize(.fourXLarge, condition: .desktop)
      .fontDesign("rounded")
  }
}

extension View {
  func portfolioSectionHeader() -> some View {
    modifier(PortfolioSectionHeader())
  }
}

struct Portfolio: View {
  var body: some View {
    Page(
      path: "/portfolio",
      title: "portfolio",
      description: "Jeff Verkoeyen's catalog of open source efforts, company initiatives, teams, and launches."
    ) {
      Div {
        Google()
        Maps()
        Nimbus()
        Facebook()
      }
      .textColor(.text, darkness: 950)
      .textColor(.text, darkness: 200, condition: .dark)

      Script(URL(string: "/js/portfolio.js"), executionMode: .async)
    }
  }
}
