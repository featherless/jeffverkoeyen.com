# textSelection broken in List on iOS 18

Happy iOS 18 release week! Exciting to see all of the new dark mode app icons going live; congrats
to all of the indie devs out there who've gotten their apps approved in time for launch!

In testing iOS 18 on my own apps, I noticed that text selection no longer works in SwiftUI. This
behavior is unfortunately reproducible on both the iOS 18 and iOS 18.1 tracks. Here's the repro
case:

```swift
import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      Text("Hello, world!")
        .textSelection(.enabled)
    }
  }
}
```

What this is supposed to look like when you tap and hold:

![The copy menu that appears when tap-and-holding on text in iOS](/gfx/SwiftUI/TextSelection/textSelection.png)

Unfortunately the tap and hold gesture appears to have broken in iOS 18. I filed FB15178192 to
track this and will update this thread if/when the issue is resolved.

## Workaround

In the meantime, I needed a workaround for this because the text selection behavior is an important
use case in [Sidecar](http://sidecar.clutch.engineering) to copy vehicle identification numbers
(VINs).

Building a generic solution that works as a drop-in replacement for `.textSelection(.enabled)` is a
bit tough, because we can't easily get access to the modified view's text contents. An alternative
workaround is to provide a `SelectableText` view that allows us to pass the text string to the
clipboard when needed.

```swift
import SwiftUI

struct SelectableText: View {
  private let string: String
  init(_ string: String) {
    self.string = string
  }

  init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
    self.string = format.format(input)
  }

  var body: some View {
#if !os(watchOS)
    if #available(iOS 18, *) {
      Text(string)
        .contextMenu {
          Button(action: {
            UIPasteboard.general.string = string
          }) {
            Label("Copy", systemImage: "doc.on.doc")
          }
        }
    } else {
      Text(string)
        .textSelection(.enabled)
    }
#else
    Text(string)
#endif
  }
}
```

![A workaround copy menu that appears when tap-and-holding on text in iOS](/gfx/SwiftUI/TextSelection/textSelection-fixed.png)

Our code can now go from this:

```swift
import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      Text("Hello, world!")
        .textSelection(.enabled)
    }
  }
}
```

to this:

```swift
import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      SelectableText("Hello, world!")
    }
  }
}
```

If/when iOS 18 fixes this behavior we can add additional checks to fall back to the system copy
menu again.
