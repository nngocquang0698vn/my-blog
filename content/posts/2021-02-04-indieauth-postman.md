---
title: "Autogenerating Postman Collections for IndieAuth Servers"
description: "Creating Postman collections programmatically for a user's IndieAuth server."
tags:
- postman
- ruby
- indieauth
- indieauth-postman
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-02-04T18:40:28+0000
slug: "indieauth-postman"
image: https://media.jvt.me/2e899bbe68.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
When I wrote [Autogenerating Postman Collections for Micropub Servers]({{< ref 2021-01-11-micropub-postman >}}), I had a good bit of fun with generating a Postman collection for Micropub servers - and it didn't hurt that it was to enter a hackathon!

But over the last few weeks I've been doing a bit more with my [IndieAuth](https://indieauth.spec.indieweb.org/) server, like implementing [refresh tokens]({{< ref 2021-01-31-refresh-token-indieauth >}}).

As part of this, and other changes I work on, there's a fair bit of manual testing to double check that I've done everything right, even though I'm pretty confident that my automated tests will catch things, it's worth ensuring that it actually works when using other tools.

To aid this, and to help others who may want to be testing their own IndieAuth servers, I wanted to build another app to do this!

# How?

Similar to how I'd implemented my Micropub app, I've created a Ruby script (+ Sinatra web app) which takes a profile URL, determines the authorization and token endpoints, and generates a collection for us.

It supports the main journeys that an IndieAuth server supports - if there's anything you spot that's a problem, or you'd like adding, [please raise an issue](https://gitlab.com/jamietanna/indieauth-postman/-/issues).

# Demo

You can see an example of the generated configuration from my staging server, which is available as [a snippet on GitLab](https://gitlab.com/jamietanna/indieauth-postman/-/snippets/2071440), or you can try it against your own server based on instructions [in the README](https://gitlab.com/jamietanna/indieauth-postman).

You can also use the [Heroku App](https://indieauth-postman.herokuapp.com/), which has the added bonus of being able to point Postman at a URL, i.e. `https://indieauth-postman.herokuapp.com/collection?profile_url=https://www.staging.jvt.me`.
