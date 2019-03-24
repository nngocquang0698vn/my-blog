---
title: Creating Microservices for my Static Website
description: "Exploring moving data out of my site's remit and into its own 'microservices' which can be consumed at build-time, as well as via client-side JavaScript."
categories:
- announcement
tags:
- jamstack
- microservices
- jvt.me
- spectatdesigns
- netlifycms
- jekyll
date: 2018-12-23T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: microservices-static-site
---
As I mentioned in my [DevOpsDays London talk, _Overengineering Your Personal Website - How I Learn Things Best_][DevOpsDays talk], I want to overengineer my personal website a little bit more than it already is, and convert it into a fully fledged orchestration layer.

<https://www.jvt.me> is primarily used for mostly technical blogging, but I also use it a little bit to show off who I am and some of the things I work on. But that means there's a lot of content in-site that doesn't get touched as often, and then brings extra burden to update it as it needs to be. This includes my [Talks], [Projects] and [Blogroll], as well as possibly even the [About page] and my social connections + contact means.

I'll be moving them out into a separate "microservice" API, wherein I'll be consuming the data from that API to build the site's content for those pages. This is partly the model of the [JAMstack], where I'll be adding the ability to refresh the content client-side if you have JavaScript enabled. However, at the core of this is ensuring it can be consumed without JavaScript enabled, for the many clients who may not want to, so the content must also be available at build-time to build the site.

I've actually [already converted the Blogroll to consume the Blogroll API][blogroll-mr], which now pulls from <https://blogroll.jvt.me/blogs/index.json> using the Jekyll plugin [jekyll-get](https://github.com/18F/jekyll-get/). It'd make more sense to serve from `https://blogroll.jvt.me/blogs/` rather than needing the nasty `/index.json`, as well as looking at finalising the API schema. This currently doesn't have the ability to refresh client-side, [which is an issue on the backlog](https://gitlab.com/jamietanna/jvt.me/issues/314) to tackle soon, but it's currently "good enough" as a proof of concept.

One great benefit of moving to this model is that I can also avoid needing to check out the repo locally, but can instead use [Netlify CMS] as a static site CMS to in-browser edit the files in a structured way. This will make it really easy when I have the API in full force, and am able to update resources as-and-when I want.

Playing around with the Netlify CMS has been on my list of things to do for a while to build into a number of the sites within [Spectat Designs] to enable our customers to edit their sites much more easily.

The final great thing about this is that it gives pure programmatic access to this data around me, so anyone can consume this data for whatever means they want!

You can follow along on [my issue tracker's label `microservices-site`][issues].

[DevOpsDays talk]: {{< ref 2018-10-25-devopsdays-london-2018 >}}#overengineering-your-personal-website-how-i-learn-things-best
[Talks]: /talks/
[Projects]: /projects/
[Blogroll]: /blogroll/
[About page]: /about/
[blogroll-mr]: https://gitlab.com/jamietanna/jvt.me/merge_requests/214
[Netlify CMS]: https://www.netlifycms.org/
[JAMstack]: https://jamstack.org/
[Spectat Designs]: https://www.spectatdesigns.co.uk/
[issues]: https://gitlab.com/jamietanna/jvt.me/issues?label_name%5B%5D=microservices-site
