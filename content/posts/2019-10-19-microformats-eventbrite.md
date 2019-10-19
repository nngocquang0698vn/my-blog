---
title: "Introducing a Microformats API for Eventbrite: `eventbrite-mf2.jvt.me`"
description: "Announcing the Microformats translation layer for Eventbrite.com/Eventbrite.co.uk events."
tags:
- www.jvt.me
- microformats
- micropub
- eventbrite
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-19T22:54:06+0100
slug: "microformats-eventbrite"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
---
Note: This post is very similar to [Introducing a Microformats API for Meetup.com: `meetup-mf2.jvt.me`]({{< ref "2019-08-31-microformats-meetup" >}}), so I'd recommend a read of that post for some more of the context of why I'm doing this.

I'm happy to announce that `eventbrite-mf2.jvt.me` is now live and provides a Eventbrite translation layer for [Microformats](https://indieweb.org/Microformats). This makes it possible to integrate with your favourite Microformats parser and get programmatic access to a event's metadata.

This was partly due to the [recent community concerns about Meetup.com charging organisers for each RSVP to an event](https://www.theregister.co.uk/2019/10/15/meetup_fee_increase/), but I've also been thinking that I need to extend my Micropub support for different events, and as Eventbrite does not provide Microformats2 data for their events, I'd have to do it myself.

As with my meetup-mf2 project, this was a pretty straightforward piece of work that I was able to get out pretty quickly as it was a single endpoint to create, and in the future will be enhanced for better integrations.

# Caveats

However, there are a couple of caveats with using it, beware!

I've not yet worked on handling / avoiding rate limiting, nor anything around caching data so I'm not hammering the API.

It's still a little rough around the edges, and is still v0.1, but I hope to improve it over time. I'll likely convert it to an AWS Lambda so I can avoid having it running on some infrastructure, and I'm sure that others may look at taking this for their own usages, too.

# Demo

That's enough talking about it, we should probably see how it works. If you were to want to get information about the upcoming [DDD: East Midlands conference](https://www.dddeastmidlands.com/), you would perform the following request, by pulling the event ID out of the last part of the URL `https://www.eventbrite.co.uk/e/ddd-east-midlands-tickets-58629047058`:

(Note that the below is a truncated set of data returned by the API, as this is all we need to render our h-event)

```json
GET https://www.eventbriteapi.com/v3/events/58629047058/
{
    "name": {
        "text": "DDD East Midlands",
    },
    "url": "https://www.eventbrite.co.uk/e/ddd-east-midlands-tickets-58629047058",
    "start": {
        "utc": "2019-10-26T07:30:00Z"
    },
    "end": {
        "utc": "2019-10-26T17:00:00Z"
    },
    "summary": "Get your ticket for the very first DDD East Midlands Conference!",
    "venue_id": "30760401",
    "resource_uri": "https://www.eventbriteapi.com/v3/events/58629047058/"
}
```

Notice that this `venue_id` needs a separate API request, which I won't display here.

To make the API easy to use, we can rewrite the host of the Eventbrite URL, and add my host instead (noting that the path in the URL remains the same), we get a handy [h-event](http://microformats.org/wiki/h-event):

```	json
GET https://eventbrite-mf2.jvt.me/e/ddd-east-midlands-tickets-58629047058
{
    "items": [
        {
            "type": [
                "h-event"
            ],
            "properties": {
                "name": [
                    "DDD East Midlands"
                ],
                "description": [
                    "Get your ticket for the very first DDD East Midlands Conference!"
                ],
                "start": [
                    "2019-10-26T07:30:00Z"
                ],
                "end": [
                    "2019-10-26T17:00:00Z"
                ],
                "url": [
                    "https://www.eventbrite.co.uk/e/ddd-east-midlands-tickets-58629047058"
                ],
                "location": [
                    {
                        "type": [
                            "h-adr"
                        ],
                        "properties": {
                            "name": [
                                "Nottingham Conference Centre"
                            ],
                            "locality": [
                                "Nottingham"
                            ],
                            "street-address": [
                                "30 Burton Street, null"
                            ],
                            "postal-code": [
                                "NG1 4BU"
                            ]
                        }
                    }
                ]
            }
        }
    ]
}
```

# Source Code

If you're interested in looking at the code for this, check out [<i class="fa fa-gitlab"></i>&nbsp;jamietanna/eventbrite-mf2](https://gitlab.com/jamietanna/eventbrite-mf2).
