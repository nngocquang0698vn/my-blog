---
title: "Reader Mail: Getting an RSS Feed of Only Posts"
description: "Updating my site to allow for RSS feeds for specific post content such as posts, as per a reader's request."
tags:
- www.jvt.me
- reader-mail
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-01T11:19:48+0000
slug: "reader-mail-rss-posts-only"
---
Earlier today I received an email from <span class="h-card"><a class="u-url p-name" href="https://robertvanbregt.nl/">Robert van Bregt</a></span>:

> I like reading your posts and do this through a feed reader. You currently only have a 'firehose' feed for the homepage, with all content. I'd like to subscribe to an RSS or JSON feed for your /posts/ section only. Is that in the works?

The answer is ["well yes, but actually no"](https://knowyourmeme.com/memes/well-yes-but-actually-no) - I knew it was a thing that was on my backlog, but I'd not yet got around to it. I had two issues on my backlog tracking this - [_RSS feeds broken on taxonomy pages_](https://gitlab.com/jamietanna/jvt.me/issues/405) and [_Expose RSS feed per content type_](https://gitlab.com/jamietanna/jvt.me/issues/435) that would solve this issue.

But then a couple of weeks ago, I raised [_Only have articles in the default RSS feed_](https://gitlab.com/jamietanna/jvt.me/issues/793) after seeing this comment from <span class="h-card"><a class="u-url p-name" href="https://qubyte.codes">Mark Everitt</a></span>:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I have the terrible feeling that since I added notes to my blog I&#39;ve been spamming people via RSS. I need to split it out into multiple feeds...</p>&mdash; Dr Mark Everitt (@qubyte) <a href="https://twitter.com/qubyte/status/1194984709119528962?ref_src=twsrc%5Etfw">November 14, 2019</a></blockquote>

This got me thinking that my RSS feed may be similar, and yep, it was an issue!

I hadn't got around to fixing it (largely because [NaBloPoMo 2019 took a lot of my time this month]({{< ref "2019-11-30-nablopomo-2019-retro" >}})) but as I've now had someone ask for it, I decided to sort it out.

It's now possible to subscribe to `/posts/feed.xml` and that'll provide you a posts-only RSS feed. It's also made discoverable in the HTML so a well-formed feed reader should be able to discover it when reading `/posts/`:

```html
<link rel="alternate" type="application/rss+xml" href="/posts/feed.xml" title="Jamie Tanna | Software (Quality) Engineer" />
```

As part of this change, I've also taken advantage of Hugo's `AlternativeOutputFormats` variable, which allows me to output all output types on a given page, which means that i.e. [the iCalendar entry on an event page]({{< ref "2019-09-02-calendar-single-event" >}}) will be discoverable, too.

This also makes it possible for you to subscribe to a certain taxonomy i.e. `/tags/blogumentation/` or `/series/nablopomo-2019/` if you only care about a subset of my content.

One thought I did have when doing this was to update the main RSS feed, `/feed.xml`, but I've decided against it as it'd break for folks who aren't expecting the change and would miss out on content in the firehose (a great way to refer to this, btw!) they want to see.

Thanks for the report Robert, it's nudged me to fixing it!
