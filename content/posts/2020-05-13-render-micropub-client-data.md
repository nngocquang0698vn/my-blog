---
title: "Rendering Micropub Client Data on Posts"
description: "Sharing more information about Micropub clients that have created a post, if possible."
tags:
- www.jvt.me
- indieweb
- micropub
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-13T13:42:33+0100
slug: "render-micropub-client-data"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
- https://indieweb.xyz/en/microformats
---
Aside from [blog posts](/kind/articles/), like this one, content I publish to my site is using the [open standard Micropub](https://www.w3.org/TR/micropub/), which I've supported [since last August]({{< ref 2019-08-26-setting-up-micropub >}}).

Being an open standard means there are lots of client implementations, so I'm free to use various different Web/mobile apps to interact with my site.

When I set this up, I did something I quite like, which is to make it so any new content created contains details of which Micropub client created it (the `client_id`).

Up until now, I've been showing this `client_id`, which is a URL such as `https://indigenous.realize.be`, but that may not be super meaningful to the reader.

A while back, I noticed that <span class="h-card"><a class="u-url p-name" href="https://jacky.wtf">Jacky</a></span> has some nice rendering of which client published - you can see an example [on this note](https://v2.jacky.wtf//post/1f8ffba0-e948-4dac-aa6a-3975074cced9) for the same client mentioned above, Indigenous.

If you've visited my site since last night, you may notice that I'm also starting to do this now:

- [example with a logo](/mf2/2020/05/3dpma/)
- [example without a logo](/mf2/2020/05/np6jk/)
- [example with no client information](/mf2/2020/05/4zeet/)

I'm hoping that this may make it slightly nicer to the reader, although I'm wondering if there's anything I can do to make it better.

So how am I discovering this client metadata?

[IndieAuth defines the `h-app` markup](https://indieauth.spec.indieweb.org/#application-information) using [Microformats2](https://microformats.io) for this purpose, which is great! It is optional for clients, which means I have to still make it possible for a client not to provide it, but for those that do, it so far contains all the information I need to make the metadata more useful.

I've decided to make this a manual process to update the metadata, for now, so I'm not making my site's build reliant on the services to be available so I can retrieve their metadata.
