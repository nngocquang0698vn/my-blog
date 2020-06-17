---
title: "Changing my Static Site Search Setup"
description: "Making changes to fix my search setup, and reduce download overhead for visitors."
tags:
- search
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-17T19:49:37+0100
slug: "changing-search-setup"
---
In [_Re-enabling search on my static website_]({{< ref 2019-05-01-reenable-static-search >}}), I mentioned that I was re-enabling search on my static website.

One of the things I decided at the time was to take advantage of my JSON Feed, to remove the need to store a separate representation of all my posts.

Something I was worried about at the time was that it was downloading a fairly large JSON file each time, so I used the [Web Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API) in the browser to cache the JSON file.

A few weeks ago, I found that search was broken on my site, as I'd gone over the size limit for the Web Storage API, and it finally got to the point that I needed to resolve this.

I've just updated it to no longer do this, and also to massively reduce the download size - from 14M it's now 200K - I hope to improve this further in the future, though!
