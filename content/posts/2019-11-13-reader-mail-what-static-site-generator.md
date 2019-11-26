---
title: "Reader Mail: What Static Site Generator Would I Recommend?"
description: "What Static Site Generator would I recommend?"
tags:
- nablopomo
- reader-mail
- static-site-generator
- jekyll
- hugo
- golang
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-13T23:59:00+0000
slug: "reader-mail-what-static-site-generator"
series: nablopomo-2019
---
Earlier today I received a message on Twitter from <span class="h-card"><a class="u-url" href="https://rwapp.co.uk">Rob Whitaker</a></span>, and thought I'd reply publicly via a blog post, rather than a lot of threaded tweets.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> Hey Jamie. Do you have any recommendations for static site generators? Ideally I want something that needs as little maintenance as possible so I can concentrate on content.</p>&mdash; Rob Whitaker (@RobRWAPP) <a href="https://twitter.com/RobRWAPP/status/1194684853092077568?ref_src=twsrc%5Etfw">November 13, 2019</a></blockquote>

Readers of my blog may know that for a couple of years this site was built upon [Jekyll](https://jekyllrb.com), but [at the start of the year I moved]({{< ref "2019-01-04-goodbye-jekyll-hello-hugo" >}}) to [Hugo](https://gohugo.io). I found Jekyll great at the time, but ~10 second rebuilds for single page changes were starting to take their toll and make me less happy to make changes to my site. With Hugo I'm building ~10000 pages on a clean build in ~5 seconds - that's quite a difference!

I asked a follow-up to Rob, to help answer better in terms of the preferred tech stack. This is because although I'd love to recommend Hugo to everyone, I realise that it's not going to be for everyone, and some folks may have a preference for what they want. For instance, folks using React quite often will likely want to use [Gatsby](https://gatsbyjs.org/) or developers who work with Ruby every day may be more inclined to use Jekyll.

A good place to start will be [Static Gen](https://www.staticgen.com/) as they list all the different static site generators, with various bits of detail on it to help you compare.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Ideally it would be in swift, but I’m only aware of one that <a href="https://twitter.com/johnsundell?ref_src=twsrc%5Etfw">@johnsundell</a> uses and it’s not released as of yet.<br>I’m happy with Java or Node.js. Preferably not ruby. Don’t know anything about Go, but don’t mind learning.</p>&mdash; Rob Whitaker (@RobRWAPP) <a href="https://twitter.com/RobRWAPP/status/1194695748165783554?ref_src=twsrc%5Etfw">November 13, 2019</a></blockquote>

On the Swift side, according to Static Gen there is [Spelt](https://github.com/njdehoog/Spelt) which may be of interest in the meantime, but unfortunately hasn't been maintained in 3 years.

Next, it's important to know whether the person wants to build the theme themselves, or adapt someone else's:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Ideally I’d like a pre-made theme, I have an aversion to CSS and have no design skill. But it would have to be accessible to a high standard, so happy to tweak.</p>&mdash; Rob Whitaker (@RobRWAPP) <a href="https://twitter.com/RobRWAPP/status/1194696499055206401?ref_src=twsrc%5Etfw">November 13, 2019</a></blockquote>

In this case, Rob was happy picking up someone else's which is why I'd recommend Hugo as the [Hugo Themes site](https://themes.gohugo.io/) is huge and includes so much, and it's possible to take any HTML template that may be produced elsewhere and tweak it for Hugo (this is true for any static site generator, mind).

This made me think that I'd recommend Hugo as a starting point just because it is _so easy_ to get up and running, and requires only one dependency to work - Hugo itself! It's one that I find I always recommend because it's easy to use, incredibly batteries-included, and _so fast_.

There are quite a few accessibility-focussed themes, such as [cupper](https://github.com/zwbetz-gh/cupper-hugo-theme) which <span class="h-card"><a class="u-url" href="https://annadodson.co.uk">Anna</a></span> has [modified for her own means](https://github.com/AnnaDodson/cupper-hugo-theme), but chose it because it was (at the time) a 100% accessible site to Lighthouse and was a really good starting point.

Hugo doesn't require you know anything about Go (I didn't, for instance), and requires very little practice with the templating language that Go uses if you want to tweak your theme. It's not something I knew before using it, and now only kinda know, and keep re-learning each time I change my theme.

One thing to be careful of is the Hugo documentation using lots of Go terms for functions, which can make it hard to search on the site if you're not able to get the specific terms.

Re Rob's comment:

> I want something that needs as little maintenance as possible so I can concentrate on content.

I would say this is something that can be a tiny bit risky with Hugo, as they've not yet got a `1.x` release, so there are still breaking changes released that may require some tweaks when upgrading, so be warned. But otherwise, it's pretty easy and I've not seen any burdens of using it.

But really, the only way I can say whether you'll like it is to try it. Build an out-of-the-box site with it, and see how easy it is to create new content for it. If the experience is nice, give it a go.

You can always try different ones for the editing process, but still publish to your existing site, while you're deciding on what tool to use.

I'd also recommend coming to a [Homebrew Website Club: Nottingham](/events/homebrew-website-club-nottingham/) to chat to others in the community, and get some time to try it out.
