---
title: "Introducing tweetus-deletus 🐦🪄💀 - a tool to automate deleting your tweets, through the browser"
description: "Announcing the release of tweetus-deletus, a tool to delete all your tweets, driven through the browser with Playwright."
date: 2023-09-30T21:47:35+0100
tags:
- "playwright"
- javascript
- twitter
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: tweetus-deletus
---
Like many other folks, I've been pulling away from Twitter since Elon Musk bought the site, slowly (and also very quickly) destroying it, removing API access and platforming folks that shouldn't really be platformed.

As [noted in February](https://www.jvt.me/mf2/2023/04/ein9i/), I stopped posting there once [Bridgy](https://brid.gy), the [IndieWeb](https://indieweb.org/why) tool I use for cross-posting from my site to Twitter, stopped working. Although every now and then I've posted a reply to someone - because there are a few folks who unfortunately still use the app - I've very rarely done so, and I've still been liking posts, and I'll always post a copy of the reply/like to my site for my future reference.

However, [with Friday 29th September being the day that Twitter would start training its own AI on its user-generated content](https://www.techradar.com/computing/social-media/twitters-terms-of-service-now-bans-ai-data-scraping-but-does-that-protect-you), I wanted to make sure that all my tweets were deleted so they couldn't train on my account if possible. I'll keep my account there, just with a post to note that I've moved [/elsewhere/](/elsewhere/)

I unfortunately didn't have time to complete it by Friday itself, but have started the process now.

I'd seen a couple of folks I follow on Twitter mention [tweetdelete.net](https://tweetdelete.net/) as a good service, and started investigating it for my own deletions. In the heat of the moment, I purchased the Premium offering:

![Screenshot of the TweetDelete.net app showing that Jamie is on the Premium plan which allows for "delete up all of your tweets after uploading your twitter data file"](https://media.jvt.me/4c9f940323.png)

This gave me what I needed to delete everything, and could take my Twitter data export, which was convenient for me.

I made sure to upload only the `tweets.js`, not any of the other private data in the data dump, and then while starting the deletion process, found it odd when I was told I hadn't connected my account yet:

![A warning in TweetDelete.net showing "Connect your twitter account" button](https://media.jvt.me/b8424f9177.png)

This was especially odd as I'd signed into the app _via_ Twitter. When clicking through the "connect Twitter account" button, I was presented with a familiar OAuth2 login screen:

![A Twitter OAuth2 authorization page, showing that I'm not currently signed in, and need to enter my credentials to allow the app to access my account. However, the URL Is visible, showing that the page is not an official Twitter page, but in fact is on TweetDelete.net's site](https://media.jvt.me/bacd49adec.png)

Or was it that familiar? If you've not spotted the URL,	it's not an official Twitter authorization page, but hosted on TweetDelete.net. Now, if the app had mentioned "we need to perform screen scraping to make this work, we require your credentials, yada yada", then _maybe_ this would be fine, but this is willfully misrepresenting what's going on here, and **definitely** seems like a phishing attempt.

I thought hard about whether I would give in and give my credentials so they could delete my data, but decided against it, for hopefully reasons you can comprehend, dear reader!

Instead, I ended up today hacking around on whether I could do this all myself, as I wanted to try and avoid sharing credentials of mine, especially now the Twitter API is effectively non-functional.

Doing this gave me the opportunity to play with [Playwright](https://playwright.dev/), which I've heard is now a common tool for UI testing.

This brings me to shipping a tool called [tweetus-deletus 🐦🪄💀](https://gitlab.com/tanna.dev/tweetus-deletus), which is a super lightweight Typescript script that drives a Chromium browser to click around in the UI to delete tweets, one-by-one, from a Twitter data export.

Although I missed the deadline of Friday 29th September, I can at least have my tweets hopefully deleted before they have time to train (much?) on the data.

I've processed ~2500/8500 tweets so far, so hopefully should be all gone by the morning. It's sad to be saying goodbye to what was a great way to interact with so many folks. Thanks for the memories, and the trash fire.
