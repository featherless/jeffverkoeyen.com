# Enumerate XCUIElementQuery in Swift

Let's learn how to make XCUIElementQuery enumerable in a Swift `for-in` loop so that we can do the following:

```
for cell in XCUIApplication().cells {
  // cell is an XCUIElement
}
```

We'll take the template from [Minimal Swift protocol conformance](/blog/2015/10/28/minimal-swift-protocol-conformance/)'s section on "SequenceType" to make XCUIElementQuery conform to SequenceType:

```
extension XCUIElementQuery : SequenceType {
  public func generate() -> AnyGenerator<XCUIElement> {
    var index = UInt(0)
    return anyGenerator {
      if index >= self.count {
        return nil
      }

      let element = self.elementBoundByIndex(index)
      index++
      return element
    }
  }
}
```

Now we can enumerate XCUI queries in `for-in` loops.
