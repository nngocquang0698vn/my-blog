---
title: "Features I Want In My Social Reader"
description: "What sort of functionality do I want in my social reader, so I can follow awesome people's thoughts more easily?"
tags:
- indieweb
- microsub
- feed
- social-media
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-05-01T15:12:31+0100
slug: "social-reader-features"
syndication:
- https://news.indieweb.org/en
---
# What's a Social Reader?

If you've not heard of [social readers](https://indieweb.org/social_reader) before, they're a great improvement over the feed readers, as they combine the consumption of content with the conversational aspect that you see with social media.

What makes it a "social" reader is that we aim to be able to interact with posts from others, through the same reading interface, and have a whole social conversation as if I were replying to someone's post on i.e. Twitter.

# Microsub

In the [IndieWeb](https://indieweb.org/why), we have a few different social readers, which are built on top of the open standard [Microsub](https://microsub.spec.indieweb.org).

The Microsub standard is a really nice evolution from RSS readers of the past, which would generally bundle the discovery of new content with the rendering of the content, as well as any other features, all within the same application.

With Microsub, the idea is that the client and the server are two independent concepts - this allows the user-facing reading experience can be flexible, and allows users to "shop around" for the best experience for them, while still using the same backend server. This also means that the development of a Microsub server doesn't need frontend experience, or as much thought around the usability, because other clients can be used.

At time of writing, there are [5 popular clients](https://indieweb.org/Microsub#Clients) and [7 popular servers](https://indieweb.org/Microsub#Servers), which are all used by various folks, often interchangeably! For instance, I generally use Indigenous for Android, but every so often use Monocle for browsing on a non-mobile device.

## People, Not Feeds

Microsub is currently oriented around following a feed, but there have been some recent thoughts in the Microsub community around whether we should be thinking about it more in terms of people.

This would allow us to say "follow all posts by Jamie" instead of "Follow Jamie's RSS feed", which then breaks if I were to remove my RSS feed, or move it to a new location, or I want to follow a different feed.

# My Current Microsub Usage

Before I dig into what I want out of my social reader, I thought I'd share how I've currently got my feeds set up.

I currently manage things? In [Aperture](https://aperture.p3k.io/), the server I'm currently using, I've got the following channels set up:

- Notifications
  - Notifications received through Webmentions
- Lols/satire
  - Funny / satirical takes on what's happening right now
- jvt.me
  - My own blog, so I can check that things are publishing OK
- IndieWeb Hashtags
  - A few Twitter hashtags, so I can keep an eye on interesting things folks are saying
- MF2 Testing
  - A general-purpose channel I've got for putting arbitrary feeds in, for instance when I want to drastically change the way my site's Microformats2 feed is set up
- Jvt.me firehose
  - My own blog, for all posts aka the ["firehose" feed]({{< ref 2020-05-04-firehose-feed >}})
- Twitter all
  - My full Twitter feed
- Non-indie aggregators
  - A number of aggregators for lots of tech related things
- [IndieWeb stream](https://stream.indieweb.org/)
- Events
  - Tech events I attend, so I can RSVP straight from my reader
- IndieAggregators
  - A few aggregators for IndieWeb/IndieWeb-adjacent folks
- Twitter
  - Close friends on Twitter
- Links
  - Folks who provide a links/bookmarks feed of interesting things
- Blogroll
  - Everyone I'm following blogs for
- Cute
  - Cuteness across a few folks' sites
- Tech Event Hashtags
  - Twitter hashtags for a few of the tech events I attend

I've broken things down kinda well, but my blogroll is a long list of everyone and their feeds. Some of these I've got listed on [/blogroll](/blogroll), but I don't keep it well maintained. They're also a long list of people I would like to keep very up to date with, and some of who I want to read every so often - it's not super broken down.

I've also got a Twitter list of close friends, and then not-as-close friends, of which I try and browse, but generally find the Twitter home feed better (read: more addictive).

# My Ideal Features

Until the standard evolves, I've been thinking about what I could do on top of it to the existing functionality by building tooling that could manage this for me on top of the core Microsub standard.

I've also highlighted a couple of things I want out of it, usability wise.

## Circles

I want to be able to add folks to "circles" (similar to how Google+ used to work), which will allow me to say <span class="h-card"><a class="u-url" href="https://annadodson.co.uk">Anna</a></span> and <span class="h-card"><a class="u-url" href="https://carol.gg">Carol</a></span> are close
friends, and I want to follow their blogs, so I would put them in `Close Friends` and `Blogroll`.

## Platform-aware content

In [_Platform-Aware @-mentioning People on my Blog_]({{< ref 2020-03-22-at-mention-people >}}) I mentioned that I've made it possible to store folks' identity data across platforms in a way that means if a post goes to Twitter I tag the person by their Twitter username instead of their site's URL.

Because I have folks who blog and post content to Twitter, I want to keep up to date with that, and so I'd like to make sure I can follow folks across platforms. In conjunction with Circles, I'd want to have a `Close Friends` for websites and `Close Friends - Twitter` to allow it to break down so I can see their thoughts on the right platform.

This would integrate with my Micropub server to keep up to date with who each person is and what their platform names are, so if I follow someone's blog, then their Twitter gets added to the contacts later, I'd expect relevant list(s) on Twitter to be updated.

This would also be something that would allow me to extend to following posts by someone across platforms, i.e. if they only post certain content to Medium/Dev.to.

## Why am I following them?

As well as following a person, it's good to keep a tab on _why_ - I've seen this talked about a lot on Twitter, and I think it'd be useful for my own personal usage, so I can remember what prompted my following them, on whichever platform.

## Split types of content

I currently have a "links" channel on my reader which allows me to find things that others have [bookmarked](https://indieweb.org/bookmark), and would quite like to split things like bookmarks out from the main feed, as I'd prefer to prioritise folks' own personal thoughts, via their articles, although I do get a lot of benefits from their bookmarks, too.

Similarly, I'd quite like to separate folks' [microposting](https://indieweb.org/note) out, similar to the platform-aware content split.

## Listing my Blogroll

I also want to make it possible for others to see who I'm following - currently I have some folks on my [/blogroll](/blogroll) page, but that's not kept up to date, so it'd be good to have this stay up to date.

I'd also quite like to be able to have a public-facing explanation for why I follow a person / some easily searchable tags that would allow folks looking at my blogroll to find other people they may want to follow.
