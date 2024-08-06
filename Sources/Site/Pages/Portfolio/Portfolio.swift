import Foundation

import Slipstream

struct Portfolio: View {
  var body: some View {
    Page(
      path: "/portfolio",
      title: "portfolio",
      description: "Jeff Verkoeyen's catalog of open source efforts, company initiatives, teams, and launches."
    ) {
      Maps()
    }
  }
}
