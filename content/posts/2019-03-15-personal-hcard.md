---
title: "Setting up a personal hCard for myself"
description: "Setting up an hCard to allow microformats parsing for details about myself."
categories:
- announcement
- indieweb
- microformats
tags:
- indieweb
- microformats
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-15T00:00:00
slug: "personal-hcard"
image: /img/vendor/microformats-logo.png
---
As you're reading this, I have now implemented an [hcard](http://microformats.org/wiki/h-card) for my personal details! You can see it by inspecting the source code for [my home page](/).

So why have I done this? As part of my move towards greater integration with the [IndieWeb](https://indieweb.org/why), I'm looking to use more open standards for data markup on my sites. This is where [microformats2](http://microformats.org/wiki/microformats2) comes in, making it easier for automated parsers to discover content on my site using well-structured markup. This means that you won't need to necessarily parse all the HTML you need, but can instead put it through a microformats2 parser and it'll come out on the other side with all the relevant metadata.

This has been in progress for quite some time while I've been trying to write some automated tooling to ensure I always have a well formed hCard for my personal details.

I did this for a few reasons:

- not just because I'm a Quality Engineer, but because I am a huge fan of quality-driven software
- I don't want to accidentally break my hCard and cause external consumers to be unable to parse my site
- I want to be able to use Test Driven Development to drive in new hCard functionality
- I wanted to extend [HTML-Proofer](https://github.com/gjtorikian/html-proofer), which I already use with my site, to perform the verification. This was a great chance to play around with it and build something into the tooling I already use

Expect to see more announcements in the future as I complete issues [tagged with the `microformats` label](https://gitlab.com/jamietanna/jvt.me/issues?label_name=microformats).
