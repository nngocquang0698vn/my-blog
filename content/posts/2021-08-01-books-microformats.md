---
title: "Introducing a Microformats API for Books: `books-mf2.herokuapp.com`"
description: "Announcing the Microformats translation layer for book data."
tags:
- microformats
- micropub
- reading
- books-mf2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-08-01T13:42:17+0100
slug: "books-microformats"
image: /img/vendor/microformats-logo.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
Although I've not read too much lately, I do enjoy reading. As with many things, I like to publish the things I'm reading [to my website](/kind/reads/), using the [Micropub standard](https://micropub.spec.indieweb.org/).

To do this, I usually use [IndieBookClub](https://indiebookclub.biz/), which requires providing all the metadata for myself. I've been wondering for some time about building a nicer UI for this, likely into IndieBookClub, but also potnetially as its own service, even if I only use it.

As part of my move from my personal Micropub server to using <span class="h-card"><a class="u-url" href="https://barryfrost.com">Barry Frost</a></span>'s new server [Vibrancy](https://github.com/barryf/vibrancy/), I've been looking at making sure that I can implement reading functionality through that, too.

Because of the way Vibrancy provides a nice way to retrieve the [reply-context](https://indieweb.org/reply-context) for an arbitrary URL, I wanted the abiliy to provide the `read-of` in the Micropub request as the book's metadata, but there still isn't a readily available API for this.

Fortunately, the [Open Library](https://openlibrary.org) provides a really handy API that we can hook into, so I've now built something to [scratch my itch](https://indieweb.org/scratch_your_own_itch).

# Demo

Let's assume that we're excited to read the final book in The Expanse series, [_Leviathan Falls_](https://openlibrary.org/works/OL24243370W/Leviathan_Falls).

We can take the ISBN 10 or ISBN 13, and put it into the API:

```json
GET https://books-mf2.herokuapp.com/isbn/9780316332910
{
  "items": [
    {
      "type": [
        "h-book"
      ],
      "properties": {
        "url": [
          "https://openlibrary.org/books/OL32667399M"
        ],
        "uid": [
          "isbn:9780316332910"
        ]
      },
      "name": [
        "Leviathan Falls"
      ],
      "author": [
        {
          "type": [
            "h-card"
          ],
          "properties": {
            "name": [
              "James S. A. Corey"
            ],
            "url": [
              "http://www.danielabraham.com/james-s-a-corey/"
            ]
          },
          "photo": {
            "value": "https://covers.openlibrary.org/b/id/11112303.jpg",
            "alt": "Picture of James S. A. Corey"
          }
        }
      ],
      "photo": {
        "value": "https://covers.openlibrary.org/b/id/11295220.jpg",
        "alt": "Cover picture of Leviathan Falls"
      }
    }
  ]
}
```

Notice that this includes rich author information, and a cover photo for nicer previews.

# Source Code

If you're interested in looking at the code for this, or adding feature requests, check out [<i class="fa fa-gitlab"></i>&nbsp;jamietanna/books-mf2](https://gitlab.com/jamietanna/books-mf2).
