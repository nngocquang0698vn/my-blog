---
title: "Auto-announcing Events in my Feed"
description: "Updating my main site feed to publish a note when I've published a new event."
tags:
- www.jvt.me
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-05T22:11:33+0000
slug: "announce-events-feed"
series: nablopomo-2019
---
As you may have read before, I run a [Homebrew Website Club in Nottingham](/events/homebrew-website-club-nottingham/), and the events are announced on this website.

However, up until now, it's been a pretty poor experience because folks don't see the events as they're published, but have to keep checking back, or messaging me elsewhere to see if the event is happening this month. This isn't ideal, as not everyone wants to do this.

I really like how <span class="h-card"><a class="u-url p-name" href="https://tantek.com">Tantek Çelik</a></span> publishes his events in the feed, but wasn't sure if I wanted to publish the whole `h-event`, but instead a subset of the markup for the post. In the future I may change my mind, but for now it'll be a smaller set of information on the announce post.

You should be able to see in my feed that a few new HWCs have been published and that there are links to the event itself as well as the ability to add it to your calendar of choice.

Note that the announces themselves are `h-entry`s but don't actually reside at a URL because they're not technically a piece of content in the site. This is intentional for now, but maybe at some point I'll make it create an actual post to announce it, or remove the `h-entry` markup.
