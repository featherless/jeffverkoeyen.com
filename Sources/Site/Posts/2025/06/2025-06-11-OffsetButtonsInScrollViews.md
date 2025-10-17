# iOS 26: Offset buttons in ScrollView aren't tappable

iOS 26 introduced a subtle regression in SwiftUI's `Button` component when used inside a `ScrollView` with an `.offset()` modifier. The button's hit area no longer tracks the button's visible frame, making the offset portions of the button untappable.

**Important: this bug affects production apps running on iOS 26, even if the app hasn't been built for iOS 26 yet.** Many thanks to the [Sidecar](https://sidecar.clutch.engineering) beta testers who caught and reported this.

I've filed `FB17939266: Adding an offset to a Button in a ScrollView causes the button to no longer receive tap events` to track this.

## Reproduction case

```swift
import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      Button {
        print("Did tap")
      } label: {
        Text("(try to) tap me")
      }
      .buttonStyle(.borderedProminent)
      .offset(y: 100)
    }
  }
}
```

## Understanding the hit area issue

The core issue appears to be that SwiftUI's hit testing for buttons inside scroll views doesn't account for offset transformations. The button's interactive area remains anchored to its pre-offset frame, while only the visual representation moves.

This creates a mismatch where:
- The visual button appears at position Y + offset
- The interactive area remains at position Y

The result is that tapping the visually offset button does nothing if the offset is larger than the height of the button.

## Workaround

The most natural workaround is to use `.padding()` instead:

```swift
struct ContentView: View {
  var body: some View {
    ScrollView {
      Button {
        print("Did tap")
      } label: {
        Text("(try to) tap me")
      }
      .buttonStyle(.borderedProminent)
      .padding(.top, 100)
    }
  }
}
```

This ensures that both the visual representation and the hit area are positioned correctly, since we're using layout spacing rather than a transform (which I suspect is the cause of the bug here).
