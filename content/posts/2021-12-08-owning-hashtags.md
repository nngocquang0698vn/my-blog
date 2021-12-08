---
title: "Owning my Hashtags"
description: "Why I decided to treat hashtags in my (syndicated) content as tags on my site."
tags:
- indieweb
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-08T09:00:26+0000
slug: "owning-hashtags"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
Pre-pandemic, I was attending a lot of in-person meetups. One of the things I'd be doing a lot - like others at the events - is regularly tweeting about the great things the speaker is saying, the discussions of the community, or trying to win a prize!

Generally these tweets would contain an event-specific hashtag, like `#TechNott` for <span class="h-card"><a class="u-url" href="https://technottingham.com/">Tech Nottingham</a></span>.

Because I'd moved to tweeting via my site, via [Bridgy](https://brid.gy), I was seeing that these notes/replies with the hashtags were passing through my site with no way of _me_ being able to easily go back to them. Folks on Twitter could search for them, and I could use my search functionality, but I thought about how great it'd be to be able to access them via a category/tag.

In January 2020, I added support for this, with [the first tweet testing it](https://www.jvt.me/mf2/2020/01/cr6uw/) adding the `tech-nottingham` tag when seeing `#TechNott` in the content. This then got improved by [auto-linking the hashtags with their underlying tag](https://www.jvt.me/mf2/2020/05/dhrdl/) so a viewer could more easily go out to things with that tag.

Although this is my workflow, I've been looking at moving to <span class="h-card"><a class="u-url" href="https://barryfrost.com/">Barry Frost</a></span>'s project, [Vibrancy](https://github.com/barryf/vibrancy/), and so have been [discussing how this could be implemented](https://github.com/barryf/vibrancy/issues/24).

A design decision I'd made for my own Micropub endpoint is that I wanted to update the `content` of the post with the links so any Micropub consumer of the content would see it there, and more importantly, that I would add the `category` for each hashtag.

Thinking about it for Vibrancy, and the fact that not everyone may want this, I'm thinking that a new Microformats2 property, `hashtag`, may be more appropriate, which allows a Micropub client to render them using [a new `q=hashtag-replacements` query](https://github.com/barryf/vibrancy/pull/35), and doesn't enforce it for everyone, nor make the `content` a little harder to read.

I've found this to be really useful as a way of keeping visibility over the things I'm posting, and recommend you think about it too if you're interacting with silos that use hashtags!
