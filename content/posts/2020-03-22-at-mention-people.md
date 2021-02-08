---
title: "Platform-Aware @-mentioning People on my Blog"
description: "More easily mentioning others on my posts, and improving my interactions with Twitter syndication."
tags:
- www.jvt.me
- twitter
- indieweb
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-22T17:00:09+0000
slug: "at-mention-people"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
Since I started to publish [short notes](/kind/notes/) to my site, I've been trying to make them more social, such as mentioning others in my content.

Although I want to publish to my website, I don't want to _just_ post to my own site, but also share these for folks following me on Twitter, so I configured automagic syndication of these notes to Twitter as tweets using [Bridgy](https://brid.gy/).

This led to a bit of a dilemma when mentioning others. These notes were being syndicated with a mention of i.e. <span class="h-card"><a class="u-url p-name" href="https://annadodson.co.uk/">Anna</a></span> with her site's URL, which looked a bit weirder to folks on Twitter, and also didn't send her a notification on Twitter:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Happy birthday to me! A lovely start to the morning opening cards with a champagne flute of Tango, with the wonderful <a href="https://annadodson.co.uk">https://annadodson.co.uk</a> and <a href="https://twitter.com/hashtag/Morph?src=hash&amp;ref_src=twsrc%5Etfw">#Morph</a><br><br>If you visit my site today you&#39;ll notice birthday balloons that I copied from Aaron Parecki this… <a href="https://t.co/qTyMhACXox">https://t.co/qTyMhACXox</a> <a href="https://t.co/W1Atm1WF2N">pic.twitter.com/W1Atm1WF2N</a></p>&mdash; Jamie Tanna | www.jvt.me (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1239827385001938944?ref_src=twsrc%5Etfw">March 17, 2020</a></blockquote>

But if I set the URL directly as her Twitter URL, then I wasn't being the best IndieWeb citizen, as I was giving in to the silo'd web.

The solution for this was to have some awareness of where the content was being published to, and then publish the correct URL for that service, if possible.

I decided that I didn't want this to happen when I first created the content (via [my Micropub server]({{< ref 2019-08-26-setting-up-micropub >}}) but when the site renders itself, as then it's more up-to-date.

Following some of <span class="h-card"><a class="u-url p-name" href="https://seblog.nl">Seb</a></span>'s [points on his own implementation of it](https://seblog.nl/2017/06/14/6/at-mentioning-people), I've now set it up for my own site.

I can now @-mention folks by using their profile URL, such as `@annadodson.co.uk`. If they have a Twitter URL configured for their site, it'll provide a Twitter URL on syndication. For folks that don't have a Twitter URL configured, it'll just syndicate their URL. If I want to simply @-mention a Twitter URL, I've already got functionality in my Micropub server that will rewrite a Twitter URL to an h-card with their name.

You can see an example at [/mf2/2020/03/g1mpf/](/mf2/2020/03/g1mpf/).

Update 2020-07-06: I noticed that the original Microformats2 for this wasn't quite working, as it wouldn't handle interacting with quote tweets. This is now addressed, but is a word of warning to anyone doing this! The straightforward fix [can be found on the GitLab Merge Request that fixed it](https://gitlab.com/jamietanna/www.jvt.me-theme/-/merge_requests/3).
