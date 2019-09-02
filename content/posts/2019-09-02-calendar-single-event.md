---
title: "Adding Calendar details on events pages"
description: "Adding an iCalendar event as well as an 'Add to Google Calendar' link for each event on this site."
tags:
- www.jvt.me
- events
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-02T21:47:33+01:00
slug: "calendar-single-event"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
[In May I added an iCalendar feed for each type of events on my website]({{< ref "2019-05-22-ical-events-hugo" >}}), which enabled folks to subscribe to a calendar feed for i.e. all [Homebrew Website Club Nottingham events](/events/homebrew-website-club-nottingham/) with a single handy calendar feed.

However, this doesn't allow someone who's only looking to attend a single event or doesn't particularly want to have all the events in their calendar all the time.

Sparked by some conversations last week in the [IndieWeb chat](https://indieweb.org/discuss) around "Add to Calendar" support, I decided to implement some additions to events on this site.

I now generate both an iCalendar file for each single event, but based on some work that <span class="h-card"><a href="https://tantek.com">Tantek</a></span> has [documented on the IndieWeb wiki](https://indieweb.org/Add_to_Calendar), I also have added a link to add a calendar entry directly to your Google Calendar.

Happy calendaring!
