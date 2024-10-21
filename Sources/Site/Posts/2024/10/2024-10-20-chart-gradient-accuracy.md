# Buggy linear gradients in SwiftUI Charts

If you're using linear gradients in SwiftUI's Charts framework, make sure that the delta between
every color stop is at least `0.0001`.

Let's say you want to draw a linear gradient with hard stops, like the one used in
[Sidecar's](http://sidecar.clutch.engineering/) trip logger:

![](/gfx/chartsaccuracy/triplogger.png)

You might start with something like this:

```swift
import Charts
import SwiftUI

Rectangle()
  .foregroundStyle(.linearGradient(
    Gradient(stops: [
      .init(color: .blue, location: 0),
      .init(color: .blue, location: 0.5),
      .init(color: .red, location: 0.500001),
      .init(color: .red, location: 1),
    ]),
    startPoint: .bottom,
    endPoint: .top
  ))
  .frame(width: 100, height: 100) 
```

Linear gradients really want to draw smooth color gradients, so to achieve a hard stop we use two
pairs of color stops separated by a teensy tiny gap where the "gradient" part actually occurs. The
size of this gap seems pretty arbitrary, so you might pick a correspondingly arbitrarily small
value.

![A rectangle whose bottom half is blue and top half is red](/gfx/chartsaccuracy/rectangle.png)

Looks good! Let's port this over to a SwiftUI Chart now.

```swift
import Charts
import SwiftUI

Chart {
  LineMark(x: .value("x", 0), y: .value("y", 0))
    .lineStyle(StrokeStyle(lineWidth: 10))
    .foregroundStyle(.linearGradient(
      Gradient(stops: [
        .init(color: .blue, location: 0),
        .init(color: .blue, location: 0.5),
        .init(color: .red, location: 0.500001),
        .init(color: .red, location: 1),
      ]),
      startPoint: .bottom,
      endPoint: .top
    ))
  LineMark(x: .value("x", 10), y: .value("y", 10))
}
```

Easy peas....

![A chart with a line going from 0 to 10, where the entire line is blue](/gfx/chartsaccuracy/chart-broken.png)

oh no.

Turns out — casually said, after spending 3 hours trying to figure out what was going on here 😅 —
there appears to be a bug in SwiftUI's Charts framework that causes gradient stops with very small
floating point deltas to result in weird behavior.

## The workaround

The workaround here is to increase the size of the gap between the two stops, specifically a delta
of at least `0.00002`, but I recommend using a minimum of `0.0001` for good measure.

With that adjustment in place, we get our desired effect:

```swift
import Charts
import SwiftUI

Chart {
  LineMark(x: .value("x", 0), y: .value("y", 0))
    .lineStyle(StrokeStyle(lineWidth: 10))
    .foregroundStyle(.linearGradient(
      Gradient(stops: [
        .init(color: .blue, location: 0),
        .init(color: .blue, location: 0.5),
        .init(color: .red, location: 0.5001),
        .init(color: .red, location: 1),
      ]),
      startPoint: .bottom,
      endPoint: .top
    ))
  LineMark(x: .value("x", 10), y: .value("y", 10))
}
```

![A chart with a line going from 0 to 10, with the bottom half being blue and the top half being red](/gfx/chartsaccuracy/chart-working.png)


## Complete playground

You can play with this bug using the following playground, which I've included in FB15549992.

```swift
import Charts
import Foundation
import PlaygroundSupport
import SwiftUI

struct Content: View {
  @State private var amount: Double = 50
  var body: some View {
    Text("Drag me to the right to fix the Chart")
    Slider(value: $amount, in: 1...100) {
      Text("Breakpoint")
    } minimumValueLabel: {
      Text("0.5")
    } maximumValueLabel: {
      Text("0.51")
    }
    .frame(width: 500)

    let breakpoint = 0.5 + amount / 10000000
    Text(breakpoint, format: .number)
    VStack {
      Chart {
        LineMark(x: .value("x", 0), y: .value("y", 0))
          .lineStyle(StrokeStyle(lineWidth: 10))
          .foregroundStyle(.linearGradient(
            Gradient(stops: [
              .init(color: .blue, location: 0),
              .init(color: .blue, location: 0.5),
              .init(color: .red, location: breakpoint),
              .init(color: .red, location: 1),
            ]),
            startPoint: .bottom,
            endPoint: .top
          ))
        LineMark(x: .value("x", 10), y: .value("y", 10))
      }

      Rectangle()
        .foregroundStyle(.linearGradient(
          Gradient(stops: [
            .init(color: .blue, location: 0),
            .init(color: .blue, location: 0.5),
            .init(color: .red, location: breakpoint),
            .init(color: .red, location: 1),
          ]),
          startPoint: .bottom,
          endPoint: .top
        ))
        .frame(width: 100, height: 100)
    }
    .padding()
  }
}

PlaygroundPage.current.liveView = NSHostingController(rootView: Content())

```
