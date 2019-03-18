---
title: "Displaying Webmentions on my Hugo website"
description: "How and why I've gone about getting Webmentions rendered on my static Hugo site."
categories:
- announcement
- indieweb
- microformats
tags:
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-18
slug: "displaying-webmentions"
image: /img/vendor/webmention-logo.png
---
As part of my move into the [IndieWeb movement](https://indieweb.org/why), I wanted to increase the social interactions I have across multiple sites. I currently use [social silos](http://indieweb.org/silo) services like Twitter and Slack for a lot of social communication, but I need to have more interactions with the [Social Web](https://indieweb.org/social_web).

To do this, there is a Web standard called [Webmention] which encapsulates social interactions between pages, such as "liking" or "replying" as well as others. It is described in the [IndieWeb wiki article][Webmention] as:

> Webmention is a web standard for mentions and conversations across the web, a powerful building block that is used for a growing federated network of comments, likes, reposts, and other rich interactions across the decentralized social web.

As I'm running [Hugo](https://gohugo.io) on this website, I wanted to stick to something that would work well with a static site generator. I'd wanted to write my own Webmention software myself but, as ever, I was time challenged and wanted to get something up and running quickly.

That's where I found out about [Aaron Parecki's](https://aaronparecki.com/) project [webmention.io](https://webmention.io) which is a hosted Webmention endpoint with a friendly API. I was able to really easily set up my site and add the required markup for making it discoverable for clients.

At the time of enabling discovery, I decided not to tackle the rendering of the Webmentions as I wasn't really sure how many I would get. Soon after, [Josh Hawxwell](https://hawx.me) spoke at [NottsJS with his talk _Indie What?_][indie-what], and mentioned that he used a tool called [Brid.gy](https://brid.gy/) to bridge social silos such as Twitter to the Social Web.

This was again really easy to get started with and started producing regular Webmentions through interactions on Twitter, but it wasn't until my recent post announcing [_Homebrew Website Club: Nottingham_][hwc] that I started to receive Webmentions from outside of the social silos, which was a _really cool_ achievement! And then that made me think, wouldn't it be great if others could start to see these interactions, too?

So as per this article's publishing, you can view webmentions on my posts, if there are any. I'd recommend checking out [_Homebrew Website Club: Nottingham_][hwc] as it has, at time of writing, 34 webmentions.

Note that, for now, I'll only be sharing links to other webmentions, rather than directly embedding them - this is a first pass, and while I look at understanding the best way to deal with spam and untrusted inputs.

I've also added the ability to send a Webmention via an HTML form, in case you don't yet support automagically sending them.

[Webmention]: https://indieweb.org/webmention
[hwc]: {{< ref 2019-03-14-homebrew-website-club-nottingham >}}
[microservices]: {{< ref 2018-12-23-microservices-static-site >}}
[facepile]: https://indieweb.org/facepile
[indie-what]: https://www.meetup.com/NottsJS/events/qhnpfqyzcblb/
