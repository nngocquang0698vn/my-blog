---
title: "Make Your RSS Feed Discoverable"
description: "Why and how you should make it possible to automagically discover your feed(s)."
date: 2021-11-10T19:06:35+0000
tags:
- blogumentation
- rss
- feed
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "rss-discovery"
---
# Why?

Hopefully you're providing an RSS/Atom feed for folks to subscribe to your posts, and if not - please do add one! It's a great way for folks to continue to keep up to date with your posts.

One thing to improve discoverability of whether your site has a feed is to have a [/feeds page](https://marcus.io/blog/making-rss-more-visible-again-with-slash-feeds), or as I've got, a [/subscribe/ page](/subscribe/).

But there's also a way of doing this so it's even easier to discover whether someone's got feeds.

By implementing [RSS Feed Discovery](https://www.rssboard.org/rss-autodiscovery), you can make it so an avid reader can point their feed reader to your blog's URL, and it'll automagically discover your posts.

It's a great way to make feeds discoverable, on top of the user doing it themselves.

# How

As noted in the link above [RSS Feed Discovery spec](https://www.rssboard.org/rss-autodiscovery), you need to add a `<link>` attribute in the `<head>` element in your site's page(s):

```html
<link rel=alternate type=application/rss+xml href=/feed.xml title="Jamie Tanna | Software Engineer">
```

Something to make sure you do is add the `type`, as a lot of readers require it, which is fair enough as it's in the spec, but caught me out recently.

It's that straightforward, and even if it only makes my life easier for subscribing to your posts, please do it!
