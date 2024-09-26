# SubscriptionStoreView crasher on watchOS 11.1

[Sidecar](http://sidecar.clutch.engineering) supports watchOS as a first-class application, which
sometimes means I get to run into some bleeding edge cases. I lost a couple hours to this one last
night.

When creating a subscription store using [SubscriptionStoreView](https://developer.apple.com/documentation/storekit/subscriptionstoreview)
on watchOS 11.1 (22R5554e) with more than one product ID and the default styling, like so:

```swift
SubscriptionStoreView(productIDs: [
  "core_monthly",
  "core_threemonth",
  "core_annual"
])
```

You might get the following crasher:

```
UnsafeRawBufferPointer.swift:1157: Fatal error: UnsafeRawBufferPointer with negative count
```

I've been able to reproduce this with a standalone project including only the SubscriptionStoreView
and no other logic. Notably this crash does not occur in 10 11.1 (22R5545f) so this appears to have
been a recently introduced regression.

The workaround I've found is to use the `.subscriptionStoreControlStyle(.buttons)` style, like so:
 
```swift
var subscriptionStoreControlStye: some SubscriptionStoreControlStyle {
  if #available(watchOS 11.1, *) {
    // Addresses a crash on watchOS 11.1 (FBFB15279100)
    // UnsafeRawBufferPointer.swift:1157: Fatal error: UnsafeRawBufferPointer with negative count
    return .buttons
  } else {
    return .automatic
  }
}

var body: some View {
  SubscriptionStoreView(productIDs: [
    "core_monthly",
    "core_threemonth",
    "core_annual"
  ])
  .subscriptionStoreControlStyle(subscriptionStoreControlStye)
}
```

I've filed FB15279100 with this crasher.
