---
title: "Announcing a Service for Creating an iCalendar feed for event RSVPs: `rsvp-calendar.tanna.dev`"
description: "Creating a shared service to allow creating iCalendar feeds for tracking\
  \ what events you're attending."
date: "2021-10-15T15:00:51+0100"
syndication:
- "https://news.indieweb.org/en/www.jvt.me/posts/2021/10/15/rsvp-calendar/"
- "https://indieweb.xyz/en/indieweb"
tags:
- "calendar"
- "indieweb"
- "rsvp-calendar.tanna.dev"
- "architect-framework"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "rsvp-calendar"
---
[Two years ago](/posts/2019/07/27/rsvp-calendar/), I was attending a lot of in person events, and using a number of platforms to RSVP to them, with an RSVP also posted from my own site for completeness.

Because I was using different platforms, I would either have to copy events to my personal calendar, or utilise i.e. [Meetup's upcoming events calendar](/posts/2019/07/27/meetupcom-calendar/).

To have a central view of them, and as a very IndieWeb-y way of owning my data, I decided to create an RSVP calendar that would be built as part of my site, so I'd always have an up-to-date view of what events I was going to attend.

Since I've had it, it's been a _hugely_ beneficial to my life - I've had a handy view of current and past events, I have a URL that's easy to share this URL with my family, so they can track what I'm attending, as well as being able to easily hook it into my work calendar and having a [public calendar on my blog](/rsvps/).

As part of my move from my personal Micropub server to using <span class="h-card"><a class="u-url" href="https://barryfrost.com">Barry Frost</a></span>'s new server [Vibrancy](https://github.com/barryf/vibrancy/), I wanted to reduce the coupling of this calendar generation from the site, as Vibrancy may not be the best place for this to fit.

It's also something that can now be used outside of my own site - I've been testing it with a few folks' personal websites, so it's been handy to know that it works outside of my own feed of RSVPs.

Additionally, I've wanted to build something from scratch with [The Architect Framework](https://arc.codes) that Vibrancy is built on top of, to give me some experience with it, both so I can get a bit more practice before migrating my personal site over to it, and also cause I really like the idea behind it.

This service is now live at [rsvp-calendar.tanna.dev](https://rsvp-calendar.tanna.dev) and I've been using it for a few days with only a couple of problems.

On the first call to the endpoint, the application will go out and start to collect events, so maybe wait a couple of minutes before refetching the feed - hopefully then you should see events picked up!

For now, it won't have any support for historical data - so it will only show the list of events from the feed you provide it.
