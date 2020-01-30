---
title: "`meetup-mf2.jvt.me` release 0.2.0: Adding `h-feed` support"
description: "Adding `h-feed` support for my Microformats translation layer for Meetup.com."
tags:
- microformats
- meetup.com
- meetup-mf2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-19T21:21:14+0000
slug: "meetup-mf2-hfeed"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
In August I [announced a Microformats API for Meetup.com: `meetup-mf2.jvt.me`]({{< ref "2019-08-31-microformats-meetup" >}}) to act as a translation layer between the silo and the IndieWeb.

I've been using this as a core part of my own workflow for RSVPing to events, but that's usually when I see the event actually on Meetup.com and then manually RSVP from my website.

To make it so I could discover new events from my [Indie reader](https://indieweb.org/reader), it would be really nice to have an [`h-feed`](https://indieweb.org/h-feed).

With the [v0.2.0 release](https://gitlab.com/jamietanna/meetup-mf2/-/tags/0.2.0) (now in production!) this is now available for usage, which you can do with the following request to get the upcoming events for a given Meetup.com group:

```json
GET https://meetup-mf2.jvt.me/Tech-Nottingham/events
{
    "items": [
        {
            "children": [
                {
                    "type": [
                        "h-event"
                    ],
                    "properties": {
                        "name": [
                            "Tech Nottingham January 2020 - Ethics In Advertising And High Performance Teams"
                        ],
                        "description": [
                            "<p>Full event description: <a href=\"https://www.technottingham.com/events/tech-nottingham-january-2020\" class=\"linkified\">https://www.technottingham.com/events/tech-nottingham-january-2020</a></p>..."
                        ],
                        "start": [
                            "2020-01-13T18:30:00Z"
                        ],
                        "end": [
                            "2020-01-13T21:00:00Z"
                        ],
                        "url": [
                            "https://www.meetup.com/Tech-Nottingham/events/267300253/"
                        ],
                        "location": [
                            {
                                "type": [
                                    "h-adr"
                                ],
                                "properties": {
                                    "locality": [
                                        "Nottingham"
                                    ],
                                    "street-address": [
                                        "Antenna, Beck Street"
                                    ],
                                    "country-name": [
                                        "United Kingdom"
                                    ]
                                }
                            }
                        ],
                        "published": [
                            "2019-12-19T18:14:47Z"
                        ],
                        "updated": [
                            "2019-12-19T18:15:13Z"
                        ]
                    }
                }
            ],
            "type": [
                "h-feed"
            ],
            "properties": {
                "name": [
                    "Tech Nottingham"
                ],
                "url": [
                    "https://www.meetup.com/Tech-Nottingham/events"
                ]
            }
        }
    ]
}
```

Because this exposes an Microformats2 JSON feed, it should be possible to subscribe to a given Meetup.com group.

~~Note: If you're trying to use it with [Aperture](https://aperture.p3k.io), [there's a PR that needs to be merged](https://github.com/aaronpk/XRay/pull/94) before it'll work.~~ This is now works with [Aperture](https://aperture.p3k.io)!

Another thing to note is that this will only show upcoming events for a given group - hopefully that's all you need, but feel free to [use the issue tracker if you want the option](https://gitlab.com/jamietanna/meetup-mf2/issues).
