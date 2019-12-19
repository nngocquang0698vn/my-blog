---
title: "Introducing a Microformats API for Meetup.com: `meetup-mf2.jvt.me`"
description: "Announcing the Microformats translation layer for Meetup.com events."
tags:
- www.jvt.me
- microformats
- micropub
- meetup.com
- meetup-mf2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-31T13:12:58+01:00
slug: "microformats-meetup"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
I'm very happy to announce that `meetup-mf2.jvt.me` is now live and provides a Meetup.com translation layer for [Microformats](https://indieweb.org/Microformats). This makes it possible to integrate with your favourite Microformats parser and get programmatic access to a meetup's metadata.

Having Microformats available is incredibly useful because it is a standardised format that makes it possible to use a wide range of clients to understand what i.e. a Meetup event is without having to either use the Meetup API or understand how Meetup's specific HTML works to render their events, and then parse out the data we need.

Unfortunately there's no support in Meetup.com itself to render Microformats, which is why I've had to create a wrapper. But it'd be great to see the upstream produce this data themselves, instead of folks having to set it up themselves!

It turns out that actually this was a fairly small piece of work to perform a quick transformation of data, as we'll see below, but it doesn't yet seem to have been done, so I thought I'd do it.

This has been on my list for a while, largely as an interesting side project to work on, but it's been recently borne out of necessity.

# My Personal Usage

I've got into a really good place with starting to [own my RSVPs on my website](/kind/rsvps/), and even [create an iCalendar feed for RSVPs]({{< ref "2019-07-27-rsvp-calendar" >}}) which means I can easily integrate my RSVPs into my personal/work calendar, as well as let others follow along with what I'm upto.

To make this work, I store some extra metadata in the RSVP about the event, where it is, and the time it starts and ends at. This is a manual process I go through when creating the data for the RSVP, which has been a pain up until now.

However when I got to [writing my Micropub server]({{< ref "2019-08-26-setting-up-micropub" >}}), I knew that I couldn't populate this data myself, as there was no way to provide all of this very specific data to the Micropub request, without writing my own client - and the whole point of using Micropub was the [many clients available](https://indieweb.org/Micropub/Clients). I wanted to have the generation of this event metadata automated, but in the interest of time, I decided not to support RSVPs for now, and at least support the other types of content.

With this API now live, I was able to integrate it with my Micropub server, so it would fetch the data dynamically and integrate it with the RSVP. I've proved this works with a couple of RSVPs just now, so I'm happy to say it's working well!

# Caveats

However, there are a couple of caveats with using it, beware!

I've not yet worked on handling / avoiding rate limiting, nor anything around caching data so I'm not hammering the API.

It's still a little rough around the edges, and is still v0.1, but I hope to improve it over time. I'll likely convert it to an AWS Lambda so I can avoid having it running on some infrastructure, and I know <span class="h-card"><a class="u-url" href="https://aaronparecki.com/">Aaron Parecki</a></span> [was interested in adding it to XRay](https://chat.indieweb.org/dev/2019-08-30/1567184835706900), as well as hopefully some other implementations available elsewhere.

~~As [Ryan Barrett noticed](https://snarfed.org/2019-08-31_introducing-a-microformats-api-for-meetup-com-meetup-mf2-jvt-me) the API only responds to requests on certain routes following the meetup's URL, as I've not yet created i.e. a landing page.~~

**Update 2019-09-14**: The landing page for the meetup itself is this blog post - so if you're trying to hit `meetup-mf2.jvt.me` and keep coming back here, that's why!

# Demo

Let's say that we want to get information about the event `https://www.meetup.com/PHPMiNDS-in-Nottingham/events/264008439/`. If we were to hit [the Meetup.com v3 events listing API](https://www.meetup.com/meetup_api/docs/:urlname/events/#list) and retrieve information about this event I would receive the following JSON response:

(Note that the below is a truncated set of data returned by the API, as this is all we need to render our h-event)

```json
GET https://api.meetup.com/PHPMiNDS-in-Nottingham/events/264008439/
{
   "duration": 7200000,
   "name": "September Double Whammy - Noobs on Ubs and the IndieWeb *ONE WEEK EARLIER*",
   "time": 1567706400000,
   "utc_offset": 3600000,
   "venue": {
      "name": "JH",
      "address_1": " 34a Stoney Street, Nottingham, NG1 1NB.",
      "city": "Nottingham",
      "localized_country_name": "United Kingdom"
   },
   "link": "https://www.meetup.com/PHPMiNDS-in-Nottingham/events/264008439/"
}
```

But if we rewrite the host and hit my API instead (noting that the path in the URL remains the same), we get a handy [h-event](http://microformats.org/wiki/h-event):

```json
GET https://meetup-mf2.jvt.me/PHPMiNDS-in-Nottingham/events/264008439/
{
    "items": [
        {
            "type": [
                "h-event"
            ],
            "properties": {
                "name": [
                    "\u26a1\ufe0fLightning Talks!\u26a1\ufe0f"
                ],
                "description": [
                    "... truncated for brevity ..."
                ],
                "start": [
                    "2019-09-10T18:00:00+01:00"
                ],
                "end": [
                    "2019-09-10T21:00:00+01:00"
                ],
                "url": [
                    "https://www.meetup.com/NottsJS/events/mcrkhryzmbnb/"
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
                                "Capital One (Europe) plc, Station St"
                            ],
                            "country-name": [
                                "United Kingdom"
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

If you're interested in looking at the code for this, check out [<i class="fa fa-gitlab"></i>&nbsp;jamietanna/meetup-mf2](https://gitlab.com/jamietanna/meetup-mf2).
