---
title: "Adding iCalendar Feeds for Events in Hugo"
description: "Using Hugo's custom output formats to automagically create an iCalendar feed for events."
tags:
- announcement
- events
- www.jvt.me
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-22T12:15:03+0100
slug: "ical-events-hugo"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
While running [Homebrew Website Club Nottingham](/events/homebrew-website-club-nottingham/), I've been manually reminding the group of when the next event is.

However, this hasn't been the best because if I'm not on top of it, it means others won't see the events being posted.

I'd created an [h-feed]({{< ref "2019-05-12-implementing-hfeed-making-content-discoverable" >}}) for the events, but as not everyone has support for an [Indie reader](http://indieweb.org/reader), it doesn't quite make sense.

So I posted in the Slack channel we're using to talk about it, and a couple of the comments were "don't use Meetup.com" and "what about calendar invites".

However, being the super lazy person I am, I didn't want to have to create a calendar entry _each and every event_ so I've now created an iCalendar feed, which is linked on each of the events pages to let others subscribe to that and have it handily appear in your calendar app of choice.

This was fairly straightforward easy with Hugo, as it already supports rendering iCalendar entries. To get it fully working, I had to create the ICS file in `layouts/events/section.ics`, and then hook it in correctly in my `config.toml`:

```diff
 [outputs]
-section = ["HTML", "RSS"]
+section = ["HTML", "RSS", "Calendar"]
```
