---
title: "Adding the microformats h-entry markup to my blog posts"
description: "Announcing the addition of the `h-entry` markup to my blog posts."
categories:
- announcement
- indieweb
- microformats
tags:
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-19
slug: "microformats-hentry"
image: /img/vendor/microformats-logo.png
---
As I spoke about in my post [_Setting up a personal hCard for myself_]({{< ref 2019-03-15-personal-hcard >}}), I'm starting to mark up my site with [microformats2].

As you're reading this, you're now seeing that my blog posts are being marked up with the [`h-entry`](http://microformats.org/wiki/h-entry) format. This gives a parser client the ability to determine the post's name, summary, URL, published + updated times and then the actual content itself.

As with my personal h-card changes, I've added an automated HTML-Proofer `Check` in place to ensure that all my posts are well-formed and have the required parameters, and will catch any regressions in the future if I break / migrate my site's theme.

I've decided to only look at marking up my blog posts, as they're the highest touch point on the site, but as I look to create more types of content, they'll be annotated as such.

Let's hope that leads to more users on the site, who can browse the site with the client they want!

[microformats2]: http://microformats.org/wiki/microformats2
