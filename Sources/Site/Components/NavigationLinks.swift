import Foundation

import Slipstream

struct NavigationLinks: View {
  var body: some View {
    NavigationLink("portfolio", destination: URL(string: "/portfolio"))
    NavigationLink("blog", destination: URL(string: "http://blog.jeffverkoeyen.com/"))
    NavigationLink("contact", destination: URL(string: "/contact"))
    NavigationLink("about", destination: URL(string: "/about"))
  }
}
