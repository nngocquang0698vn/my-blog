---
title: "Converting Webmentions to Push Notifications"
description: "Automagically sending push notifications to my mobile phone when I receive a Webmention."
tags:
- www.jvt.me
- webmention
- indieweb
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-01-12T18:21:43+0000
slug: "webmention-notifications"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: Brid.gy Twitter Syndication
  url: https://brid.gy/publish/twitter
image: /img/vendor/webmention-logo.png
---
Since I set up Webmentions in January 2018 using [Webmention.io](https://webmention.io), I've been starting to receive more interactions with my site across the social web.

However, up until today, the only way I'd be able to see what Webmentions I'd received was to go and actively check. I'd, many times a day, open [Indigenous for Android](https://indigenous.realize.be/), the [Indie reader](https://indieweb.org/reader) I use, and refresh it to look at what's in my notifications.

This isn't quite as interactive as you'd want, especially as these could be used for near-realtime communication across websites. While thinking about it, I started looking through the documentation for Webmention.io, but found no mention of it. Failing that, I logged into the dashboard and saw a "Web Hooks" button, which was exactly what I wanted!

This Webhook hits the newly created `https://www-api.jvt.me/notifications/webmention` endpoint with a shared secret (to prevent spam) and then sends a push notification via [PushBullet](https://pushbullet.com/), which I currently use to notify me when my site has deployed.

You can see the code changes required on the [Merge Request on GitLab.com: _Add webhook for mapping Webmention.io to push notifications_](https://gitlab.com/jamietanna/www-api/merge_requests/70).
