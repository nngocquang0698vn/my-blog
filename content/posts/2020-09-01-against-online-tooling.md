---
title: "Why I Actively Discourage Online Tooling like `jwt.io` and Online JSON Validators"
description: "Why you should be opting for local tooling when working with sensitive data, even Non-Production ones."
tags:
- security
- privacy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-09-01T14:53:48+0100
slug: "against-online-tooling"
image: /img/vendor/jwt.io.jpg
syndication:
- https://lobste.rs/s/jxlr73/why_i_actively_discourage_online_tooling
- https://news.ycombinator.com/item?id=24342063
- https://news.ycombinator.com/item?id=24352360
- https://www.reddit.com/r/programming/comments/ikldt9/why_i_actively_discourage_online_tooling_like/
- https://www.reddit.com/r/coding/comments/ikldsl/why_i_actively_discourage_online_tooling_like/
---
Something my colleagues know well is how little I trust online tools like [jwt.io](https://jwt.io), [token.dev](https://token.dev) online JSON validators or online tooling in general, but it also bleeds into [comments I make online](/mf2/2020/08/zebqf/) and in my blog posts, too, and I thought I'd share a little bit of a reason as to why.

Instead of using an online service, I will reach for a way to run it locally, using whichever programming language toolchain I have available. But why? Why wouldn't I recommend something like jwt.io? Or an online JSON validator, especially if they boast client-side functionality, and mean I don't need things installed?

Let's start with a bit of background. Firstly, I'd just like to caveat this all with the note that **I have no access to Production data, customer or otherwise**. All of these examples are referencing Non-Production examples.

I also want to caveat this with the fact that this is **not a personal attack** on jwt.io. I am using them as an example as they're a well-known and well-used service, and I've seen issues with it before. Auth0 run it, and are probably one of the few companies we'd want to be running it. It's also [Open Source](https://github.com/jsonwebtoken/jsonwebtoken.github.io) _but_ one of the great difficulties of Web-hosted services are that we have no idea if the source code that we're told is being used is actually being used!

I'm currently working on the Open Banking platform for Capital One. We're fortunate to have very restricted access to Production, which makes things safer for everyone. One thing we strive to do is to treat Non-Production secrets like Production ones where possible - where we shouldn't have access to them at all, and shouldn't be sharing them with external services. Some of these Non-Production secrets may be usable outside of Capital One, for instance Open Banking Sandbox signing certificates.

We perform a fair bit of testing in our Non-Production environments and sometimes need to debug things, such as what's inside a JWT (as Open Banking introduces several places they're used). I've been burned a number of times by folks putting a Non-Production JWT or an Open Banking Sandbox certificate into jwt.io. Although Non-Production, these are sensitive in of themselves, as they have implementation details for our services, and as mentioned, certain things could be used outside of Capital One.

The biggest reason I hear from folks using online tooling is that it's easier, and that they'd rather do that than find out how to run it locally. I disagree with this, but am quite biased, as I often have a blog post for many of these common issues. I love sharing my blog with others and having a handy solution, or if I don't have an answer to a problem, I'll find out how and [blogument it for later](/tags/blogumentation/). So I see that reaching for online tooling is more just because we've got folks who aren't aware of how they could do otherwise.

One great thing about removing the need for an online tool is that you can self-serve it once you have the tools locally. You can run it locally when you've got no internet (which isn't as much of an issue in these Coronavirus times) but also regardless of whether the upstream service is broken. You can use it with other i.e. command-line tooling, for instance how I've set up [this command-line script](https://gitlab.com/jamietanna/dotfiles-arch/-/blob/master/terminal/home/bin/unpack) to handle a lot of common data formats I deal with and unpack them to a human-readable format.

But most importantly, by telling people to put sensitive data (such as credentials, configuration files, etc) it's a really dangerous lesson for our teams. We're teaching people to blindly trust arbitrary websites that they don't have any relationship with, nor have fully audited the source code, when posting potentially sensitive data.

I realise this may not be something you do when running it locally, but it's less likely for a well-known library running locally to need to reach outbound.

jwt.io is an interesting example, because although it boasts that it runs as a client-side solution, you may not have been aware that [until last September](https://github.com/jsonwebtoken/jsonwebtoken.github.io/commit/b362ab19a9f37e337b5f8ea38987aa680aa6e0a9), there were metrics being determined which although may have seemed innocent, show that it's easy for other functionality to be hidden in a seemingly client-side-only website. Unless you audit everything, every time, you're in a risky position where you may be leaking data you're not expecting to.

I feel that we can do something to help services that handle potentially sensitive data with helping educate the user that they should be more careful, because jwt.io's warning definitely doesn't help with folks who don't fully appreciate what the risk is if jwt.io isn't actually as trustworthy as the user thinks:

> Warning: JWTs are credentials, which can grant access to resources. Be careful where you paste them! We do not record tokens, all validation and debugging is done on the client side.

What do you think? Am I maybe being a little too sensitive? Am I not being sensitive enough?

Edit: Based on some conversations being had in response to the post, I thought it'd mention I've written about how to [pretty-print a JWT locally with OpenSSL]({{< ref 2019-06-13-pretty-printing-jwt-openssl >}}) and [a Ruby alternative]({{< ref 2018-08-31-pretty-printing-jwt-ruby >}}).
