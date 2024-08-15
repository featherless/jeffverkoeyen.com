# Get current Xcode playground page name

You can get the name of the current Playground page using the following snippet:

```swift
NSProcessInfo.processInfo().environment["PLAYGROUND_NAME"]
```
