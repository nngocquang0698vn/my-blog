---
title: "Making Zoom Notifications/Windows Float on BSPWM"
description: "How to get BSPWM to handle Zoom notification windows as floating windows, instead of tiles."
date: 2021-12-02T18:33:54+0000
tags:
- "blogumentation"
- "bspwm"
- "zoom"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/8370d97494.png"
slug: bspwm-zoom-float
---
I use the tiling window manager [BSPWM](https://github.com/baskerville/bspwm) as window manager for my Linux installation, and have done for most of the time I've been running Linux as my daily driver.

Since Zoom became more prevalent for videoconferencing - especially during the pandemic - I've been getting slowly more annoyed by the way that Zoom operates with it, by default.

This occurs, for instance when a participant starts screen sharing, at which point a full-size tile appears, taking the focus from the window I was previously on, and disappearing shortly after.

After almost two years of getting annoyed by this, this afternoon I finally started looking at it, and found [this reddit thread](https://www.reddit.com/r/bspwm/comments/hsqpi4/change_window_state_based_on_the_initial_size_of/) which was looking to solve it.

Unfortunately that wasn't quite what I wanted, but after digging around on GitHub, I've found that [Alex Lushpai's configuration on GitHub](https://github.com/gwinn/deploy/blob/7de5948362e50dad87d41f752affc3c86789a80d/user/.config/bspwm/bspwmrc#L30), which I've amended to be:

```sh
bspc rule -a zoom state=floating center=on follow=on border=off
```

Which when put into my `bspwmrc`, now Zoom windows don't get in the way!
