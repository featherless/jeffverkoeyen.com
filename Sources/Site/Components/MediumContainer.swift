import Slipstream

struct MediumContainer<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    Container {
      content()
    }
    .padding(.horizontal, 104, condition: .desktop)
  }
}
