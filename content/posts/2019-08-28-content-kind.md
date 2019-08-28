---
title: "Making it easier to determine the `kind` of content for Indie posts"
description: "Adding a `kind` hint to my Indie post types to make it easier to look through each content kind."
tags:
- www.jvt.me
- indieweb
- microformats
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-28T21:09:48+01:00
slug: "content-kind"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
As part of <a href="{{< ref "2019-08-18-restructure-content-types" >}}" class="u-in-reply-to">_Restructuring The Way That My Site's Content Types Work_</a>, I spoke about how I was changing the way that my site's content worked within Hugo, because it made [writing my Micropub server easier]({{< ref "2019-08-26-setting-up-micropub" >}}).

This move was to merge directories such as `/bookmarks/`, `/likes/` and `/replies/` into one, which would make my work a little easier in the Micropub server, so it didn't need to spend as much time working out what a content type was, and then determine what specific format to use. With this new setup, the JSON files that make up the content are formatted as if they are [Microformats2](https://indieweb.org/Microformats), which means they're easier to work with.

However, as part of this restructure I found that it was a real pain to add a lot of logic into my theme, such as "if it has a `in-reply-to`, but not a `rsvp`, then it's a reply, otherwise it's an RSVP". This was duplicated in a few places and made it quite difficult to get working originally. I'd ended up saying that I didn't want my Micropub server to be more complex, and instead made the Hugo theme _even more painful_.

And in the last few days I've been missing the ability to browse to i.e. `/rsvps/` to see all my upcoming events, which came out of this work to restructure my site's content types.

So as of this announcement post, I've borrowed ideas from the [Post Kinds WordPress plugin](https://wordpress.org/plugins/indieweb-post-kinds/), and now have all my indie content split by kind i.e. [/kind/rsvps/](/kind/rsvps/). This is already known to me as it's how I know how to render the post differently depending on what it is, so this just pushes the logic of "what does this post look like" into my Micropub endpoint, rather than in my site's theme. I'm quite happy with this, as it means I've been able to remove a fair bit of complex Hugo templating logic, and move that logic into a place where I can properly unit test it.

If you want to see the breakdown per kind, you can check out [/kind/](/kind/) or from the list available on [/mf2/](/mf2/).
