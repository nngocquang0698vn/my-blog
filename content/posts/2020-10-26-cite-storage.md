---
title: "Changing the Storage of Cites on my Site"
description: "Changing how I store and render context for other posts."
tags:
- www.jvt.me
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-26T22:07:30+0000
slug: "cite-storage"
---
For a while now, I've wanted to tweak the way that my site stores contextual information about posts that it interacts with, [such as Twitter interactions](/mf2/2020/10/on8wi/).

For RSVPs, I stored the cite data in an `event` property, which didn't make sense because it wasn't a real property, and also because it should've been an `h-cite`. For Twitter interactions, I had a `context` object in the Hugo post that was the full MF2 representation from Granary.

One concern I had with this was how to store it - I wasn't particularly looking forward to i.e. have the `in-reply-to` contain either an array of URLs, as usual, or an `h-cite`. This would make it particularly difficult, as both my server and theme would need to understand both, which adds a tonne of complexity.

I was having a look through <span class="h-card"><a class="u-url" href="https://barryfrost.net">Barry Frost</a></span>'s GitHub after noticing some interesting new developments on [Micropublish](https://micropublish.net) and found [Barry's `content` repo](https://github.com/barryf/content) which stores all the data from his site.

I thought this was a great idea, especially [the use of the folder structure](https://github.com/barryf/content/blob/master/cite/https/www/jvt/me/mf2/2019/11/0btzj.json) to mirror the posts' own URL structure, as well as increasing visibility of how many interactions different domains had.

I've now implemented this on my site, using a similar structure, replacing any "unsafe" characters in the regex `[^a-zA-Z0-9-]` with `_` to give me file-system safe paths, and to not nest directories due to Hugo not liking that structure.

This is really exciting as I'll be extending it to provide more context for all my posts, such as who authored it, and if possible the summary of the post as noted by the site.
