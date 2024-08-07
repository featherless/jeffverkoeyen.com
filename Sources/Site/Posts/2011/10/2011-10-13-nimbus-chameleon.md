# Nimbus Chameleon

Stop compiling. Start building.

Chameleon brings real-time CSS styling to your iOS applications. Good bye long compile times. Good bye re-installs and good bye re-navigating to the changed view controller. Say hello to seeing your changes reflected in real time.

I’ll let the demo video do the talking.

<iframe width="560" height="315" src="https://www.youtube.com/embed/i_5LbQ8e9BU?si=vWKR0Lhn6s9a87On" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## The Tech

Chameleon was fun to build. In summary: it works by detecting changes to CSS files in your project, notifying the app of the changes, and then sending the changed CSS files for the app to then re-apply to any related user interface components.

Chameleon itself is a node.js server that runs on your machine. The node.js server watches changes on a folder that you specify when you start up the server. For example:

```bash
> node chameleon.js --watch ../../../examples/css/CSSDemo/resources/css/
```

Once Chameleon starts, you make a request to the server’s /watch endpoint. This request will only complete once Chameleon notices a change on the filesystem. An example result might be something like:

```
root/root.css
```

It is then the request initiator’s responsibility to request the new files from the server via /root/root.css. This will immediately fetch the most recent CSS file from the ../../../examples/css/CSSDemo/resources/css/directory. In this case it would download the contents of ../../../examples/css/CSSDemo/resources/css/root/root.css.

### How Nimbus uses Chameleon

In the demo app from the video, the watch request is initiated by a class called NIChameleonObserver, part of the new Nimbus CSS feature. In the demo we initialize an observer and then tell it to watch skin changes from the Chameleon server.

```objc
_chameleonObserver = [[NIChameleonObserver alloc] initWithRootFolder:@"css"];  [_chameleonObserver watchSkinChanges];
```

The observer will then post global notifications for specific stylesheets when they change. In the case of the sample app discussed in the video we had a root view controller and a corresponding root stylesheet, so the listener looks like this:

```objc
// Fetch the global chameleon observer.
NIChameleonObserver* chameleonObserver =
  [(AppDelegate *)[UIApplication sharedApplication].delegate chameleonObserver];

// Fetch the Nimbus stylesheet object for the given file.
NIStylesheet* stylesheet = [chameleonObserver stylesheetForFilename:@"root/root.css"];

// Start watching changes for the stylesheet.
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(chameleonSkinDidChange)
                                             name:NIChameleonSkinDidChangeNotification
                                           object:stylesheet];
```

We then simply implement the chameleonSkinDidChange method and respond accordingly.

```objc
- (void)chameleonSkinDidChange {
  [_dom refresh];
}
```

\_dom here is also part of the new Nimbus CSS feature. It is the beginning of what will soon be a fully-featured DOM object for applying styles to views and laying out views using the standard box model.

## Rationale behind building this feature

I built this to scratch my own itch. From my work at Facebook and now at Google I’ve been finding that a large amount of my time has been wasted waiting for builds to compile, even when I just need to make a change as simple as “make that text blue rather than black”. This frustration is surely echoed by anyone who has had the unfortunate task of doing a clean build of Three20. Thanks to the way the Nimbus framework is set up, anyone can use Chameleon in their own project simply by adding the Nimbus Core and CSS components _and nothing else!_ It really brings home the mantra of _“stop compiling, start building”_.

The idea was originally tossed out on the [Nimbus CSS task thread](https://web.archive.org/web/20120103215437/https://github.com/jverkoey/nimbus/issues/22#issuecomment-1953987). I’ll have to message Rog about the fact that I’ve just gone ahead and built this! That’s what I get for waking up early on the weekend and working on this before Canadian turkey day when I should have been running errands.

## Supported CSS properties as of Oct 13, 2011

The Nimbus CSS feature only supports a small number of properties so far but this number will only grow with time. For version 1 of the CSS feature (likely going out in Nimbus 0.9) the CSS feature will not support properties such as padding and margins.

```css
UIView {
  border: <dimension> <ignored> <color> {view.layer.borderWidth view.layer.borderColor}
  border-color: <color>       {view.layer.borderColor}
  border-width: <dimension>   {view.layer.borderWidth}
  background-color: <color>   {view.backgroundColor}
  border-radius: <dimension>  {view.layer.cornerRadius}
  opacity: <number>             {view.alpha}
}

UINavigationBar {
  -ios-tint-color: <color>     {navBar.tintColor}
}

UILabel {
  color: <color>                  {label.textColor}

  font: <font-size> <font-name>   {label.font}
  font-size: <font-size>          {label.font}
  font-name: <font-name>          {label.font}

  /**
   * Can't be used in conjunction with font/font-name properties. Use the italic/bold font name
   * instead.
   */
  font-style: [italic|normal]     {label.font}
  font-weight: [bold|normal]      {label.font}

  text-align: [left|right|center] {label.textAlignment}

  text-shadow: <color> <x-offset> <y-offset> {label.shadowColor label.shadowOffset}

  -ios-line-break-mode: [wrap|character-wrap|clip|head-truncate|tail-truncate|middle-truncate] [label.lineBreakMode]
  -ios-number-of-lines: xx             {label.numberOfLines}
  -ios-minimum-font-size: <font-size>  {label.minimumFontSize}
  -ios-adjusts-font-size: [true|false] {label.adjustsFontSizeToFitWidth}
  -ios-baseline-adjustment: [align-baselines|align-centers|none] {label.baselineAdjustment}
}
```

## FAQ

### Why not use Interface Builder/why use CSS at all?

First off, not everyone uses Interface Builder. For those who do, there are a lot of similarities between using Chameleon and Interface Builder. Where Chameleon comes out on top, though, is in making it dead easy for anyone with a background in web design to style an iOS application. All it takes is understanding how CSS works and you’re good to go. CSS also comes with the advantage of cascading styles. You can define styles for an entire class of views and therefor reuse the styles throughout your application. Make a single change to a shared css file and suddenly your entire app’s style is updated.

Imagine this. As you are working on the app at your desk, the designer has an iPad propped up next to their laptop on the other end of the office. As you’re making modifications based on the new mocks the designer just sent you, _the changes are being reflected in real time on the designer’s iPad_. Talk about cool.

### When are you releasing this?

Hopefully by the end of this week. I haven’t moved up to the city yet so I’m still relatively devoid of anything to do at night down here in south bay (damn is it boring here) so I predict that I’ll have tomorrow night to focus on documenting and releasing Nimbus 0.9 complete with Chameleon and CSS.

If I don’t get it out tomorrow night though then it might have to wait until next week because I’m planning to go to the Treasure Island music festival this weekend. I haven’t been to live music in way too long.

Either way, look forward to getting your hands on this code shortly! As always it will be Apache 2.0 licensed. If you have any questions about Chameleon or Nimbus or why the hell I’d be in South Bay feel free to shoot me an email or @reply me on twitter: [@featherless](https://web.archive.org/web/20120103215437/http://twitter.com/featherless).
