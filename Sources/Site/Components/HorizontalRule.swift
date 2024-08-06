import Slipstream

struct HorizontalRule: View {
  var body: some View {
    Divider()
      .margin(.bottom, sectionMargin)
      .border(.init(.gray, darkness: 200), width: 1, edges: .top)
      .border(.white, width: 1, edges: .bottom)
  }
}
