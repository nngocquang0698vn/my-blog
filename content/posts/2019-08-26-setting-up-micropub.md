---
title: "Setting Up a Micropub Server for www.jvt.me"
description: "Announcing the creation of my Micropub server, to allow publishing content away from my laptop/desktop."
tags:
- www.jvt.me
- indieweb
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-26T22:34:43+01:00
slug: "setting-up-micropub"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: 'Lobsters'
  url: https://lobste.rs
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
---
As part of my venture into the wonderful world of [Owning My Data](https://indieweb.org/own_your_data) as part of the [IndieWeb](https://indieweb.org/why), I've been creating [different types of content on this site since May](/mf2/6b919e78-c46a-48e3-8866-9d9e9d41bb3d/). These include, but are not limited to likes, replies and bookmarks of other posts.

Over the last few months I've been starting to interact with other posts from my website first, which has been really nice, partly because I can point folks to content I've reshared, which allows them to find a recommended reading list of sorts, as well as make it helpful for me to be able to think "hey, where I'd found that awesome article?" and be able to just go to my website. This saves me having to trawl through my read-it-later list, or through my Twitter interactions, but gives me a slightly easier place to search through.

But the issue with writing this content is that it's a case of hand-writing JSON files and getting all the right properties in place. This isn't ideal, and it requires the ability to push to my [GitLab.com repo](https://gitlab.com/jamietanna/jvt.me) which I can't do on mobile.

But as is tradition, the IndieWeb community have solved this problem with [Micropub](https://indieweb.org/Micropub).

# What's Micropub?

Micropub is an open API standard that separates the publishing software you use (i.e. WordPress, Hugo, carrier pigeon) to the tool you use to create content for it.

It's built in a client-server model, where the server interacts with the publishing software used by the site and translates Micropub requests to something that the site can understand. For instance, this could translate a POST request to `/micropub` to telling WordPress to write to a database, or creating a file on disk for Hugo. Because of this standardised API, it means that the client has no need to understand how these posts are being created, it just needs to know the Micropub API.

Because the client speaks a common language with a server, it means that the client is interchangeable, allowing the community to build better editors, separate to their publishing software, as it then allows everyone to have a better creation experience. This also means you can i.e. move your site from Jekyll to Hugo and not have to update anything in the Micropub client, only on your Micropub server. This is because the server has to have understanding about how your site works, and how content is published, whereas a client has a standardised API which cannot know about the underlying implementation details.

It builds upon the authentication and authorization standard [IndieAuth](https://indieweb.org/IndieAuth) (dubbed "OAuth for the Open Web") and allows you to authorize external Micropub clients, be they a web or mobile application, and then create content for your site.

The [plurality](https://indieweb.org/plurality) principle of the IndieWeb means that there are [tonnes of clients](https://indieweb.org/Micropub/Clients) available for use, and the list is always growing!

One great benefit of Micropub is that when using a [social reader](https://indieweb.org/reader) I am presented with a feed of content which I'm able to easily like/repost/reply to, as if it were on i.e. Twitter. This underlines the social aspects of the social web.

# Getting it into www.jvt.me

I wanted to get Micropub integrated with my website as soon as I set up the different post types in the site, as I could foresee the downsides of not having Micropub:

- it wouldn't allow me to share things / engage with content on the go (which is where I do most of my reading)
- it requires me to write JSON files by hand, which I'd prefer not to

However, there have been a number of higher priorities which have been preventing me to getting to write this Micropub server, which have delayed me for a few months now.

One of the difficulties of implementing Micropub is that it's often very tailored to the tooling you use to run your website. I could've tried to use [nanopub](https://indieweb.org/nanopub), but it wouldn't have worked as well given the author's site is set up differently to mine. My site is very particular in the way that it is 100% tracked in Git after which it is built, deployed to a staging site, then tested, _then_ put live by GitLab CI. This means that my Micropub server has to know how to `git commit` directly to GitLab, as well as knowing exactly how my content is formatted and what the directory structure should be.

This level of confidence in the site's content is further added complexity to Micropub, as there's no way for the Micropub server to know if the content will fail those other checks, as the pipeline runs for over 8 minutes! I've shifted the changes I can do forward to the Micropub server, so when a client is creating a post they will find out synchronously if there's anything I can envision will break Hugo, but then everything else is done asynchronously.

As I started work on my Micropub server, I found that I needed to [restructure the way that Indie post types are created in the site]({{< ref "2019-08-18-restructure-content-types" >}}), which required a couple of weeks' work to get off the ground. This was because in the past I had separate directories for content, i.e. `/bookmarks/` which then made it quite difficult to write the server as it would need to understand which fields represented a content type, which isn't very easy because a reply and an RSVP have almost identical properties. Once this was done, the Micropub implementation was much easier although it had put me back a couple of weeks.

I also wanted to practice ["manual until it hurts"](https://indieweb.org/manual_until_it_hurts), a concept where you resist automation until you can no longer do a task manually, once you fully appreciate how it works and how it can be automated. This was a way to force me to prioritise my Micropub server, as I'm someone who finds it quite painful to perform manual, repetitive tasks, and so often find a way to automate it, and if I had an easy way to sidestep hand-crafting JSON files, I would've taken it. It sounds a little masochistic, but I know what I'm like - even when it's writing a new cool piece of code, I'll still put it off!

# Why it took time to set up

Over the last few weeks I've had a little bit of time investigating how I'd work on the Micropub aspect, both from the `git commit`ing to GitLab, as well as accepting the Micropub request, but with the late summer Bank Holiday in the UK, I was able to spend basically the whole 3 day weekend on it. And today, I've finally pushed it live, with a couple of caveats.

By running through [the Micropub Rocks Conformance Suite](https://micropub.rocks) I can see that I'm not 100% compliant with a few error scenarios. I've also purposefully not looked at implementing certain things, such as JSON requests, update/delete, or supporting a media endpoint or allowing a client to retrieve configuration around the implementation. This is partly as I want to get the bare minimum available, and I know I'm going to be only using certain functionality for now.

I also wanted to increase my knowledge of building Java APIs from scratch, as I don't do it as much from scratch in my day job as I'd hope. This also gave me a good opportunity to work with the [Spring Security library](https://spring.io/projects/spring-security) as I don't have much experience with it.

And because it's not been things that I'm as comfortable using, it's taken a little bit of extra time to get to grips with it, as well as doing this (in my opinion, correctly) using Test-Driven-Development, which at times has meant deleting what I've got so far and then re-writing it test-first.

# Going Forward

Although this implementation is live, it's not quite ready yet to be marked as "done".

**Update**: The source code can be found at [<i class="fa fa-gitlab"></i> jamietanna/www-api](https://gitlab.com/jamietanna/www-api/tree/master/www-api-web/micropub), and is licensed under [GNU Affero General Public License v3](https://www.gnu.org/licenses/agpl-3.0.en.html).

In the time that I've been finally getting this working, as well as looking at the restructure of my site, I've decided not to write any Indie post content. However, that means I've now got a tonne of content to backfill - oops! Expect to see a fair bit appearing in feeds over the next few days.
