---
title: "Announcing Meetup.com Support for Bridgy Publish"
description: "Announcing the ability to RSVP to Meetup.com events from your website, using Bridgy."
tags:
- bridgy
- indieweb
- meetup.com
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-17T07:50:41+0000
slug: "meetup-bridgy-support"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: '@JamieTanna on Twitter'
  url: https://brid.gy/publish/twitter
- text: 'Lobste.rs'
  url: https://lobste.rs
- text: 'Hacker News'
  url: https://news.ycombinator.com
image: https://media.jvt.me/lmgf1.png
---
As I was starting to get more involved in the [IndieWeb](https://indieweb.org/why), I started to [own my RSVPs to events I was attending](/kind/rsvps/), most of which are hosted on Meetup.com. This was partly to own the data itself and allow me to do things like [create my own attending calendar]({{< ref 2019-07-27-rsvp-calendar >}}), but also to make it easier for friends, colleagues, and family to see what I was attending.

However, this quest to own my data still had a little problem - I was RSVPing to my website, as well as RSVPing on Meetup.com. I'm not a fan of manual work, so this was a bit painful, so I started to look at creating a simple client for the Meetup.com API that would perform the RSVPs on my behalf.

The API itself seemed fairly straightforward, so I then started looking at how to send the RSVPs automagically after my site deployed. While looking into the process, I found out about [Bridgy](https://brid.gy), which is built to be the bridge between the Silo'd web, such as Twitter or Meetup.com, and the IndieWeb. This seemed like a great place to start, in a way that could benefit everyone on the IndieWeb, so I [raised a feature request for Meetup.com](https://github.com/snarfed/bridgy/issues/873).

For several months, the issue lay silent, until [at IndieWebCamp Amsterdam]({{< ref 2019-10-03-indiewebcamp-amsterdam-2019 >}}#sunday---hack-day), I started the implementation of it on the Sunday hack day. I didn't manage to get much luck with it because I had some trouble reminding myself how Python and its dependency management tooling worked, but I'd started it, and over the coming months I would carry on with my implementation where I had time.

Now, 263 days later of on-and-off work, I'm very happy to announce that Meetup.com is now live on Bridgy! It's taken 14 Pull Requests, and a lot of back-and-forth collaboration with <span class="h-card"><a class="u-url p-name" href="https://snarfed.org">Ryan</a></span>, Bridgy's author, to get this working, and I want to say a huge thank you to him for supporting it! He's mentioned that aside from him, only <span class="h-card"><a class="u-url p-name" href="https://kylewm.com/">Kyle</a></span> has contributed a Silo to Bridgy. I'd love for more folks to get involved and adding more functionality to Bridgy, but I'd also like to see more alternative approaches!

This Bridgy support also leads me to a great IndieWeb win - I can now own the [discovery]({{< ref 2019-12-19-meetup-mf2-hfeed >}}) and attendance portion of attending Meetup.com events completely IndieWeb tooling, as well as publishing notes (that get converted to tweets by Bridgy) while I'm there to share my thoughts with others.

This is personally a huge win for me, and I'm really happy with getting it live.
