---
title: "Creating an iCalendar feed for my RSVPs"
description: "How and why I've created a public calendar for the RSVPs I send from this site."
tags:
- calendar
- blogumentation
- indieweb
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-07-27T11:24:48+0100
slug: "rsvp-calendar"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: 'Lobsters'
  url: https://lobste.rs
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
---
Those who know me or at least follow me on social media or know me will know that I like attending meetups. On any given month I'll generally go to 4-5 different events, but some months are busier than others.

As I mentioned in my post [_Add your Meetup.com Events to your Calendar_]({{< ref "2019-07-27-meetupcom-calendar" >}}), I've been using the Meetup.com calendar to easily see what events I'm going to, because there are quite a few of them and I don't want to manually add them to my calendar.

[In May I added the ability to start to posting other post types on my website](/notes/6b919e78-c46a-48e3-8866-9d9e9d41bb3d/), one of those content types being RSVPs.

Up until I has this capability, RSVPs were done on Meetup.com, Ti.to or Eventbrite. But now I had the ability to start to own my RSVPs, under the IndieWeb concept of [Own Your Data](https://indieweb.org/own_your_data), I started to post my RSVPs to my site first.

This made it much easier to be i.e. at work and wanting to show others what events I was going to, or to give others ideas of where to go. But the information there didn't used to include the event name or date, which made it annoying to work out when things were, so I added them to make my life easier reading them.

But [a couple of weeks ago](https://gitlab.com/jamietanna/jvt.me/issues/566) I had a crazy thought - what if I could stop relying on Meetup's calendar integration and instead use my own? That's the whole point of the IndieWeb right? Take back control and own all your data.

I already had some of the data, so I could probably enhance the contents of the RSVPs to include an end time and a location and that'd be as useful as the Meetup.com calendar integration, or manually adding items to my calendar.

Once I'd added all of those, it was then a case of creating a calendar for it. Fortunately, I'd [already done this with a calendar for Homebrew Website Club]({{< ref "2019-05-22-ical-events-hugo" >}}) which is straightforward with Hugo, so all I needed to do was map the RSVP's data to a calendar entry.

And there you go, I now have [a handy iCalendar link](/rsvps/index.ics) to an always up to date calendar of all my RSVPs - awesome! And because it's all up on my website, this link is available for anyone who also wants to follow me to events.
