---
title: "Specifying datetime in your Hugo posts' front matter"
description: "Setting your posts' `date` to a datetime string to specify the time a post was published at."
categories:
- blogumentation
- hugo
tags:
- blogumentation
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-24T13:43:40
slug: "datetime-hugo"
---
Over the last week I've been on holiday, so I've been blogging a fair bit on the stuff I've been working on, which in some cases has resulted in me blogging a couple of times a day.

The trouble is that I currently only tag my posts publish date against the date, not the date+time (datetime). This means that when Hugo is rendering the list of posts, sometimes they'll be in the wrong order of when they were written because Hugo doesn't know that one post was authored after the other (as it's not in the `date` metadata).

Looking at the [Hugo forum post _Clarity on front matter date format_](https://discourse.gohugo.io/t/clarity-on-front-matter-date-format/1794), it appears that Hugo allows you to specify the datetime in the `date` field with the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format:

```yaml
# without timezone offset
date: "2019-03-24T13:43:40"
# with timezone offset
date: "2019-03-24T13:43:40+00:00"
```

This makes it possible for Hugo to fully understand the datetime that a post was generated.

I've also [raised a fix to the Hugo docs](https://github.com/gohugoio/hugoDocs/pull/770) to fix it for future users.
