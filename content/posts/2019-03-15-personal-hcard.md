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
date: 2019-03-15
slug: "personal-hcard"
image: /img/vendor/microformats-logo.png
---
As you're reading this, I have now implemented an [hcard](http://microformats.org/wiki/h-card) for my personal details! You can see it on [my home page](/).

This has been in progress for quite some time while I've been trying to get some automated tooling in place to ensure I always have a well formed hCard for my personal details.

This is for a few reasons:

- not just because I'm a Quality Engineer, but because I am a huge fan of quality-driven software
- I don't want to accidentally break my hCard and cause external consumers to be unable to parse my IndieWeb site
- I want to be able to use Test Driven Development to drive in new hCard functionality
- I wanted to use [HTML-Proofer](https://github.com/gjtorikian/html-proofer), as I already use it for link checking within the site - so this was a great chance to play around with it and build something into the tooling I already use

Expect to see more announcements in the future as I complete issues [tagged with the `microformats` label](https://gitlab.com/jamietanna/jvt.me/issues?label_name=microformats).

This is yet another step towards being a bigger part of the [IndieWeb](https://indieweb.org/why).
