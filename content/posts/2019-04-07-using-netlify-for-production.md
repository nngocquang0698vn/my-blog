---
title: "Using Netlify for hosting www.jvt.me in Production"
description: "Announcing my move to Netlify for hosting www.jvt.me."
categories:
- announcement
tags:
- announcement
- netlify
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-07T16:10:01+01:00
slug: "using-netlify-for-production"
---
For the past couple of years, I've been hosting this site on my own infrastructure, but with this post I'm now hosting the production site for this static website on [Netlify](https://netlify.com).

First I'd been using [Scaleway](https://scaleway.com) running Nginx, then migrated to [Hetzner Cloud](https://hetzner.cloud) running Caddy, but as part of my talk [_Overengineering Your Personal Website - How I Learn Things Best_](/talks/overengineering-your-personal-website/), I noted that I wanted to reduce the complexity in my life and around my site.

The key issue for me is the need to maintain the running infrastructure, and ensure that it's always up. I'm seeing a lot more production traffic, and am starting to see others rely on the site more heavily, as well as the fact that I'm starting to use it for more of my services (through the [IndieWeb](https://indieweb.org), I don't want to risk any downtime and impact to my services.

However, I've only migrated my production site and not my non-production sites like branches which get deployed to i.e. `http://example-review-apps.www.review.jvt.me/`. This is twofold - my site has a full build-test-deploy pipeline which I'm unable to reproduce with Netlify's own pipeline offering, so I can't migrate that in entirety. And because I can't use their offering, I can't use Netlify's branch deploy functionality as their CLI doesn't support it.

I'd love to be able to move all my deployments away from my own infrastructure as it'll help save a little money and time and effort to maintain it!
