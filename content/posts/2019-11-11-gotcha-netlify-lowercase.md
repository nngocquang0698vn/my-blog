---
title: "Gotcha: Netlify Makes All Your Filenames Case-Insensitive"
description: "Beware if you have a requirement for case-sensitive URLs for Netlify."
tags:
- blogumentation
- nablopomo
- netlify
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-11T19:40:31+0000
slug: "gotcha-netlify-lowercase"
image: /img/vendor/netlify-full-logo-white.png
---
Yesterday, I posted about [_Making Hugo Generate Case Sensitive URLs_]({{< ref "2019-11-10-hugo-case-sensitive-urls" >}}), as a way to [self-document]({{< ref "2017-06-25-blogumentation" >}}) but also because I wanted to updated my own site to render case-sensitive URLs because I noticed this was not actually rendering them as case-sensitive.

I have a number of specifically case-sensitive URLs which are randomly generated, so use mixed cases so I can decrease the chance of filename collisions.

However, I found that unfortunately this is not a thing that works with Netlify (which I use to host my site) because it actually makes all filenames lowercase, removing any case sensitivity you had set up.

This is an [underdocumented gotcha that I found on their community forums](https://community.netlify.com/t/my-url-paths-are-forced-into-lowercase/1659/2). This has meant that unfortunately I've had to change the implementation of my random filename generation to not use uppercase characters.

Please don't fall into the same trap that I did, as there doesn't seem to be an alternative other than "don't have case-sensitive filenames".

From my testing, it appears that if there is a duplicate between a mixed-case filename and a lowercase filename, the filename that has a lowercase path takes priority.
