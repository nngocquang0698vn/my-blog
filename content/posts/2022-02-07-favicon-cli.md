---
title: "Generating Favicons using ImageMagick on the Command-Line"
description: "How to generate a multi-size `favicon.ico` on the command-line using ImageMagick."
tags:
- blogumentation
- command-line
- imagemagick
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-07T21:52:59+0000
slug: favicon-cli
syndication:
- "https://brid.gy/publish/twitter"
---
Last week I took a new profile photo, and as such I needed to update my favicon so it would match the new look.

As it's something I very infrequently do, I would usually reach for an online tool to do this, but I wanted to see if I could use the ever handy ImageMagick to do this for me, especially as [it's good to not rely on online tools](/posts/2020/09/01/against-online-tooling/).

Following [this (slightly rude) reply](https://gist.github.com/pfig/1808188?permalink_comment_id=938494), we can see that we can run the following command to produce a `.ico` file, with all the relevant sizes, in a single file:

```sh
convert profile.png -bordercolor white -border 0 \
      \( -clone 0 -resize 16x16 \) \
      \( -clone 0 -resize 32x32 \) \
      \( -clone 0 -resize 48x48 \) \
      \( -clone 0 -resize 64x64 \) \
      -delete 0 -alpha off -colors 256 favicon.ico
```
