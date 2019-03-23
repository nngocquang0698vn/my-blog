---
title: "Marking up Events with Microformats"
description: "Announcing the events content type and their markup with `h-event`."
categories:
- announcement
- indieweb
- microformats
tags:
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-23
slug: "microformats-hevent"
image: /img/vendor/microformats-logo.png
---
As I called out in [_Homebrew Website Club: Nottingham, Session 1_]({{< ref 2019-03-20-hwc-nottingham-session-1 >}}), I wanted to have Microformats automagically generated for the content.

This was because I had manually hand-crafted this [`h-event`](http://microformats.org/wiki/h-event) for the [last event]({{< ref 2019-03-14-homebrew-website-club-nottingham >}}), which although perfectly fine was a bit more work than I'd want to do in the future, as well as duplicating a lot of the basics of the markup across many events.

However, before I did this, I needed to have a new content type in Hugo for these events, so I could render them differently than blog posts / content pages. This is as simple as creating a new folder in Hugo's directory structure, which is really nice, and then adding the relevant templates in my theme to render the `h-event`s.

The largest piece of work for this ([as with the work for `h-entry`s]({{< ref 2019-03-19-microformats-hentry >}})) was getting HTML-Proofer checks in place to verify that the content is well-formed and that I don't have regressions in the future.

This is very exciting for better interoperability with others!
