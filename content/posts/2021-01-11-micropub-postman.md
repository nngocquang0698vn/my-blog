---
title: "Autogenerating Postman Collections for Micropub Servers"
description: "Creating Postman collections programmatically from a Micropub server's supported configuration."
tags:
- postman
- ruby
- micropub
- micropub-postman
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-01-11T19:37:01+0000
slug: "micropub-postman"
image: https://media.jvt.me/2e899bbe68.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
Over this last weekend I've built a small Ruby script for generating Postman Collections for Micropub servers as part of the [Postman API Hackathon](https://blog.postman.com/postman-api-hackathon/), and thought I'd write it up for those who are interested in it.

I'd originally started this as a Java hack, but given I was having issues with generating Java objects (POJOs) for the JSON schema, and I wanted to treat it as a hackathon and build a thing quickly, I pivoted to Ruby, which is my primary scripting language. It also meant that I'd be able to get using the [Microformats library](https://github.com/microformats/microformats-ruby), which doesn't (yet) exist for Java.

# Why?

[Micropub](https://micropub.spec.indieweb.org/) is an awesome standard, and makes it straightforward to have a standard API for interacting with content (on your website). I've been really enjoying it over the last year of working with it, and am really glad there's been some good progress to making a standard API for updating content.

As part of the initial local development for my Micropub server, and before I had [built my own client]({{< ref 2020-06-28-personal-micropub-client >}}), whenever I was testing against my Micropub server, I used `curl`. Although this worked, it didn't help all the time, because I'd need to keep re-fetching access tokens, or I would accidentally use a production token locally.

Another tool that is better targeted for this manual testing is Postman, especially - as I found out while working on this hack - that [it has some great OAuth2 support](/mf2/2021/01/hjfzb/), which integrates nicely with the OAuth2 extension, [IndieAuth](https://indieauth.spec.indieweb.org), that Micropub utilises.

When I spotted the [Postman API Hackathon](https://blog.postman.com/postman-api-hackathon/), I realised that maybe I could look at making it easier to use Postman to test Micropub servers, and hopefully help other folks with sending requests to their servers in the future.

# How?

One thing that's especially helpful about Postman's Collections are that they're JSON with a well-defined structure, which means it's straightforward to generate programmatically.

To start with, I went through and manually created a collection with some of the requests I'd expect to see, then exported the collection and pored through how things were structured.

Micropub has two key types of request - an action, and a query. With an action, you're performing a Create/Read/Update/Delete/(Undelete) on a given post, or set of posts. With a query, you're interrogating the server for some information, such as what posts have been written, what types of content is supported, etc.

Because we don't want to make it so each Micropub client needs to understand each person's server, we've again standardised the queries, and made it so clients can discover configuration by performing queries.

To make my hack more useful, I decided that I wanted the output Postman collection to have the ability to create a post for both form-encoded and JSON bodies, and for every type of data that the server supported. I also wanted to be able to provide a request for each of the queries.

Because there are two extensions, [Query for supported properties, for a supported post-type](https://github.com/indieweb/micropub-extensions/issues/33) and [Query for Supported Properties](https://github.com/indieweb/micropub-extensions/issues/7), we can build on top of these and very easily generate a collection with all the right requests prepared.

For servers that do not support the above, you'll receive a sensible default, but otherwise it'll populate the collection with all the requests you could want!

# Demo

You can see an example of the generated configuration from my staging server, which is available as [a snippet on GitLab](https://gitlab.com/jamietanna/micropub-postman/-/snippets/2059598), or you can try it against your own server based on instructions [in the README](https://gitlab.com/jamietanna/micropub-postman).

You can also use the [Heroku App](https://micropub-postman.herokuapp.com/) which will allow you to log in and receive your Micropub configuration, straight in the browser!
