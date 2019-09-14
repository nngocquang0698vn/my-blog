---
title: "Sending Webmentions Automagically on Deploys of the static website www.jvt.me"
description: "The journey to getting Webmentions sending automatically from my static website, www.jvt.me."
tags:
- www.jvt.me
- webmention
- indieweb
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-10T09:30:30+0100
slug: "webmentions-on-deploy"
image: /img/vendor/webmention-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
# Background context on www.jvt.me

For those of you who have only read this post on my website, you may be unaware of how this site is set up, which will provide a bit of background for why this is something to celebrate.

My website is a static website built with the [Hugo](https://gohugo.io/) static site generator, and deployed to Netlify. Because my site is static, it means I can't easily send [Webmentions](https://indieweb.org/webmention), without following a similar process to <span class="h-card"><a href="https://mxb.dev/" class="u-url">Max Böck</a></span>'s article [Static Indieweb pt2: Using Webmentions](https://mxb.dev/blog/using-webmentions-on-static-sites/).

This would work perfectly, aside from the fact that before it gets deploy to Netlify, I have a full build/test/deploy pipeline in [GitLab CI](https://docs.gitlab.com/ce/ci/) to give me confidence that the site isn't going to break something for my users.

This pipeline runs for anywhere between 6 and 10 minutes in total (depending on wait times + latency), which is quite a slow process and reduces the feedback time to be able to share content. I used to have a stage in the pipeline which, after deployment, would then notify search engines of updated content, and send me a push notification to say the site is deployed. This gave me a nudge so I could then know to go through and share it wherever it needed to be, but manual work is never my favourite!

Some time ago I created a webhook received from GitLab to a Java Spring Boot API which would allow me to extract that from my pipeline, and execute it outside of that, on a successful pipeline run from GitLab.

This stage was the perfect place to be wanting to send Webmentions, as it was triggered after a successful site deployment, so I knew my content would be discoverable at this point.

# Getting Webmentions Sending

I decided that I would send a Webmention for each item in my social feed ([h-feed](https://indieweb.org/h-feed)), as that was the most discoverable feed of links that a user would be going through.

My main concern with this was the requirement for me to implement a Microformats2 parser in Java, because there doesn't seem to be a popular one I can use. Fortunately, I had a bit of a brainwave, and have delegated out to [php.microformats.io](https://php.microformats.io/) to perform the Microformats2 parsing of the feed.

With this, I then had a list of posts (be they Indie posts like a bookmark, or a full blown article), but then had the challenge of finding all the links on the page, and sending the Webmentions.

Again, I wasn't enthused about having to write this all myself, but fortunately found <span class="h-card"><a href="https://kevinmarks.com" class="u-url">Kevin Marks</a></span> had built [mention.tech](https://mention.tech) which had a handy `/mentionall` endpoint. I was able to send it a URL, and Kevin's service would do the hard work for me - extracting any URLs in the page, then performing Webmention discovery on the URL, and if it has a Webmention endpoint, send one.

I was really happy with this process, as it managed to save me some time in implementing all those pieces, and helped me unlock the thing I actually wanted to build - automated webmention delivery!

At some point I'll embrace [the plurality principle](https://indieweb.org/plurality) and implement this all myself, but until then, thanks folks for making it easier for me to get up and running!

And even better is the fact that this took me all of about 5 hours' work to get going (largely slowed down by the fact that I couldn't get asynchronous processing working because I was editing the wrong Spring configuration file in my project!)

**Update 2019-09-14**: Unfortunately following this post I found that actually, not all my webmentions were being sent. This was due to the way that mention.tech was parsing the links in the page, which wasn't quite how I wanted it to be done. I preferred the idea that I could send a Webmention for anything on the page, which meant that my likes/RSVPs/etc would work, as well as be able to auto syndicate posts. This is now a much better workflow for me, but required I utilise the [jsoup](https://jsoup.org) project to handily parse the HTML for each of the pages. This still uses mention.tech under the hood to send webmentions for links, so I don't have to do Webmention endpoint discovery.
