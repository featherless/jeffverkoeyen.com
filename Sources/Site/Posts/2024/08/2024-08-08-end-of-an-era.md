# End of an era

I've been hearing this expression a lot lately. Most notably though because I handed in my
resignation at Google after a [10+ year career there](/portfolio).

> It is hard to overstate the impact you've had on me, my project, and Google as a whole.  You have been a powerful advocate for excellent user interface design that helps our users, an advocate for effective brand presence in our designs that helps communicate the value of Google, and an advocate for excellent software design that makes all of this possible at Google scale.  And it has been a pleasure and privilege to partner closely with you over the years...    
> — Translate iOS Lead 

## Ten years at Google

I feel it's pretty unusual in the tech industry to stay in one company for more than a couple of
years, and that it's even more unusual to stay on the same team for more than a few years.

I was on the same team, in essentially the same effective leadership role (Google Design for
Apple Platforms), for my entire 10 years at Google.

This is in part because I founded the team. As a continuation of my time leading Three20
and then Nimbus, I was fortunate to join Google at around the time that Apple decided it was going
to make its own Maps application. This was one of those unique moments where a combination of timing
and ability and opportunity all converge into what we call luck, and I was certainly lucky to join
the team that went on to [launch Google Maps for iOS](/portfolio#maps) half a year later.

When I joined the Maps team to help lead the UI efforts, I made a couple important decisions:

1. We'd build the user interface components as if they were already open source.
2. I'd arrive to work every day on the last shuttle in, leave every day on the
   earliest shuttle out, and I'd be one of the most productive members of the team in doing so
   (*narrator: he was*).

I'll expand on point #2 in another post someday.

> Jeff not only designed and implemented a large chunk of the Maps UI, but he was also a key
> player in doing code reviews for the other members of the team. Basically any change to the
> UI has Jeff's name on it as either the implementor or the reviewer.    
> — Leadership feedback, 2012

### Build it like it's already open source

Every user interface component we built for Maps was built in a standalone directory as if the Maps
app didn't exist. This was in 2012, when Google hadn't converged yet on a unified design language
and the concept of a "design system" was still nascent. This decision ended up forming the
foundation of what became Google's central set of user interface components for iOS, eventually
being open sourced as Material iOS (albeit being heavily influenced by Android along the way).

After a year and a half sabbatical to travel the world, I rejoined Google on the team (Material)
that had formed around Maps' now-centralized UI components. Material the org served Android, the
web, and iOS as three distinct platforms but with an over-arching design language that unified them
all. Concepts like the floating action button, solid colored navigation bars, and floating snackbars
all emerged from the Material team.

![Nimbus looking out a window in New York](/gfx/nimbus.jpg)

> Nimbus, looking out a window in New York City.

For the next six years or so I worked closely with hundreds of teams across Google to support their
ability to build and launch a wide variety of apps for iOS. From Translate to Photos, Gmail to Chrome,
YouTube to Search, my team worked like honey bees, identifying emerging UI patterns and
cross-pollinating them to other apps via shared component libraries.

<div class="flex flex-row items-center justify-center flex-wrap">
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/calendar.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Calendar</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/chat.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Chat</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/chrome.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Chrome</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/docs.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Docs</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/drive.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Drive</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/gmail.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Gmail</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/google.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Google</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/home.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Home</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/keep.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Keep</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/maps.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Maps</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/meet.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Meet</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/photos.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Photos</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/sheets.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Sheets</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/slides.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Slides</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/tasks.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Tasks</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/translate.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">Translate</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/youtube.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">YouTube</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/youtubekids.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">YT Kids</p>
  </div>
  <div class="flex flex-col items-center m-2">
   <img src="/gfx/google/youtubemusic.webp" class="rounded-lg h-16 w-16 border-4 border-white rounded-2xl shadow-puck mb-1">
   <p class="text-sm text-zinc-700 dark:text-zinc-300">YT Music</p>
  </div>
</div>

> Thanks for making the iOS community at Google (and elsewhere!) such a wonderful place to work. I really appreciate your incredible attention to detail, care for the user, and most of all, your light touch with creating APIs and tools that can be hammered on by hundreds or thousands of developers. That's a unique talent!    
> — Multi-app/infra lead

### 2021: A shift in strategy

The decision I'm most proud of my team making was the self-acknowledgment that the shared
libraries we'd built since 2012 had started to show their age.

<blockquote class="twitter-tweet" style="height: 318px"><p lang="en" dir="ltr">This year my team shifted the open source Material components libraries for iOS into maintenance mode. Why?<br><br>A 🧵...</p>&mdash; Jeff Verkoeyen (@featherless) <a href="https://twitter.com/featherless/status/1446151509549387781?ref_src=twsrc%5Etfw">October 7, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Apple had made countless improvements to their UI frameworks over the years. As time progressed,
these improvements resulted in an ever-increasing divergence between the "canonical" iOS experience
and Google's iOS apps. 

So in 2021, instead of measuring success via up-and-to-the-right adoption charts, we started
celebrating a *reduction* in usage of our APIs. This ran counter to most schools of thought in our
org, particularly the institutional desire to unify design systems across all platforms, and yet it
was without a doubt one of the best decisions we ever made for both our developer community and our
users.

> Jeff, you've had an immeasurable impact on this team and the iOS community at Google. I'll miss your enthusiasm for learning new things, your deep technical expertise, and your passion for design that puts the user first; at the same time, I know that those traits will serve you well, wherever life takes you next. Whatever that may be, I know that you'll tackle it with fervor and aplomb, and I wish you the very best on your journey.    
> — Staff SWE on my team

### 2023: The big shake-up

In 2023, the mass industry-wide layoffs happened, and notably so at Google. The tech industry as a
whole has changed in many ways since then.

For me, it caused a significant re-evaluation of my ability to continue to make a positive impact.
Rolling layoffs make it difficult to plan for anything more than a couple months ahead of time, and
I'm a longitudinal thinker at heart.

So it was with a heavy heart that I decided to hand in my resignation at Google in 2024. I'll
always cherish my time at Google. Google's Appledev community always felt to me like a big,
extended family, and I'll miss it dearly.

> I really thank you for making Google a better place for iOS engineers and for those of us who are passionate about Apple's platforms.    
> — Chat iOS lead

### What's next

I'm not 100% sure yet! I'm planning on keeping my mind (and calendar) open for quite some time.

In the weeks since leaving Google, I've updated this website and built a Swift static site generator
to do so that I think is pretty neat: [Slipstream](http://github.com/jverkoey/slipstream/).

Medium term, I'd like to start a bootstrapped company, one that's able to focus on long-tail
problems without worrying about short-term returns. Stay tuned :)

> Jeff, I am so grateful that I had the amazing fortune of working with you. You're brilliant, kind, empathetic, creative, and just amazing beyond belief. I'll miss you and the amazing culture you created.
>
> Working with you has been the highlight of my career. You saw my full potential and created opportunities for me to shine. And you always celebrated everyone's successes. 
>
> Thank you for being you and showing me what's possible! 💚
>
> Life is made of chapters and everything is temporary, so as this chapter comes to an end, I am looking forward to seeing how your creativity, talent and hard work impact the world around you.    
> — SWE on my team

![Jeff at WWDC 2008 on a student scholarship](/gfx/wwdc2008.jpg)

> A photo of me from my first internship at Google in 2008, when I attended my first WWDC on a student
scholarship.
