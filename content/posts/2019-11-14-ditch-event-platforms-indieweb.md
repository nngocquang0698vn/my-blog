---
title: "Ditching Event Platforms for the IndieWeb"
description: "How we can replace event platforms like Meetup.com with your own IndieWeb-backed platforms."
tags:
- meetup.com
- events
- rfc
- indieweb
- nablopomo
- personal-website
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-14T18:52:33+0000
slug: "ditch-event-platforms-indieweb"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
- text: Lobsters
  url: https://lobste.rs
- text: Hacker News
  url: https://news.ycombinator.com/
---
# Context

Recently there's been a big shift to move away from [Meetup.com](https://www.meetup.com/) as a platform.

Something that may come as a shock to most attendees of events is that organisers have to pay for each of you to be part of the Meetup group, even if you are just there to keep up to date on events, but don't attend anything.

Some organisers [just don't fancy spending the money on it](https://lukeb.co.uk/2019/11/11/building-the-new-leedsjs-website/), and some are outraged by [the news about new monetisation strategies](https://www.theregister.co.uk/2019/10/15/meetup_fee_increase_backlash/) that Meetup may be looking at moving to.

These issues have led many groups to investigate the alternatives that we can pursue, but unfortunately many have decided to build their own instead of pooling resources with the existing Free or Open Source platforms, [of which there are many](https://marcusnoble.co.uk/2019-10-21-meetup-alternatives/).

It's really great to see folks trying to build a better platform, and to look at owning their own data once again, but I'd like to throw something else into the ring - an [IndieWeb solution for marking up events](https://indieweb.org/event) and [allowing folks to RSVP](https://indieweb.org/event) from your website.

Within the [IndieWeb community](https://indieweb.org/why), we use the personal website as the first class citizen - everything you do is driven by your website. This principle allows organisers to own their event fully on their own website, and allows attendees to own their attendances to events on their own website.

Since starting [Homebrew Website Club Nottingham](/events/homebrew-website-club-nottingham/) in March, I've been running it in this fashion, with folks RSVPing via their websites (although only a few folks do it so far).

# What It Would Look Like

So what would this actually look like for folks using it?

For an organiser, this requires your event to have a website, which most of the tech meetups I'm part of do - but yours may not. One of the principles of the IndieWeb is that it revolves around a website so this will need to be your first step.

Next, we will need to mark up your HTML for the event with some [Microformats2 metadata](https://microformats.io). The below is an example from [Homebrew Website Club Nottingham on December 11th](/events/homebrew-website-club-nottingham/2019/12/11/):

```html
<div class="h-event">
    <h1 class="p-name">Homebrew Website Club: Nottingham</h1>

    <p class="p-summary">Homebrew Website Club on December 11th.</p>
    <p>
        From
        <time class="dt-start" datetime="2019-12-11T17:30:00+0000"> Wed, 11 Dec 2019 17:30:00 GMT </time> to
        <time class="dt-end" datetime="2019-12-11T19:30:00+0000"> Wed, 11 Dec 2019 19:30:00 GMT </time>

        <span class="p-location h-card"> at
          <a href="http://www.ludoraticafe.com/" class="u-url p-name">Ludorati Cafe</a>

          <span class="p-street-address">72 Maid Marian Way</span>
          <span class="p-locality">Nottingham</span>
          <span class="p-country-name">United Kingdom</span>
          <span class="p-postal-code">NG1 6BJ</span>
        </span>
    </p>

    <div class="p-description"> ... </div>
</div>
```

This makes all the event's metadata machine-readable, although it's not all required for your event to be used by folks.

For an attendee, they'll then need to publish [an RSVP post to their site](/mf2/2019/11/r5xqf/):

```html
<div class="h-entry">
        RSVP <span class="p-rsvp">yes</span> to
        <a class="u-in-reply-to"
          href="https://www.jvt.me/events/homebrew-website-club-nottingham/2019/12/11/">
            HWC
        </a>
    </p>
</div>
```

That's the simplest markup you can use for it, but if you want to add a bit more I've written [a bit more detail in _How to RSVP to an Indie Event from your Website_]({{< ref "2019-08-21-rsvp-from-your-website" >}}), including how you let the event know you've RSVP'd.

This model allows anyone to RSVP to an event, and because it uses your website, costs as little as whatever you're currently paying in server maintenance, but not nearly as much as the Meetup.com charge! There are also some free hosted options for IndieWeb services, so you don't need to host or write your own.

# What if an attendee doesn't have a website?

But, I hear you say, that doesn't help folks who don't have a website, which is a really good point!

We don't want that to be a barrier to folks getting involved in our events, so we need to have an alternative for folks who don't have a website.

<span class="h-card"><a class="u-url" href="https://carolgilabert.me">Carol</a></span> recently showed me the [QueerJS](https://queerjs.com/) website, which has started to own their events, too.

It's a nice system, and allows folks to link their GitHub account as a means to RSVP. This is a nice way of doing it because it'll provide a handy photo for each attendee, if they want to.

I propose that we work on a new platform ([xkcd: Standards is not lost on me](https://xkcd.com/927/)) that provides the ability for someone to RSVP without having their own website. Similar to QueerJS, you would provide details of your i.e. your Twitter or GitHub username, and it'd create an RSVP on your behalf.

This would reduce the biggest complexity of the IndieWeb solution, although if possible, we should look to having folks RSVP from their own websites.

Unfortunately there are a couple of gaps in the solution:

- [size limits / waitlists are a little more difficult to implement with this](https://indieweb.org/event#How_to_limit_capacity)
- discoverability is the hardest part of building decentralised systems. In Nottingham we have [Nottingham.Digital](https://nottingham.digital) to discover all events around Nottingham, but it's difficult to do this across all places and all types of events - that was something that having a centralised platform works well for.

I'd very much appreciate feedback on all this - there are links at the bottom of the page for how to get in touch with me, and please share this to get more feedback from event organisers.

Want to know what this IndieWeb thing is all about? You can read [a transcript of my talk _The IndieWeb Movement: Owning Your Data and Being the Change You Want to See in the Web_]({{< ref "2019-10-20-indieweb-talk" >}}) for an overview of what it is and some of the things we stand for.
