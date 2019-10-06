---
title: "Diagnosing my Slow Netlify Deploy Times"
description: "How I managed to shave off 7 minutes of my deploy time, (in true clickbait fashion) just by removing one line of code."
tags:
- www.jvt.me
- netlify
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-06T23:24:40+0100
slug: "netlify-slow-deploy"
image: /img/vendor/netlify-full-logo-white.png
---
For some time, my site has been getting slower and slower to deploy. It's definitely become more apparent now I'm publishing more content via my Micropub endpoint, as well as storing more content in the site itself.

For context, Netlify deployments currently take ~7-10 minutes, and recently have been incredibly flaky with probably 70% of them failing to deploy and needing to be restarted.

Tonight I had a chance to look into it, wondering if it was an issue with the version of the Netlify command-line I'm using.

After some further investigation, I found that the [`netlify`](https://github.com/netlify/cli) was performing exactly the same upload as [`netlifyctl`](https://github.com/netlify/netlifyctl).

As I thought I'd ruled out the build tooling, I decided to look at difference between my live site and my local site.

What I found next was very interesting:

```diff
-  &copy; <time datetime="2019-10-06 23:06:16.213737433 &#43;0100 BST m=&#43;0.974757224">2019</time> Jamie Tanna.
+  &copy; <time datetime="2019-10-06 22:22:16.213737433 &#43;0100 BST m=&#43;0.974757224">2019</time> Jamie Tanna.
```

Notice that the `<time>` element has a full datetime of the current instant, but to the user we just want to show the copyright year. This level of precision isn't required as all I want to be showing is the year, as there are various other metrics for finding out the year of the copyright for a given piece of content on my site.

Because this line is different, every file including this line is going to be different to the copy in Netlify's CDN, so Netlify rightly says, "upload this!".

With this line removed, I've now cut the deploy time to ~2 minutes, and instead of uploading ~2200 files, it's now only updating 137! That's a huge saving, and all I needed to do was think more carefully around what needs to change in a file and what doesn't - who knew!
