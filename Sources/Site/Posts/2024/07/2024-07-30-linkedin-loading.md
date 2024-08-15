# LinkedIn's loading animation

Let's build LinkedIn's loading animation in <50 lines of SwiftUI.

![Animation of the LinkedIn loading screen's progress bar](/gfx/linkedin.mp4)

Activity indicators are typically broken down into two main categories: determinate (for known progress) vs indeterminate (for unknown progress). For various psychological reasons, it's often better to use a determinate indicator (even if it's lying about its progress).

LinkedIn is using an indeterminate indicator though, so our code reflects the looping nature of this animation.

```swift
import SwiftUI

struct LinkedInActivityIndicator: View {
  @State private var animating = false

  let cornerRadius: CGFloat

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Rectangle()
          .fill(.gray.secondary)
        Rectangle()
          .fill(.blue)
          .frame(width: proxy.size.width / 2)
          .clipShape(.rect(cornerRadius: cornerRadius))
          .offset(x: animating ? proxy.size.width / 2 : -proxy.size.width / 2)
          .animation(
            .timingCurve(0.6, 0.0, 0.4, 1.0, duration: 0.85)
            .repeatForever(autoreverses: true),
            value: animating
          )
      }
      .clipShape(.rect(cornerRadius: cornerRadius))
    }
    .onAppear {
      animating = true
    }
  }
}

#Preview {
  VStack {
    LinkedInActivityIndicator(cornerRadius: 5)
      .frame(width: 100, height: 10)
      .padding(100)
  }
}
```

## Building the animation

Looking at the animation, we can see there's two main components: the gutter (the gray portion) and the fill (the blue portion).

One way to build this animation would be to draw the fill using a line, and then control the start/end positions of that line as two separate animations. This would get pretty gnarly pretty quick though, and there's a much simpler way.

We'll use a similar trick from the Threads seamless carousel effect to simplify our code: container clipping.

## A simple approach

To understand this simpler approach, I've turned off container clipping in the solution. In this animation, you can see that the fill shape is actually a fixed width, and we're simply moving it along the x axis using a repeating animation.

When we pair this with a container clip, the result looks like a fill that is expanding and squishing as it moves between the two edges. Magic!

### Without clipping

![The LinkedIn animation without clipping](/gfx/linkedin-animation-noclip.mp4)

### With clipping

![The LinkedIn animation with clipping](/gfx/linkedin-animation.mp4)

## Building the layers

We start with a ZStack to overlay the fill on top of the gutter:

```swift
ZStack {
  Rectangle()
    .fill(.gray.secondary)
  Rectangle()
    .fill(.blue)
    .frame(width: proxy.size.width / 2)
    .clipShape(.rect(cornerRadius: cornerRadius))
```

Note that we avoid specifying any dimensions in the view implementation because we want to allow the view's width/height to be set to arbitrary dimensions.

The ZStack is also where we apply our container clip.

## Sizing the progress indicator

We want our fill to be exactly one half the length of the gutter, so we use a GeometryReader to get the dimensions of the view:

```swift
GeometryReader { proxy in
  ...
  .frame(width: proxy.size.width / 2)
}
```

We also use the GeometryReader to define the keyframes of our animation:

```swift
.offset(x: animating ? proxy.size.width / 2 : -proxy.size.width / 2)
```

For a simple two-frame animation like this we can make use of a single Boolean state value to define the keyframes. We alternate the pill's x position between centering on the leading and trailing edges using .offset.

## Tuning animation timing

The animation timing is important to tune.

We're building a looping animation, so we want to ensure continuity in our timing function at the start and end so that the animation feels continuous.

To achieve this, we can use a custom timing curve where the curve approaches a velocity of 0 at the start and end of the curve: https://cubic-bezier.com/#.6,0,.4,1

```swift
.animation(
  .timingCurve(0.6, 0.0, 0.4, 1.0, duration: 0.85)
    .repeatForever(autoreverses: true),
  value: animating
)
```

## Kick-starting the animation

And last, to start our animation we just toggle our animating state in an onAppear block:

```swift
.onAppear { animating = true }
```

This flips the state value, causing our view to change the offset to the leading edge and emit our looping, autoreversing animation as a result.

And that's it!
