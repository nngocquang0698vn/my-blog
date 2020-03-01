---
title: "Announcing Micropub-Media-Endpoint-Proxy"
description: "Announcing a web-based solution for uploading files to your Micropub media endpoint."
tags:
- micropub
- indieweb
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-29T20:15:13+0000
slug: "media-endpoint-proxy"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: /en/micropub
  url: https://indieweb.xyz/en/micropub
---
Recently <span class="h-card"><a class="u-url" href="https://jlelse.blog">Jan-Lukas Else</a></span> [wrote "How should I upload files to my Micropub media endpoint?"](https://jlelse.blog/micro/2020/01/2020-01-01-frviz/), which is a question I myself have asked in the past.

Since having the ability to upload to my own media endpoint, I've found it has been a bit of a pain point to upload files without needing to create a post. For instance, uploading a screenshot to send someone, or upload an image for a post's featured image, neither of which flow expect a post to be created there and then, but to be consumed by other means.

On mobile, the great [Indigenous for Android](https://indigenous.realize.be/) allows you to upload arbitrary files to the media endpoint, but there didn't seem to be anything on non-mobile platforms.

I am quite fortunate that my solution for my media endpoint is backed by a Git repo, so I can simply check it out, and `git commit` my file, but I know others may not have this convenience, as Jan-Lukas mentions.

To fill the gap with this, I've just launched [Micropub Media Endpoint Proxy](https://micropub-media-endpoint-proxy.netlify.com/), which makes it possible to upload a file to your media endpoint.

I've decided to go for a minimum viable product, and require users to provide their own access token, and their media endpoint URL - I'd be happy for someone to contribute the changes required for it!

The source code is [available on GitLab](https://gitlab.com/jamietanna/micropub-media-endpoint-proxy.netlify.com), and the project is licensed under the [AGPL3](https://www.gnu.org/licenses/agpl-3.0.en.html).
