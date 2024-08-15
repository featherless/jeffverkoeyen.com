# FB14804445: Swift 6 and SwiftUI's `PasteButton`

As of Xcode Version 16.0 beta 5 (16A5221g), 18.0 beta 5 (22A5326g), enabling Swift 6 compilation
mode will cause use of PasteButton to crash when tapped at runtime with the exception
"EXC_BREAKPOINT (code=1, subcode=0x1058a83f8)".

The repro case is unfortunately quite simple:

```swift
import SwiftUI

struct ContentView: View {
  @State private var text: String = "Paste to replace me"

  var body: some View {
    Text(text)
    
    PasteButton(payloadType: String.self) { strings in
      guard let string = strings.first else {
        return
      }
      self.text = String(string)
    }
  }
}
```

The app crashes before the PasteButton's block is called.

I've filed FB14804445 to track a resolution for this. 
