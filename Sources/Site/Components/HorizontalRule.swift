import Slipstream

struct HorizontalRule: View {
  var body: some View {
    Divider()
      .margin(.bottom, Double.sectionMargin)
      .border(.init(.gray, darkness: 200), width: 1, edges: .top)
      .border(.white, width: 1, edges: .bottom)
      .border(.init(.gray, darkness: 500), width: 1, edges: .top, condition: .dark)
      .border(.black, width: 1, edges: .bottom, condition: .dark)
  }
}
