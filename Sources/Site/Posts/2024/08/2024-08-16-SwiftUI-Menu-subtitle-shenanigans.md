# Subtitle Shenanigans in SwiftUI's `Menu`

SwiftUI's `Menu` component is a delightfully powerful API in terms of the complexity of the
interactions it supports compared to the API footprint, but if you need to use subtitles then things
can go a bit off the rails.

Let's dive in to `Menu` use cases to get a better understanding of its sometimes odd behavior.

## Buttons

In most cases you're going to add one or more `Buttons` to a `Menu`. The result is predictable.

```swift
Menu {
  Button("Button") {}
} label: {
  Text("Filters")
}
```

![A menu with a button](/gfx/SwiftUI/Menu/button.png)

---

## Just Text

What happens if you just add a `Text` view?

```swift
Menu {
  Text("Label")
} label: {
  Text("Filters")
}
```

![A menu with a disabled button](/gfx/SwiftUI/Menu/text.png)

You get a disabled button. Also decently predictable.

---

## Text with icons

You can use `Label` to add icons to your text.

```swift
Menu {
  Label("Label", systemImage: "carrot")
} label: {
  Text("Filters")
}
```

![A menu with a disabled button that has an icon of a carrot](/gfx/SwiftUI/Menu/label-with-icon.png)

When used as a top-level instance, you get a disabled button.

---

## Buttons with icons

Let's add an icon to a button using a `Label`.

```swift
Menu {
  Button {
    // Action.
  } label: {
    Label("Button", systemImage: "carrot")
  }
} label: {
  Text("Filters")
}
```

![A menu with a button that has an icon of a carrot](/gfx/SwiftUI/Menu/button-with-icon.png)

---

## First signs of magic

But what happens if we don't use a `Label`?

```swift
Menu {
  Button {
    // Action
  } label: {
    Text("Button")
    Image(systemName: "carrot")
  }
} label: {
  Text("Filters")
}
```

![A menu with a button that has an icon of a carrot](/gfx/SwiftUI/Menu/button-with-icon.png)

This also works. Interesting. Remember this behavior because it will be important in a minute.

---

## Images

What happens if we use an `Image` as a top-level `Menu` view?

```swift
Menu {
  Text("Button")
  Image(systemName: "carrot")
} label: {
  Text("Filters")
}
```

![A menu with two disabled buttons, a text button and a button with an icon of a carrot](/gfx/SwiftUI/Menu/text-and-icon.png)

This makes sense: the `Text` and `Image` are both treated as separate elements.

---

## A quick detour into stacks

SwiftUI has trained us that using VStacks is a common way to make subtitle views, so we might think
this is a way to add subtitles to our `Menu` items, too.

What happens if we put a `VStack` in a `Menu` then? 

```swift
Menu {
  VStack {
    Text("Text")
    Image(systemName: "carrot")
  }
} label: {
  Text("Filters")
}
```

![A menu with two disabled buttons, a text button and a button with an icon of a carrot](/gfx/SwiftUI/Menu/text-and-icon.png)

Huh. Looks like the VStack is completely ignored. The sub-items are being treated as individual menu
items.

Ok but maybe it's because it's a `Text` with an `Image`. What happens if we do this with a `VStack`
of `Text` items?

```swift
Menu {
  VStack {
    Text("Text")
    Text("Subtitle")
  }
} label: {
  Text("Filters")
}
```

![A menu with two disabled text buttons](/gfx/SwiftUI/Menu/text-and-subtitle.png)

Still treated as separate elements. Maybe we can conclude that stacks are treated like some kind
of a pass-through entity in `Menu` then. 

What about `HStack`? We might expect this to make a single row  with the image on the trailing edge,
right?

```swift
Menu {
  HStack {
    Text("Text")
    Image(systemName: "carrot")
  }
} label: {
  Text("Filters")
}
```

![A menu with two disabled buttons, a text button and a button with an icon of a carrot](/gfx/SwiftUI/Menu/text-and-icon.png)

Nope, still separate items.

Just for the heck of it, what happens if we use a `ZStack`?

```swift
Menu {
  ZStack {
    Text("Text")
    Text("Subtitle")
  }
} label: {
  Text("Filters")
}
```

![A menu with two disabled text buttons](/gfx/SwiftUI/Menu/text-and-subtitle.png)

Same thing.

So let's conclude that stacks are essentially ignored in a `Menu` context.

## Subtitles (aka: shenanigans)

We just learned that VStacks don't stack information together in `Menu`; they're essentially treated
as pass-through entities.

Let's say we didn't know that though and tried to use a `VStack` to make a subtitle `Menu` item
anyway, like we typically would to make a subtitled `Button`.

```swift
Menu {
  Button {
    // Action
  } label: {
    VStack {
      Text("Projects")
      Text("Hog Mobile")
    }
  }
} label: {
  Text("Filters")
}
```

![A menu with a button labeled "Projects" that is notably missing a subtitle](/gfx/SwiftUI/Menu/no-subtitle.png)

Oh no. 🙊

Ok before we panic, there must be a way to make a subtitle though right?

Somewhat unintuitively, the solution is to make both `Text` views be top-level views in the button
label.

```swift
Menu {
  Button {
    // This action is ignored!
  } label: {
    Text("Projects")
    Text("Hog Mobile")
  }
} label: {
  Text("Filters")
}
```

![A menu with a button labeled "Projects" and a subtitle labeled "Hog Mobile"](/gfx/SwiftUI/Menu/subtitle.png)

What happens if we add a third `Text` view?

```swift
Menu {
  Button {
    // This action is ignored!
  } label: {
    Text("Projects")
    Text("Hog Mobile")
    Text("Third line")
  }
} label: {
  Text("Filters")
}
```

![A menu with a button labeled "Projects" and a subtitle labeled "Hog Mobile"](/gfx/SwiftUI/Menu/subtitle.png)

It just gets ignored. Fine.

Clearly some magic going on here. Let's see what happens if we try to add an icon. We'll pull our
trusty `Label` out of the bag and wrap our text with it and...

```swift
Menu {
  Button {
    // This action is ignored!
  } label: {
    Label {
      Text("Projects")
      Text("Hog Mobile")
    } icon: {
      Image(systemName: "carrot")
    }
  }
} label: {
  Text("Filters")
}
```

![A menu with a button labeled "Projects" and an icon of a carrot. The menu item is notably missing a subtitle.](/gfx/SwiftUI/Menu/button-with-icon-2.png)

Well gosh darnit. Where did our subtitle go?

Turns out we need to add the subtitle as a **sibling** to the `Label`:

```swift
Menu {
  Button {
    // This action is ignored!
  } label: {
    Label {
      Text("Projects")
    } icon: {
      Image(systemName: "carrot")
    }
    Text("Hog Mobile")
  }
} label: {
  Text("Filters")
}
```

![A menu with a button labeled "Projects", a subtitle labeled "Hog Mobile", and an icon of a carrot](/gfx/SwiftUI/Menu/button-with-subtitle-and-icon.png)

## Concluding thoughts

Based on these shenanigans, we can see that SwiftUI is using some kind of heuristic to pull what it
thinks are the appropriate sub-`View`s from the `Menu`'s `@ViewBuilder`. Unfortunately for us, these
heuristics are a bit unpredictable.

In fairness, this behavior *is* documented in [Apple's documentation](https://developer.apple.com/documentation/swiftui/menu/#overview):

> To support subtitles on menu items, initialize your Button with a view builder that creates multiple Text views where the first text represents the title and the second text represents the subtitle. The same approach applies to other controls such as Toggle:
>
> ```swift
> Menu {
>     Button(action: openInPreview) {
>         Text("Open in Preview")
>         Text("View the document in Preview")
>     }
>     Button(action: saveAsPDF) {
>         Text("Save as PDF")
>         Text("Export the document as a PDF file")
>     }
> } label: {
>     Label("PDF", systemImage: "doc.fill")
> }
> ```

It goes on to say:

> **Note**
> This behavior does not apply to buttons outside of a menu’s content.

Unfortunately it's very likely that you won't be reading this particular part of the documentation
if you're just happily hacking away. This might be improveable, so I've filed feedback (FB14828811)
to Apple with the following asks:

- Support `VStack` in `Menu` items for building subtitle items.
- Support sibling `Text` elements in `Label`s with images.

In the meantime, just remember that if you want subtitles in your menus that you need to place the
subtitle `Text` as a **sibling** to your primary label content, whether that content is a `Text` or
a `Label`.
