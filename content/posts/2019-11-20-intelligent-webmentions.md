---
title: "Sending Webmentions More Intelligently"
description: "Updating my post-deployment tooling to only send Webmentions when they've not already been accepted (or rejected)."
tags:
- www.jvt.me
- webmention
- indieweb
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-20T21:30:19+0000
slug: "intelligent-webmentions"
series: nablopomo-2019
image: /img/vendor/webmention-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
In [_Reader Mail: Webmention Spam_]({{< ref "2019-10-30-reader-mail-webmention-spam" >}}) I mentioned that [since I started to send Webmentions post-deployment of this site]({{< ref "2019-09-10-webmentions-on-deploy" >}}) I happened to be spamming everyone multiple times a day with my [Webmentions](https://indieweb.org/Webmention).

I received a few comments from folks about reducing this (or completely stopping it) because some Webmention servers don't de-duplicate sent Webmentions, so a server could see each new Webmention as a new one, and could i.e. send a push notification to the user. Not ideal!

Because my site may update multiple times a day (i.e when I'm pushing new content to it) it means those duplicate Webmentions would be happening many times a day.

It's been _less_ of a priority for me personally because it doesn't impact me much - which is a bad way to look at it, and really isn't fair on others, so for that I apologise.

After a couple of weeks of on-and-off work on it, I've managed to [get it working yesterday](/mf2/2019/11/y2mng/), but today it's now production-ready.

It now will attempt to send a Webmention, and as soon as that Webmention has been successful, it will make a note of it. On the next time it looks to send Webmentions, it will not re-send the Webmention if it's already been sent. I'll be updating it [in the future](https://gitlab.com/jamietanna/www-api/issues/71) to resend only if I've changed the Microformats2 markup (via <span class="h-card"><a class="u-url" href="https://martymcgui.re/">Marty McGuire</a></span>).

A point of note is that it will not retry if the Webmention is rejected, either, because it's likely the remote server not wanting to accept the request.

This article being pushed live should be the last time you get inundated by Webmention spam from me!
