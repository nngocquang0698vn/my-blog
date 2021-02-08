---
title: "Providing Hints for Autoconfiguring Micropub Clients"
description: "Enhancing my Micropub Server and autoconfiguring Micropub client with the support for `hints`."
tags:
- www.jvt.me
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-19T21:20:06+0100
slug: "micropub-client-autoconfigure-hints"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
So far I'm enjoying using my [autoconfiguring Micropub client]({{< ref 2020-10-15-micropub-client-autoconfigure >}}), but as mentioned in the announce post, I knew there was a glaring usability issue (aside from the poor design of the UI!). I knew I wanted to make it so the editor can understand what type of input to use for a property.

This means I can take the original event editor page, which was just a row of plain text inputs:

![A screenshot of the fields possible to be used with an event, which contains a number of plain text input elements](https://media.jvt.me/c315776b6c.png)

And replace it with the below, which provides a much nicer experience, with browser validation for URLs, date + time pickers (as I couldn't find an all-in-one datetime picker) and a `<textarea>` for content boxes:

![A screenshot of the fields possible to be used with an event, which shows the browser validating the url field, date and time pickers, and a textarea for the content property](https://media.jvt.me/c757c86214.png)

This is possible using a set of Micropub metadata [I've proposed](https://github.com/indieweb/micropub-extensions/issues/8#issuecomment-711365962) and am using when sending the  `q=properties` query:

```json
{
    "properties": [
        {
            "name": "name",
            "hints": [],
            "display-name": "Title"
        },
        {
            "name": "nickname",
            "hints": [],
            "display-name": "Nickname"
        },
        {
            "name": "photo",
            "hints": [
                "url"
            ],
            "display-name": "Photo"
        },
        {
            "name": "published",
            "hints": [
                "date"
            ],
            "display-name": "Date Published"
        },
        {
            "name": "category",
            "hints": [
                "multivalue"
            ],
            "display-name": "Category / tag"
        },
        {
            "name": "rsvp",
            "hints": [],
            "options": [
                "yes",
                "no",
                "maybe",
                "interested"
            ],
            "default": "yes",
            "display-name": "RSVP"
        },
        {
            "name": "content",
            "hints": [
                "multiline"
            ],
            "display-name": "content"
        },
        {
            "name": "syndication",
            "hints": [
                "multivalue",
                "url"
            ],
            "display-name": "Syndication URL"
        },
        {
            "name": "summary",
            "hints": [],
            "display-name": "Summary"
        },
        {
            "name": "end",
            "hints": [
                "date"
            ],
            "display-name": "End Date"
        },
        {
            "name": "start",
            "hints": [
                "date"
            ],
            "display-name": "Start Date"
        },
        {
            "name": "num",
            "hints": [],
            "display-name": "Number"
        },
        {
            "name": "unit",
            "hints": [],
            "display-name": "Unit"
        },
        {
            "name": "url",
            "hints": [
                "url"
            ],
            "display-name": "Url"
        },
        {
            "name": "rel=twitter",
            "hints": [],
            "display-name": "Twitter username"
        },
        {
            "name": "repost-of",
            "hints": [
                "url"
            ],
            "display-name": "URL to be Reposted"
        },
        {
            "name": "like-of",
            "hints": [
                "url"
            ],
            "display-name": "URL to Like"
        },
        {
            "name": "in-reply-to",
            "hints": [
                "url"
            ],
            "display-name": "URL to Reply To"
        },
        {
            "name": "bookmark-of",
            "hints": [
                "url"
            ],
            "display-name": "URL to Bookmark"
        },
        {
            "name": "read-status",
            "hints": [],
            "options": [
                "to-read",
                "reading",
                "finished"
            ],
            "default": "finished",
            "display-name": "Reading Status"
        },
        {
            "name": "read-of",
            "hints": [
                "url"
            ],
            "display-name": "URL to Mark Reading Status Of"
        }
    ]
}
```

The `hints` allow for making it clear to a consumer how to style the input, i.e. should it be multi-line input, should we have some way of specifying multiple items, etc.

I've also followed the idea of `options` and `default`, which means any items i.e `rsvp` are provided as a selection :

![A screenshot of an RSVP being created, which has radio buttons to allow for one choice for yes/no/maybe/interested](https://media.jvt.me/ec80d95d37.png)

We can also present a friendly name for the user using the `display-name`, instead of using the Microformats2 property name.

I'm looking forward to finding out other options for these `hints`, and am considering whether there should be a way of providing a way of a client being able to discover where they can query to find possible `options`, i.e. `q=category`.
