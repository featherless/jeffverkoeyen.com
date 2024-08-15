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

```
Thread 9 Queue : com.apple.root.user-initiated-qos.cooperative (concurrent)
#0	0x00000001058a83f8 in _dispatch_assert_queue_fail ()
#1	0x00000001058a8384 in dispatch_assert_queue ()
#2	0x00000002439fd3e0 in swift_task_isCurrentExecutorImpl ()
#3	0x00000001044f02fc in closure #1 in ContentView.body.getter ()
#4	0x00000001d17b0a30 in (3) suspend resume partial function for closure #1 () async -> () in closure #1 () -> () in closure #1 (Swift.Array<__C.NSItemProvider>) -> Swift.Optional<() -> ()> in SwiftUI.PasteHelper.init<τ_0_0 where τ_0_0: CoreTransferable.Transferable>(onPaste: (Swift.Array<τ_0_0>) -> ()) -> SwiftUI.PasteHelper ()
#5	0x00000001d15e4488 in (1) await resume partial function for dispatch thunk of static SwiftUI.PreviewModifier.makeSharedContext() async throws -> τ_0_0.Context ()
#6	0x00000001d17ee5b4 in (1) await resume partial function for generic specialization <()> of reabstraction thunk helper <τ_0_0 where τ_0_0: Swift.Sendable> from @escaping @isolated(any) @callee_guaranteed @async () -> (@out τ_0_0) to @escaping @callee_guaranteed @async () -> (@out τ_0_0, @error @owned Swift.Error) ()
#7	0x00000001d16498cc in (1) await resume partial function for partial apply forwarder for closure #1 () async -> () in closure #1 (inout Swift.TaskGroup<()>) async -> () in closure #1 () async -> () in SwiftUI.AppDelegate.application(_: __C.UIApplication, handleEventsForBackgroundURLSession: Swift.String, completionHandler: () -> ()) -> () ()
```

I've filed FB14804445 to track a resolution for this. 
