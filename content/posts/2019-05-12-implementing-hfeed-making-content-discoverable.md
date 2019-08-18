---
title: "Implementing h-feed, and making all site content discoverable"
description: "Announcing h-feeds for this website, and making it easier to read non-blog posts."
tags:
- announcement
- microformats
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-12T18:43:54+01:00
slug: "implementing-hfeed-making-content-discoverable"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
With this announcement, I have two great pieces of news.

The first, is that you'll now be able to follow my website's [h-feed](https://indieweb.org/h-feed), which is a [microformats2](http://indieweb.org/microformats2) structure for a feed of data. This is in addition to my RSS feed ([/feed.xml](/feed.xml)) and [my JSON feed]({{< ref "2019-04-07-jsonfeed" >}}) ([/feed.json](/feed.json)), and will allow further interoperability with the IndieWeb.

The second is that I've now made all&#42; my content discoverable in these feed formats, including the types announced in [_Extending www.jvt.me to allow for other post types_]({{< ref "6b919e78-c46a-48e3-8866-9d9e9d41bb3d" >}}). They are rendering their content accordingly depending on the post type, and I've been able to make them nicely de-duplicated, [which I'll blog about shortly](https://gitlab.com/jamietanna/jvt.me/issues/464).

&#42; I say all content is now discoverable in feeds, but I don't quite mean it. That's because I'm not displaying static pages such as [/about/](/about/), events pages, nor projects or talks. That's because these are static and don't make sense to exist in a regularly-changing feed.

That being said events listings i.e. that of [Homebrew Website Club Nottingham](/events/homebrew-website-club-nottingham/) _are_ powered by an h-feed, so you can still follow them.

I've set up h-feeds in the following places:

- on the front-page of this site
- on a per post type basis, i.e. [/mf2/](/mf2/), [/posts/](/posts/)
- on taxonomy pages i.e. [/tags/announcement/](/tags/announcement/)

Unlike some of the previous changes I've made to this site, I've decided to not (at this time) create any automated tests for validating whether the h-feed is well formed, instead deciding to manually verify whether it works.

This h-feed setup is [officially termed a composite stream](https://indieweb.org/composite_stream), as it draws all content types into a single feed.
