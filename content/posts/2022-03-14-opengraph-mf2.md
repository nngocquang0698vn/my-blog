---
title: "Introducing `opengraph-mf2` a library, and service `opengraph-mf2.tanna.dev`, for converting OpenGraph metadata to Microformats2"
description: "Announcing an NPM package and a hosted service for converting OpenGraph metadata to a Microformats2 object."
tags:
- opengraph
- opengraph-mf2
- indieweb
- microformats2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-14T19:20:02+0000
slug: opengraph-mf2
image: https://media.jvt.me/fbe44c4ded.png
syndication:
- "https://brid.gy/publish/twitter"
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
I've recently been looking at improving the way that posts on my site are presented on my site, to produce a little more metadata about the interaction I'm having.

This isn't just to improve the context for things like replies, but also for other interactions with posts, like when I'm posting a listen of a podcast, or bookmarking someone's post. Although I currently do this for i.e. [interactions with Twitter](https://www.jvt.me/mf2/2022/03/jzt0q/), I wanted to increase support for other sites so both human and non-human readers of the site get the context they need.

As part of this, I wanted to implement the ability to consume metadata for other sites, and found that [OpenGraph metadata](https://ogp.me/) is a fairly widely used metadata format to be a catch-all for most posts, as well as the more specific means of retrieving metadata that I've currently got.

While starting to look at implementing this for my Micropub server, which is written in Java, I realised that I'd need to write my own HTML-to-OpenGraph metadata parser which was a little bit more work than I'd planned on doing.

Before I started doing it, though, I remembered that this was a [solved problem](https://github.com/barryf/vibrancy/blob/master/src/events/fetch-context/open-graph.js) by <span class="h-card"><a class="u-url" href="https://barryfrost.com">Barry Frost</a></span> with his Micropub server [Vibrancy](https://github.com/barryf/vibrancy/).

Instead of looking to solve this as a single Java-specific problem, I thought about how this is a common issue across the IndieWeb, and most likely further than that. I'm a big fan of producing [Pipe services](https://indieweb.org/pipes) where possible, so started with that as the goal, which I could then consume from my Micropub service.

I proposed [this on Vibrancy](https://github.com/barryf/vibrancy/issues/44), but ended up making a start on it anyway as a means to unblock my own work.

I also noted that this is a useful piece of code that would likely be usable elsewhere, and for instance Vibrancy wouldn't want to consume an external service for this, when it could do it all itself, so I've also wrapped this into [an NPM package, `@jamietanna/opengraph-mf2`](https://www.npmjs.com/package/@jamietanna/opengraph-mf2).

An example of using this can be seen below, using the hosted version at [opengraph-mf2.tanna.dev](https://opengraph-mf2.tanna.dev/):

```json
// curl 'https://opengraph-mf2.tanna.dev/url?url=https%3A%2F%2Fchangelog.com%2Fpodcast%2F482' -H 'Accept: application/mf2+json'
{
  "items": [
    {
      "type": [
        "h-entry"
      ],
      "properties": {
        "featured": [
          "https://cdn.changelog.com/static/images/share/twitter-podcast-0fed02e920a2ff887b9c8ccac88925e1.png"
        ],
        "name": [
          "Securing the open source supply chain with Feross Aboukhadijeh on the launch of Socket (The Changelog #482)"
        ],
        "photo": [
          "https://cdn.changelog.com/static/images/share/twitter-podcast-0fed02e920a2ff887b9c8ccac88925e1.png"
        ],
        "summary": [
          "This week we’re joined by the “mad scientist” himself, Feross Aboukhadijeh…and we’re talking about the launch of Socket — the next big thing in the fight to secure and protect the open source supply chain. While working on the frontlines of open source, Feross and team have witnessed firsthand how supply chain attacks ..."
        ],
        "url": [
          "https://changelog.com/podcast/482"
        ]
      }
    }
  ]
}
```

The source code for the library and the service can be found [on GitLab](https://gitlab.com/jamietanna/opengraph-mf2/), and big thanks for the basis of the code, Barry!
