---
title: "Creating a 'Firehose' Feed"
description: "Splitting out my content feeds, so it's (hopefully) more applicable and less noisy for consumers."
tags:
- www.jvt.me
- indieweb
- feed
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-04T08:29:50+0100
slug: "firehose-feed"
syndication:
- https://news.indieweb.org/en
---
If you visit my site, you'll notice that I'm big on the [IndieWeb](https://indieweb.org/why), and [owning my own data]({{< ref 2019-10-20-indieweb-talk >}}).

This means that my site is my castle, and I aim to publish here, first, before publishing elsewhere. However, that means my site serves two purposes - as a home for my [blog posts](/kind/articles/) and collection of [Blogumentation posts]({{< ref 2017-06-25-blogumentation >}}), and as the base for all my social interactions.

For a while now, I've been wondering about whether having my home page showing all the likes, replies, etc is meaningful, or if folks trying to find my site really care.

Given I like a lot of things on Twitter, those just flood the feed, and get in the way of other, maybe more meaningful content, such as my own thoughts, or an RSVP to an upcoming event.

So last night I set up a ["firehose" feed](https://indieweb.org/firehose) which can be found at [/all/](/all), and contains literally all the content on my site. It is expected to be much nosier, and likely contain things you don't care as much about like [how many steps I did yesterday](/kind/steps/) or [all those likes](/kind/likes/) I post.

Hopefully this helps make it easier for you as a reader to follow my site, and not get waylaid with content you don't like.

If the feed still isn't quite enough, you can subscribe to a feed of [specific post kinds](/kind/) that you're interested in.

Currently I've only just done this for my [Microformats2 feed](https://microformats.io), not my RSS/JSON feeds, as my Microformats2 feed is my preferred feed for consumers.

This was pretty straightforward to set up using Hugo, as I was able to create a new Section in the site, `all`, which uses the `list` template to generate the listing for all the pages.
