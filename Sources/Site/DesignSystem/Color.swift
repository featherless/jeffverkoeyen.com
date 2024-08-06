import Slipstream

extension ColorPalette {
  static var text: Self { .zinc }
  static var link: Self { .blue }
  static var border: Self { .zinc }
}

struct SubtitleStyle<Content: View>: ViewModifier {
  func body(content: Content) -> some View {
    content
      .textColor(.text, darkness: 500)
      .textColor(.text, darkness: 400, condition: .dark)
  }
}

extension View {
  func subtitleStyle() -> some View {
    modifier(SubtitleStyle())
  }
}
