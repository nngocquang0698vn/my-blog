---
title: "Validating my JSON Feed on every site build"
description: "Adding in a validation in the pipeline to protect from a broken feed."
tags:
- indieweb
- jsonfeed
- www.jvt.me
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-18T17:55:36+0000
slug: "jsonfeed-validation-pipeline"
series: nablopomo-2019
image: /img/vendor/jsonfeed.png
---
Earlier today, I found that my site's JSON feed has been broken since Thursday afternoon. I like to ensure that my site has a pretty high uptime of functionality, so this kinda sucked.

This isn't _as much_ of an issue because I don't believe many folks use my JSON feed, as I have a fully fledged [h-feed](https://indieweb.org/h-feed) and RSS feed, and JSON feed isn't as popular.

However, as mentioned in [_Re-enabling search on my static website_]({{< ref "2019-05-01-reenable-static-search" >}}), this JSON feed is actually to be used for [my search functionality](/search/) on the site. This is more of a problem because it leaves the site broken, and folks aren't able to find previous content on the site.

[Since September I've had an issue to check whether the feed was valid JSON in my build pipeline](https://gitlab.com/jamietanna/jvt.me/issues/726), but I haven't yet actually done it because I didn't think it could be that bad, and it didn't break that often.

I have, now, resolved the issue by [fixing the issue that caused it to break](https://gitlab.com/jamietanna/jvt.me/commit/8960c9b30bc9b53e91878b0660e7905b8ce72b14), adding a validation step to ensure the feed is well-formed and I've also added [follow-up work to stop this specific issue happening again](https://gitlab.com/jamietanna/www-api/issues/69).

I now validate my feed by using [a JSON schema of the feed](http://json.schemastore.org/feed) that covers my compliance with the spec, as unfortunately I couldn't use the feedparser gem [as it doesn't validate the feed format](https://github.com/feedparser/feedparser/issues/9).

Going through and validating that it is a valid JSON Feed, rather than just checking it's valid JSON, has actually picked up on the fact that my JSON feed has _never_ been correct, as it has retuned an invalid field `date_modfied`, not `date_modified`.

It's also shown I've had a number of duplicated tags on posts, so I've also looked at fixing it [on my Micropub endpoint](https://gitlab.com/jamietanna/www-api/issues/70) as well as [picking it up on site builds](https://gitlab.com/jamietanna/jvt.me/issues/796).

At least I'm moving slowly towards a well-formed site, and regression-proofing these issues by automating the steps to catch breakages in the future!
