---
title: "Adding RSVP Support for Indie Events"
description: "Adding RSVP support to my Micropub endpoint for Indie events."
tags:
- micropub
- www.jvt.me
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-12T23:21:42+0100
slug: "rsvp-indie-events"
image: /img/vendor/micropub-rocks-icon.png
---
Although I recently added [Micropub support to www.jvt.me]({{< ref "2019-08-26-setting-up-micropub" >}}), I realised a couple of days ago that I didn't actually support RSVPing to Indie Events!

When I first set this up, I only supported Meetup.com, through integration with [meetup-mf2]({{< ref "2019-08-31-microformats-meetup" >}}), but with this post I'm now able to RSVP to all the other events I want to!

I decided to outsource my parsing of these events to [php.microformats.io](https://php.microformats.io) so I didn't have to write my own Microformats parser.

This allows me to RSVP to events on Meetup.com, as before, but also use a variety of other sites which have supported Microformats2 content.
