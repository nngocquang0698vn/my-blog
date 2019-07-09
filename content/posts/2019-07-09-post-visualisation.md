---
title: "Visualising My Posting Habits"
description: "Adding the capability to my site to enable visualisation of how often I post content."
tags:
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-07-09T22:44:33+0100
slug: "post-visualisation"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
For a while now I've been looking at getting some insight into how often I post content to this site for two reasons - purely for interest, and to watch how it changes over time.

With this post, you can now go over to [/post-frequency/](/post-frequency/) to see the latest graphical breakdown of my posting content - I'd recommend it to know what's actually being talked about!

To generate these charts, I've created a Hugo template that generates a set of counts for each of the content types that I regularly publish (i.e. ignoring static content like events or talks), which is then rendered by [Chart.JS](https://www.chartjs.org/) as a line chart.

Some interesting pieces of data I've gleaned from the stats as they currently sit:

- I post more content either early evening or just before bed
- I seemingly post a lot on the 7th of the month, but not much on the 8th, 21st or 27th
- Thursdays and Sundays are my most popular days
- March is my most productive month of content - most likely because I usually take a week's holiday over my birthday, so I end up writing a lot while I'm off

I'm looking forward to keep an eye on the way that my content publishing changes over time, i.e. with the use of [Micropub](https://indieweb.org/micropub) for posting from anywhere.
