---
layout: post
title: Hackference 2017 - The Conference
description: My summary of the Hackference 2017 conference.
categories: events
tags: events conference hackathon
---

For the first time in a number of years attending Hackference, I was able to make it to the conference portion of the event.

I had an amazing first time, __??__.

This also happened to be the year that I was invited to speak - I was covering [Chef: Infrastructure as Cake][chef-talk], a talk which I have __done__ a couple of times internally at Capital One, but had not yet done it externally.

Additionally, it was the first time that I'd been speaking to a group of ~40 people!


Humbled to be speaking with a number of amazing and interesting speakers.

## So I heard you like engineering.. - Jonathan Kingsley

Jonathan's talk was concerned with how

- insecurity of tech
- IoT is easily hackable

## Infrastructure as Cake - Testing Your Configuration Management in the Kitchen, with Sprinkles and Love

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> digging into Chef and writing cookbooks, and what pains it can save you! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/Ec53ym97BS">pic.twitter.com/Ec53ym97BS</a></p>&mdash; Jess Not Spooky West (@jessicaewest) <a href="https://twitter.com/jessicaewest/status/921317470375497728?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

As mentioned, this was a talk I'd done previously, and had practiced the previous day at work, which had given me a lot more confidence, and a few general tips for making the content better.

I'd had a few engagements post-talk regarding __??__.

The [Reveal.JS][revealjs] slides for my talk can be found served on [GitLab pages][chef-talk-slides].

## Hardware Hacking for JavaScript Developers - Tim Perry

[Tim][tim-perry] showed us during his talk how easy it can be to work with hardware hacking using JavaScript, proving it very aptly by literally programming his own slide clicker before our eyes.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Just watched <a href="https://twitter.com/pimterry?ref_src=twsrc%5Etfw">@pimterry</a> build a clicker for his talk, at the start of his talk, in 35 lines of JS... Only at <a href="https://twitter.com/hashtag/Hackference?src=hash&amp;ref_src=twsrc%5Etfw">#Hackference</a>🎉</p>&mdash; Tom Goodman (@TauOmicronMu) <a href="https://twitter.com/TauOmicronMu/status/921331076970270721?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

He showed us how you can control multiple USB cameras over wifi in less than a screen of code, using the [Johnny Five][johnny-five] framework.

Tim was a great speaker, and both his passion and knowledge came across really well.

Tim also discussed [Resin][resin], the company he works for, and their approach to make it easy to deploy applications to physical hardware, removing the need for burning SD cards, and cross compiling all your code - but instead taking the heavy work themselves, and deploying applications onto a custom Linux distribution that uses Docker to run applications.

Slides: [Slideshare][tim-slides]

## How to build a website that will (eventually) work on Mars? - Slobodan Stojanović

Slobodan had an interesting (and fundamentally important) take on the move to our expansion to Mars - how are we going to deal with the high latency of Earth-Mars communication until AWS launches `mars-west-1`?

There are some great points about how we need to optimise the way we work on poor network connectivity, which had me thinking about how trying to view internet in a rural setting is very painful, let alone when it could take 22 minutes for light to travel between the planets (remember that light is much faster than radio or microwaves, so we'd have even more latency there).

I'll cover this in a [follow-up article][slobodan-article-issue], as there are a number of interesting points I'd quite like to cover in more depth.

Slides: [Slideshare][slobodan-slides]

## Code is not only for computers, but also for humans - Parham Doustdar

[Parham][parham] raised a number of important points about building software, all centred around the fact that software is a human-centric job. Yes, the code we write is performed by a machine, but as the famous saying goes - code is read more times than it's written.

His talk started with us thinking about what we'd do to someone **??**.

Much like https://blog.codinghorror.com/coding-for-violent-psychopaths/ via http://wiki.c2.com/?CodeForTheMaintainer

>  Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.

I'll be following up with [an article covering Parham's talk][parham-article-issue] in more detail.

## Building a Serverless Data Pipeline - Lorna Mitchell

[Lorna][lorna] described a

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">I&#39;m sold on Serverless and CouchDB great talk by <a href="https://twitter.com/lornajane?ref_src=twsrc%5Etfw">@lornajane</a>  <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://twitter.com/hashtag/attractedToDatabases?src=hash&amp;ref_src=twsrc%5Etfw">#attractedToDatabases</a> <a href="https://t.co/TS5gj8ZvJP">pic.twitter.com/TS5gj8ZvJP</a></p>&mdash; Anna (@anna_hax) <a href="https://twitter.com/anna_hax/status/921384434913472514?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

- StackOverflow
- alerted when new pop up
- into dashboard
- share when people are looking into it
- don't need a heavy server always running - can check it every `x` mins

I'll be following up with [an article covering Lorna's talk][lorna-article-issue] in more detail.

## JavaScript - the exotic parts: Workers, WebGL and Web Assembly - Martin Splitt

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">This is speaking my language, JavaScript image analysis and why its so slow without web workers and webGL! <a href="https://twitter.com/g33konaut?ref_src=twsrc%5Etfw">@g33konaut</a> <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/SzOyfgSJAy">pic.twitter.com/SzOyfgSJAy</a></p>&mdash; Bevis in TheOldSmoke (@bevishalperry) <a href="https://twitter.com/bevishalperry/status/921395202417463297?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

## Privacy could be the next big thing - Stuart Langridge

Stuart's talk concerned itself with how **??**.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Superb definition of &#39;creepy&#39; analytics by <a href="https://twitter.com/sil?ref_src=twsrc%5Etfw">@sil</a> - &quot;data collection is creepy when you use it to deduce things you weren&#39;t told and shouldn&#39;t know&quot; <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/RSsRuKgYY7">pic.twitter.com/RSsRuKgYY7</a></p>&mdash; Tim Perry (@pimterry) <a href="https://twitter.com/pimterry/status/921402198495555584?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">What I&#39;m hearing is &quot;who wants free chocolate?&quot; <a href="https://twitter.com/sil?ref_src=twsrc%5Etfw">@sil</a> <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/W9RPfg9dRT">pic.twitter.com/W9RPfg9dRT</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/921403960497451009?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

- speaking at https://2017.hackference.co.uk/
- first time attending conference
- unfortunately Sam not talking
- Preparing for talk during JavaScript Browser Bits
- tosdr.org (like tldr)


Talks:
- `So I heard you like engineering..`
- (Break)


[revealjs]: https://github.com/hakimel/reveal.js

[chef-talk]: /talks/chef-infrastructure-as-cake/
[chef-talk-slides]: http://jamietanna.gitlab.io/talks/chef-infrastructure-as-cake/
[tim-perry]: https://twitter.com/pimterry
[johnny-five]: https://www.npmjs.com/package/johnny-five
[resin]: https://resin.io

[tim-slides]: https://speakerdeck.com/pimterry/hardware-hacking-for-js-developers
[slobodan-slides]: https://speakerdeck.com/slobodan/how-to-build-a-website-that-will-eventually-work-on-mars-hackference-2017
[slobodan-article-issue]: https://gitlab.com/jamietanna/jvt.me/issues/190

[parham]: https://twitter.com/PD90
[parham-article-issue]: https://gitlab.com/jamietanna/jvt.me/issues/191

[lorna]: https://twitter.com/lornajane
[lorna-article-issue]: https://gitlab.com/jamietanna/jvt.me/issues/189

