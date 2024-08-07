import Foundation

import Slipstream

struct NavigationLinks: View {
  var body: some View {
    NavigationLink("portfolio", destination: URL(string: "/portfolio"))
    NavigationLink("blog", destination: URL(string: "/blog"))
    NavigationLink("contact", destination: URL(string: "/contact"))
    NavigationLink("about", destination: URL(string: "/about"))
  }
}
