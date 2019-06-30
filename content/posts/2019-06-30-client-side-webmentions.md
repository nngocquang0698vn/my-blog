---
title: "Rendering Webmentions using Client Side JavaScript"
description: "Replacing my server-side rendered webmentions with client-side rendering."
tags:
- www.jvt.me
- webmention
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-06-30T21:20:07+0100
slug: "client-side-webmentions"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/webmention
  url: https://indieweb.xyz/en/webmention
---
On [March 18 2019]({{< ref 2019-03-18-displaying-webmentions >}}), I started rendering my Webmentions as part of this site's [Hugo](https://gohugo.io) build process.

However, this only is useful if there are regular rebuilds of the site. On some days, I'm pushing new content to the site multiple times a day, each which rebuilds the site. However, I also go many days without updating which means that many webmentions are left un-rendered.

Since then I've been looking at enabling client-side rendering of the webmentions, but because I didn't want to duplicate code between the server-side rendering of Hugo templates and client-side rendering in JavaScript it's always been a bit of a difficult one. (As an aside, I usually follow the [Rule of Three](https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)), but I knew I wanted to break it earlier than waiting for the third time).

In [_IndieWeb Summit 2019, day 1_](https://beesbuzz.biz/blog/3785-IndieWeb-Summit-2019-day-1), fluffy mentioned that they had a client-side script for rendering [Webmentions](https://indieweb.org/webmention). So this afternoon I thought I'd give it a go, and it was super easy and drop-in to get it working.

With this announcement, I'm now using `webmention.js` to render all my webmentions on page load.

Now, I've kinda gone back on functionality because I've decided to _only_ support client-side rendering. So folks who are viewing this site without JavaScript will not be able to see Webmentions. Sorry, but maybe in the future I'll make it better for you, again - this was a difficult decision.
