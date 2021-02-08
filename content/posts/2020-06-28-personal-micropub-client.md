---
title: "Creating My Own Personal Micropub Client"
description: "Announcing my own personal Micropub client to publish content that is very specific to my workflows."
tags:
- www.jvt.me
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-28T21:08:04+0100
slug: "personal-micropub-client"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
- https://indieweb.xyz/en/microformats
- https://lobste.rs/s/ox798y/creating_my_own_personal_micropub_client
---
# Why?

I've been using the open standard [Micropub](https://www.w3.org/TR/micropub/) for publishing to my site for [almost a year]({{< ref 2019-08-26-setting-up-micropub >}}).

Because it's an open standard, there are [loads of great Micropub clients](https://indieweb.org/Micropub/Clients) that can be used to publish content, so up until now I've been using them.

However, there are certain requests that are very specific to my site and my workflow that don't make sense to general-purpose Micropub clients, or that aren't as widespread as to need support. This means that if I want to create these posts, then I need to perform a manual `curl`, which although possible, isn't as helpful when I'm i.e. on mobile.

Since I [set up a staging Micropub server last year]({{< ref 2019-12-26-micropub-staging-server >}}), I've been using it as a great way to preview posts before it goes to production, which especially helps when I'm trying something new and want to make sure it'll render correctly.

However, when I want to test these out, I need to trawl back and find a previously created access token, or get a new one.

For both these purposes, I've found it less than ideal, and I want a slightly better UX than that.

So I thought, you know what, I should create my own Micropub client. I can shape it around my desire to be able to create content against staging or production, and for the content types that I want, which may not apply to how others use their own sites, or how they'd expect the contract to be implemented.

# What

My new client can be found at [www-editor.jvt.me](https://www-editor.jvt.me), but as it requires you to authenticate against either my production or staging domains, you won't be able to view any of the form, so I've taken a handy screenshot:

![Screenshot of Jamie's micropub editor, showing four forms - one for publishing a note with a photo, one for a reply with a title, one for an event, and one for a person](https://media.jvt.me/92b2431feb.png)

As you can see, I've added the ability to:

- publish notes with a pre-uploaded photo, as I often upload from my phone, but then post on my laptop/desktop, where it's more comfortable to type out a longer alt text
- publish replies with a title (i.e. for use with GitHub issues)
- publish self-owned events
- publish h-cards for [@-mentioning people](https://www.jvt.me/posts/2020/03/22/at-mention-people/)

I decided I did not want to make this a general-purpose editor (at least for now), as I want to still use other folks' clients, and only use my own when I need extra stuff that's not supported in other clients.

# Implementation Details

I was thinking about implementing this as a Netlify-only project, using Netlify Functions, which reduces any management of infrastructure, but as I've said before, I'm a Java developer and I want to invest in my skills where possible.

It's also been a great opportunity as I've been able to work on a full-stack application with Spring Boot, whereas I've previously done only APIs, so it gave me my first experience with how to write, and test, a Spring MVC application.

The server component of the project purely handles the IndieAuth interactions, and rendering the HTML for the forms based on which domains are currently "logged in". For Authentication/Authorization, the login process stores the access token from my IndieAuth server as an encrypted JWT (JWE) stored in a cookie, which can then be sent by the client on subsequent requests to prevent repeat authentications.

Interested in the code? [Check out the initial Merge Request for the code](https://gitlab.com/jamietanna/www-api/-/merge_requests/162).

# The Future

I already have a number of future improvements to make which are [labelled on my public issue tracker](https://gitlab.com/jamietanna/www-api/-/issues?label_name%5B%5D=project%3Aeditor), and I'm sure now I have this capability I'll start to invest in it further.

~~The most important of these feature requests that I'm looking at implementing is [_Autoconfigure Micropub based on supported properties_](https://gitlab.com/jamietanna/www-api/-/issues/218), which would allow my client to automagically render forms for all the content that my Micropub server supports!~~

Update: I've [now added this support]({{< ref 2020-10-15-micropub-client-autoconfigure >}}).
