---
title: "Blocking Twitter Widgets from This Site"
description: "Enforcing a privacy-aware removal of Twitter's JavaScript widget from this site."
tags:
- nablopomo
- privacy
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-26T07:58:39+0000
slug: "remove-twitter-widget"
series: nablopomo-2019
---
For quite some time, I've made an active effort to strip [Twitter's third-party JavaScript for tweet embedding](https://help.twitter.com/en/using-twitter/how-to-embed-a-tweet) when embedding a tweet into any of my posts.

I'm not particularly a fan of allowing Twitter to gain more information about folks' browsing habits and _don't really fancy_ their ability to run arbitrary JavaScript on my site. It also doesn't really provide that much extra benefit to a user, from my point of view, so I'm happy leaving it as just a `<blockquote>`.

However, <span class="h-card"><a class="u-url" href="https://annadodson.co.uk">Anna</a></span> and <span class="h-card"><a class="u-url" href="https://carolgilabert.me/">Carol</a></span> noticed that on [_Reader Mail: What Static Site Generator Would I Recommend?_]({{< ref "2019-11-13-reader-mail-what-static-site-generator" >}}) there were some issues with rendering the page, but I couldn't see it with my Firefox install.

It turns out that it was due to my various privacy-aware extensions that remove things like Twitter's widgets, so I never saw the issue on my own machines, but I had actually missed a couple of instances of the widgets on that post and one from a few years ago - woops!

I've since removed them, and to help prevent this issue in the future, I've decided to finally implement a check within my pipeline to enforce this using [HTML-Proofer](https://github.com/gjtorikian/html-proofer) to ensure that I can flag up cases where I've accidentally added them and block the build if I push any posts that include the Twitter sharing widget, ensuring I can't push anything to production that includes these scripts!
