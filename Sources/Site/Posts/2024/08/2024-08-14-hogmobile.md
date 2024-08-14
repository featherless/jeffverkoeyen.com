# Hog Mobile

I'm a big fan of [PostHog](http://posthog.com) from a product and design point of view. As an
alternative to MixPanel, the entire company feels distinctly more personal, and certainly tailored
better toward indie founders with a decently sized free tier that scales in cost with use.

One thing that's been missing for me though is a mobile experience. I want to be able to easily
check my product metrics on the go, ideally via widgets, and it turns out PostHog has an awesome
[API](https://posthog.com/docs/api)!

So as a way to give back to the community and scratch my own itch, I'm building a little app for
PostHog called Mobile Hog. You can sign up for the beta once it's ready at
[hogmobile.com](https://hogmobile.com).

![An illustration of a hedgehog driving a car](/gfx/hogmobile.png)  

## Building a sign up page with Slipstream

This is the second site I've built with Slipstream, and I'm pretty biased but it's great to get
to work in a unified workflow across mobile and web. Over a period of ~3 days I was able to build
a rapid prototype in SwiftUI *and* translate the app's landing page UX into a website.

The source is available at [github.com/jverkoey/hogmobile.com](https://github.com/jverkoey/hogmobile.com).

The website is simple, with just a home page with a single-field form and a thank you page. I'm
trying to stay scrappy with services, so the form posts to [a tiny cloud function](https://github.com/jverkoey/hogmobile.com/blob/main/backend/cloudfunctions/collectEmails.py)
that stores the email address in a private Google Sheet.

### Buttons

A couple weeks back I'd written a post about building Duolingo's buttons in SwiftUI. The Hog Mobile
buttons are built off of similar ideas, but these ones also work on the web as a Slipstream
component.

Hover over the button to slightly depress it, and click to fully squish the button in.
Super tactile and I love it. I think you will too :)

![A red, extruded button that depresses when hovered and clicked](/gfx/hoverbutton.mov)

### Hedgehog driving animation

This was particularly fun to make. I sketched out the svg in Inkscape and then rendered it as a
stack of layers. The layers are then individually key-framed using CSS keyframes to give this "out
for a Sunday cruise" sort of aesthetic. Look at the paw on the steering wheel! Such a chill little
guy.

![A chill hedgehog driving its car](/gfx/hogmobile-animation.mov)

### Thank you animation

If you fill out the sign up form I wanted to create a scene of celebration, so I added some
CSS-animated fireworks to the thank you page. I think
[this song](https://music.apple.com/de/album/pomeranian-single/1714771610?l=en-GB) is a perfect
accompaniment to the animation :)

![A chill hedgehog driving its car](/gfx/hogmobile-thankyou.mov)

## Next steps

From the initial usage of the site the most obvious thing that's missing is some screenshots of the
app concepts, so I'll be drafting up some mocks to add to the site soon.
