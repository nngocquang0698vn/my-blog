---
title: "Reader Mail: Webmention Spam"
description: "Replying publicly to an email about my continual webmention sending."
tags:
- www.jvt.me
- reader-mail
- webmention
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-30T21:13:24+0000
slug: "reader-mail-webmention-spam"
---
I received an email yesterday from <span class="h-card"><a class="u-url" href="https://eli.li/">Eli Mellen</a></span>, and with Eli's consent thought I am replying publicly.

The email in question:

> Hey there!

> No worries about this, but I wanted to let you know that something may be going awry with your website's implementation of webmentions -- you 'liked' one of my posts a while ago (https://eli.li/entry/20180314144847) and I've received 1 or 2 webmentions every day since. No big deal, but wanted to let you know in case that wasn't intentional.

> All the best,
> Eli

My response:

> Hey Eli!

> Thanks for getting in touch.

> Yes this is expected, but thanks for letting me know. Is this an issue for you? Ie are you getting a push notification each time and I need to stop that?

> I remember having this conversation at the time I released my functionality and Aaron Parecki asked me to limit the number I sent to IndieWeb.org as it wasn't being handled right, but that technically I wasn't doing anything wrong as a webmention receiver should handle repeated notifications and de-duplicate them as required.

> I do have some work on my backlog to send them more intelligently but I've not got round to that yet.

> But as I say, if it is causing an issue for you please let me know.

> Would you be OK me publishing both your email and my reply on my website, so others have a record of it if they want to ask the same thing?

> Best,
> Jamie

And Eli's final reply:

> Groovy! No issue on my end. I only noticed because I get a push with every one. I can mute those pretty easily, though.

> I think the worry, as Aaron pointed out, is that a high volume of webmentions sent in this manner could quickly turn into something like a DDOS attack by accident. The volume is fairly low across the indieweb, but central hubs -- sites with more traffic -- could be susceptible.

If you're seeing lots of webmentions from me, I'm sorry but until [I have put in the work to intelligently send the webmentions](https://gitlab.com/jamietanna/www-api/issues/63), this will happen for a while! It's been on my TODO list for a while, it turns out I hadn't raised the issue yet.
