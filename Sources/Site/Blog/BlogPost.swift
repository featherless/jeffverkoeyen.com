import Foundation

import Slipstream

struct BlogPost: View {
  let path: String
  let markdown: String
  let date: Date

  var body: some View {
    Page(
      path: path,
      title: "TODO",
      description: "TODO"
    ) {
      MediumContainer {
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
