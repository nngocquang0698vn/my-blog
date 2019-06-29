---
title: "Re-enabling search on my static website"
description: "Announcing the re-enabling of search functionality on my static website."
tags:
- announcement
- indieweb
- search
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-01T20:15:20+0100
slug: "reenable-static-search"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
When I migrated this website from [Jekyll to Hugo]({{< ref 2019-01-04-goodbye-jekyll-hello-hugo >}}), I decided to not migrate my search functionality. This was partly because it was too much work to think about at the time, but also as I wasn't really sure whether anyone was using it.

My workaround for this was the fact that the `/posts/` page would always list all of my posts, so I'd be able to hit that page and use the browser's search to find it.

Well, that was all well and good until early March when I enabled pagination in my site, which meant that `/posts/` would be limited to 10 posts per page, meaning my &gt; 100 posts were now harder to search. Instead, I either needed to remember the taxonomy I'd used (which I'm generally pretty good with) or would have to trawl through the paginated posts.

This got until the other day where I decided enough was enough, and decided to properly solve it - which is what I'm announcing now, and was implemented at [tonight's Homebrew Website Club in Nottingham](/events/homebrew-website-club-nottingham/2019/05/01/).

I hooked this in by using my [JSON Feed](https://indieweb.org/jsonfeed) which [I implemented at the beginning of April]({{< ref 2019-04-07-jsonfeed >}}), and is a great format for searching on. This means I don't need to create a separate format just for the sake of search, too, which was a big plus point for me!

Give it a go on [`/search/`](/search/) and let me know what you think!

Interestingly, as per the [Indieweb levels for search](https://indieweb.org/search#How) I _may_ qualify for Level 5, because it's all done client-side. Which is pretty lucky because this site is super static and I don't want to be relying on 3rd party services to host search.
