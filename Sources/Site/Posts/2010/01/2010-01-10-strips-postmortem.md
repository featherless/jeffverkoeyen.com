# Strips postmortem

During the summer of 2009 I made a big decision. It was early in the academic term and I had just received my first midterm mark.

It was 30%.

Never in the history of my academic career had I received a midterm mark below 50%, but this 30% wasn’t a shock to me. I had been spending nearly all of my time outside of the classroom working on what would soon be one of my largest projects to date, the Strips platform.

When I saw the failed mark on my midterm I took some time to think, as anyone should do when this sort of thing happens. I came to the conclusion that I had reached a point in my academic career where I strongly believed that I had the chops to build something, and that I needed to do it _right then._

So I took the plunge. I dropped three of my four courses and spent the next three months working full time on the Strips platform.

This is its post-mortem, and I hope to leave this as a note to myself and anyone else who has the desire to build something.

## The Strips Platform

The basic one-liner for Strips is this: a mobile application that puts syndicated web comic content into the palm of your hand. In more detail, it’s an iPhone app with all the flair of a native Apple app, and all the content of your favorite web comics. It had pinch-to-zoom, double-tap-to-zoom, offline reading, push notifications (for when new strips were available), archive viewing and searching, social network sharing, the ability to email strips to friends, alt-text viewing, and landscape reading modes. You name the feature, Strips probably had it. It even let you shake the phone to pick a random strip.

But that’s just the part the customer saw. In the backend I had built an entire architecture for aggregating content from RSS feeds, pushing the data to an Amazon S3 tier, and even used Google’s App Engine for housing all of the push notification information. This meant that the entire web comic’s content was mirrored on a scalable storage solution (S3), inflicting zero cost to the publisher except the initial cost of archiving (which is equivalent to the cost Google’s spiders incurs). So as far as the web comic artists were concerned, Strips caused zero-impact to their existing infrastructure.

The biggest question about Strips was mostly about how the artists were compensated. Obviously it would be stupid of me to rip these artists’ content out of their ad-driven websites and display it on the mobile device ad-free. For many web comics, the ad revenue is their butter. Merch sales are often the bread, and their readers love buttered toast (who doesn’t?). And for many web comics the analogy is reversed. Regardless of where they make most of their revenue, it was crucial to recognize the fact that ads were part of this ecosystem.

To address this problem, I built ads into Strips that were served on a per-publisher basis. This meant that whenever you were reading strips from Penny Arcade, the revenue from the ads that were displayed would be given on an 80/20 split to Penny Arcade. The 20% cut was calculated to cover my personal costs of bandwidth and servers (and is a damn good deal by most publishing house standards). I also built in detailed analytics so that web comic artists would be completely aware of how many users were viewing their content on Strips, for how long, and even how often their content was shared. This data was all anonymized, of course.

Here’s the basic Strips platform so far.

*   An iPhone application, Strips
    
*   Automated S3 data duplication for all of the publisher’s content
    
*   Ad-revenue model for artists
    
*   Analytics for artists
    
*   A push notification service (within minutes of new content being posted, your phone would buzz)
    

From the beginning of Strips’ development, I knew that this product would only reach its maximum potential with support from the artists themselves. I began a campaign of sending emails to artists that started with a number of the bigger players. I sent a general email with a customized “pitch page” showing their content in the iPhone interface.

Feedback was abysmal. Of the 15 or so comics that I initially emailed, only three responded, two saying they didn’t want to be a part of it. The other was incredibly interested. And so even with the abysmal number of responses, I had my first client.

My excitement started to brew.

By mid-July, I had my first working version of the application ready for beta testing. The initial reviews from users were quite positive. People loved the intuitive interface and the ability to read their comics in a consistent, convenient format. They didn’t have to trough through multiple websites with varying navigation methods just to read their favorite comics anymore.

By this time I had sent out emails to a dozen more web comic artists and still, no word. So I continued to work on the project, hoping that I would soon receive word one way or the other from anyone.

August came and went, and I was on my way to my last co-op term for school. Strips was a completed product and submitted to the App Store for review. The first submission came back rejected, as I expected, and I fixed the minor issues and resubmitted. This process eventually involved four submissions and three rejections, with the final acceptance of my app into the App Store nearly a month and a half later.

All throughout this time I was actively emailing the artists. I sent a second round of emails to the artists who still hadn’t responded to my first round, letting them know about the new analytics system and the ad model. Still no answer.

At this stage I had a fully working platform ready to be launched on the App Store. The entire platform was built and designed to be as low-impact to artists as possible, costing them near-zero in bandwidth, while bringing a whole new set of readers to their content. So I decided that since the entire platform was a win for the artists in every possible way, I launched it. What could possibly upset them, right?

So Strips launched as a paid app at $1.99. It launched as a paid application because my rationale was that it was a reader, just like the Kindle or the Nook is, or any RSS reader for that matter. You pay for the device to read the syndicated content and then you can pay to read specific items available on the device. This seemed sensible to me as I’d put a large amount of effort into the application.

The app was live for a little over a month and a half, and sales were trickling in. By October I had sold about 200 copies of the app at $0.99 and 50 copies at $1.99. The user metrics were what really impressed me, though. From the aggregated analytics, I found that most users were spending _on average_ about 45 minutes to an hour _every day_ using Strips. I was excited to let the web comic artists know about this amazing statistic.

In late October, on the 26th to be precise, Scott Kurtz of PvP finally noticed Strips. Sadly he noticed it in the one light I never imagined it would be seen in: as theft.

That Monday I began the day like I began most days at the time, on my way to work I opened Tweetdeck and checked out all of my twitter filters for any talk about Strips or any related subjects (web comics, webcomics, iphone web comics, etc…). I was receiving dozens of tweets per minute to my @stripsapp account, declaring that I was a thief and should be tossed in jail. Around that same time I received an email from Scott Kurtz himself, demanding that I remove his content from the app immediately, which I did. I then engaged in a draining campaign to contain the fires that were popping up all over twitter and the blogosphere.

I realized quite quickly that the public opinion of my app was lowering, and _fast_. With the heat of a number of popular web comic artists on my neck, I quickly began pulling the plug on the live apps. I had thankfully designed functionality into the platform from the get-go that let me add and remove comics on the fly, even for existing installations. Once the content from all of the artists had been removed, I removed the Strips app from the App Store and posted an apology to the Strips website. Over the next 24 hours I received countless emails and tweets from prominent web comic artists calling me a thief and a criminal, and some threatening legal action against my part.

I was scared shitless.

To have the entire community that I had spent the five previous months working to help turn on me hit me pretty hard. After the fires had calmed down and I’d stopped receiving hate letters I came to the conclusion of one thing. If you’ve been reading up this point, then you’ll be happy to know that this is the biggest, most important thing that I learned from this, and will never forget.

_It’s really fucking hard to run a company as just one person_. Don’t let the obviousness of that statement make it seem trivial. Never, _ever_, underestimate the value of having someone else to double-check your decisions and to challenge your thoughts on a day-to-day basis.

So let’s get into the more structured part of the postmortem, shall we?

## What went right

Though Strips ended in a fiery crash-and-burn, the personal experience I gained from this project was unmeasurable. If there is ever a point in my life where I think I will someday look back and say “that, that right there; that’s when I got my shit together”, October 26th 2009 was that day. I needed a solid kick to the head to make me stop thinking that I could one-man-show every project I worked on. I’d become complacent in my passion, and I needed to snap back to attention.

Strips was also a great technical landmark in my personal experience. I proved to myself that I could build a fully-functional platform from the ground up, that I could do it in record time, and that I had somewhat of an idea how to scale it.

The development track of Strips followed the track of most of my software projects: rapid iteration and fast prototyping. I was able to build the first working prototype within the first week of development and by the end of the first month had three web comics supported on the platform. Over the next month I increased that number to 20 and built a full push notification service that operated in near real time (a sneaky way of saying that I just polled the RSS feeds on a regular basis).

I also had a great pool of testers throughout the development of Strips. I set up a Google group and had an active mailing list with which I got a solid amount of feedback.

## What went wrong

The single largest mistake I made was to launch too early, before I had received complete consent from all of the artists whose content I supported. The irony here is that as of January 9, 2010, Comic Envi is still available in the App Store as a paid app, and they blatantly pull the web comic’s content into their app with no ads or any mention of support from the original artists.

I also made the mistake of assuming that artists would see the value of Strips the same way I did. I worked hard to convey to the artists every way in which they’d receive revenue and analytics, but at the end of the day their first impression turned out to be far from what I’d imagined. This was largely my fault, and some part sensationalization on twitter. I shouldn’t have used the artists’ logos on the web site as a way to say “hey look, these artists are supported by Strips”. A gradual roll out of Strips with only the supported artists along the way would have kept the project alive and hopefully generated enough momentum over time to convince the larger players that it was a viable platform.
