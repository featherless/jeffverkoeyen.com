import Foundation

import Slipstream

struct ImagePuck: View {
  let url: URL?
  let accessibilityLabel: String
  let caption: String

  var body: some View {
    VStack {
      Div {
        Image(url)
          .accessibilityLabel(accessibilityLabel)
          .border(.white, width: 4)
          .cornerRadius(.extraExtraLarge)
          .modifier(ClassModifier(add: "shadow-puck"))
          .frame(width: 198, height: 198, condition: .desktop)
      }
      .margin(.bottom, 4)
      Paragraph(caption)
        .fontSize(.extraSmall)
        .fontSize(.small, condition: .desktop)
        .textColor(.zinc, darkness: 500)
        .textAlignment(.right)
    }
    .alignItems(.end)
    .float(.right)
    .margin(.left, 12)
    .margin(.bottom, 4)
  }
}
