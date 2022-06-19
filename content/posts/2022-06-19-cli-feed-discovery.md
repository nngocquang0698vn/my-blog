---
title: "Automagically determining feeds provided for a given URL on the command-line"
description: "Creating a command-line application to discover feeds for a given URL."
date: "2022-06-19T21:21:36+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1538628193418194944"
tags:
- "go"
- "rss"
- "feed"
- "slack"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "cli-feed-discovery"
---
I'm a big fan of feed formats like RSS/Atom, Microformats2 and JSON feed, and like to use a feed reader as my primary reading source.

One of the great things about things like I mentioned in [_Make Your RSS Feed Discoverable_](https://www.jvt.me/posts/2021/11/10/rss-discovery/) is that there are built-in ways that you can make them automagically discoverable to tools like feed readers.

However, sometimes you need to manually discover them, for instance if you want to add an RSS/Atom feed to a Slack instance, as Slack doesn't support the discovery means.

Because I end up doing it a fair bit more than expected, I've written a command-line tool, `feeds`, which allows me to discover all feeds of a given URL, that are marked up with the `rel=alternate` markup.

For instance:

```
go build && ./feeds jvt.me
[
  {
    "feedUrl": "https://www.jvt.me/feed.xml",
    "feedType": "application/rss+xml"
  },
  {
    "feedUrl": "https://www.jvt.me/feed.json",
    "feedType": "application/json"
  },
  ...
]
```

Source code is [available on GitLab](https://gitlab.com/jamietanna/dotfiles-arch/-/tree/main/go/home/go/src/jvt.me/dotfiles/feeds).

This follows redirects, and handles relative URLs in feeds.
