import Foundation

import Slipstream

struct PortfolioSectionHeader<Content: View>: ViewModifier {
  func body(content: Content) -> some View {
    content
      .fontSize(.extraExtraLarge)
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
      Google()
      Maps()
      Nimbus()
      Facebook()

      Script(URL(string: "/js/portfolio.js"), executionMode: .async)
    }
  }
}
