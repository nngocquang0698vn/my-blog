---
title: "Hello IndieNews!"
description: "Discovering IndieNews and starting to syndicate my posts to it."
categories:
- announcement
- indieweb
- microformats
tags:
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-27T21:50:00
slug: "hello-indienews"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
---
Yesterday I learned about the [IndieNews](https://news.indieweb.org/), which describes itself as:

> IndieNews is a community-curated list of articles relevant to the Indie Web.

I'd been recently wondering about having an alternative to [Hacker News](https://news.ycombinator.com/), but for more IndieWeb-related content. [Lobste.rs](https://lobste.rs) has been giving me some of that up until now, and I've started to get more involved on the [IndieWeb chat](https://indieweb.org/chat), but finding IndieNews has definitely hit the spot!

However, as well as consuming the posts on the news site, I also want to be sharing out my own content. As per [the instructions on IndieNews' site](https://news.indieweb.org/en/submit), I needed to add a `u-syndication` link to the IndieNews site on each page that I'd want to syndicate to it.

For now, I've added support to my blog posts and my events posts, as they're the most interesting, but as and when there's more content types, I'll update them, too.

Currently the process of initiating the syndication through webmentions is manual, because I don't have automagic webmention sending, but [I will be tackling this soon](https://gitlab.com/jamietanna/jvt.me/issues/408).

UPDATE: As pointed out by [Greg's reply to this post](https://quickthoughts.jgregorymcverry.com/2019/03/27/-this-is-awesome-indienews-is-our), always syndicating to IndieNews is a _bad idea_. <s>As such, I've opened [an issue on my site](https://gitlab.com/jamietanna/jvt.me/issues/409) to fix this, and make syndication opt-in where necessary, so as not to spam the various channels I'd want syndicating.</s> As part of [issue 409 on this site](https://gitlab.com/jamietanna/jvt.me/issues/409), syndication is now opt-in per piece of content.
