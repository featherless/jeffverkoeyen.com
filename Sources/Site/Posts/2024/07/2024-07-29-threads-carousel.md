# Threads Carousel pinch effect

Let's build Threads' seamless carousel effect in <50 lines of SwiftUI.

![Animation of the Threads Carousel pinch effect](/gfx/pigs.mp4)

There's plenty of ways to build this effect. Let's break the code down into its concepts.

```swift
import SwiftUI

struct SeamlessCarouselDemo: View {
  @State private var seamless = false

  @ViewBuilder
  func image(_ name: String) -> some View {
    Image(name)
      .resizable(resizingMode: .stretch)
      .aspectRatio(contentMode: .fit)
      .clipShape(.rect(cornerRadius: seamless ? 0 : 8))
  }

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: seamless ? 0 : 8) {
        image("image1x1")
        image("image2x1")
      }
      .gesture(
        MagnifyGesture()
          .onChanged { value in
            if !seamless, value.magnification < 0.95 {
              withAnimation(.easeIn(duration: 0.2)) {
                seamless = true
              }
            } else if seamless, value.magnification > 1.05 {
              withAnimation(.easeOut(duration: 0.2)) {
                seamless = false
              }
            }
          }
      )
      .clipShape(.rect(cornerRadius: 8))
      .padding()
      .frame(maxHeight: 300)
    }
    .sensoryFeedback(.impact(weight: .heavy), trigger: seamless)
  }
}

#Preview {
  SeamlessCarouselDemo()
}
```

## HStack of images

```swift
Image(name)
  .resizable(resizingMode: .stretch)
  .aspectRatio(contentMode: .fit)
```

At it's core, we're rendering a scrollable HStack of images.

In production, Image would likely be replaced with an async image loading solution.

There's some nuance around handling images with different aspect ratios, but for this first pass I just focused on getting the core stitching effect working.

## Creating the rounded corner collapse effect

Looking at the animation, only the "inner" corners of each photo are stitching together. Keeping track of which corners are inner gets complicated fast (rounding individual corners, keeping track of relative placement in the carousel, etc...).

Instead, we'll round every photo *and* the entire carousel. We can toggle the photos' rounded corners and rely on the carousel to keep the outer edges rounded. Trades accuracy for simplicity, so keep an eye out for weird aliasing artifacts + performance.

## Managing state

```swift
@State private var seamless = false

.clipShape(.rect(cornerRadius: seamless ? 0 : 8))

HStack(spacing: seamless ? 0 : 8) {
  ...
}
```

The carousel's seamlessness is managed with a boolean, and based on that boolean we toggle the amount of radius and spacing.

It's important that we use the same clipShape across states here so that our animations have the same number of interpolation points on both sides of the effect.

## Gesture handling

The gesture uses SwiftUI's MagnifyGesture, which converts two-finger pinches into magnification values.

We enter seamless mode if we pinch in (< 1 magnification), and exit seamless mode if we pinch out (> 1 magnification).

To avoid accidental gestures, we also add a bit of slop on either side.

To tighten up the animation timing we can use a pair of easeIn/easeOut timing curves.

```swift
.gesture(
  MagnifyGesture()
    .onChanged { value in
      if !seamless, value.magnification < 0.95 {
        withAnimation(.easeIn(duration: 0.2)) {
          seamless = true
        }
      } else if seamless, value.magnification > 1.05 {
        withAnimation(.easeOut(duration: 0.2)) {
          seamless = false
        }
      }
    }
)
```

## Haptics

And the last touch: haptics! This is trivial in SwiftUI; just wire up the toggle state to a heavy impact sensory feedback effect and SwiftUI will handle the haptics for us.

```swift
.sensoryFeedback(.impact(weight: .heavy), trigger: seamless)
```

And that's it! Also, say hi to "coco" the swimming pig 🐷

![A swimming pig, standing on a beach](/gfx/pig.jpeg)
