---
title: 'Introducing a Go command-line tool for interacting with Micropub servers'
description: "Announcing the initial release of `micropub`, a CLI for interacting with Micropub servers."
tags:
- go
- micropub
- micropub-go
date: 2022-03-01T14:50:55+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: micropub-go-cli
image: /img/vendor/micropub-rocks-icon.png
syndication:
- "https://brid.gy/publish/twitter"
- https://news.indieweb.org/en
---
I've recently been adding a bit more media to my site, whether that's for the featured image for a post, or for screenshots for posts themselves.

In each case, I've been needing to upload it via a form on my [personal Micropub client](/posts/2020/06/28/personal-micropub-client/), which is slower, requires using a browser, and is not easily automatable.

As I've been looking to learn a bit more Go recently, I thought this would be a good chance to play around with [Cobra](https://github.com/spf13/cobra) and [Viper](https://github.com/spf13/viper), two libraries that power great command-line interfaces like [`hugo`](https://gohugo.io/), [`glab`](https://glab-cli.io/) and [`gh`](https://cli.github.com/).

I've released this very early version [on GitLab](https://gitlab.com/jamietanna/micropub-go/).

Currently, it supports uploading media to the media endpoint, but I'm looking to improve it over time, adding support for more content types, queries and operations.
