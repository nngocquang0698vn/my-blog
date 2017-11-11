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

## Talks

There were some really awesome talks here! I've documented each of the talks I attended, in chronological order, and am looking at [follow-up articles][milestone-hackference] for a few of the talks that I had some extra content and thoughts for on top of.

### So I heard you like engineering.. - Jonathan Kingsley

Jonathan spoke about the impending doom of the insecurity of tech everywhere, including how he worked on making his drone perform a flip when he whistled.

**TODO: add more!**

### Infrastructure as Cake - Testing Your Configuration Management in the Kitchen, with Sprinkles and Love - Jamie Tanna

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> digging into Chef and writing cookbooks, and what pains it can save you! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/Ec53ym97BS">pic.twitter.com/Ec53ym97BS</a></p>&mdash; Jess West (@jessicaewest) <a href="https://twitter.com/jessicaewest/status/921317470375497728?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

Although I'd done variations on this talk a couple of times previously at Capital One, this was the first time I had done the talk externally. I felt the talk went well, and gave a good _taste_ for what Chef and Configuration Management can do for you.

I'd also had a few engagements post-talk regarding the best ways to use Chef, including how to build it into your pipelines, for which I was able to share some insight from my previous work with it.

The Reveal.JS slides for my talk can be found served on [GitLab pages][chef-talk-slides].

### Hardware Hacking for JavaScript Developers - Tim Perry

[Tim][tim-perry] showed us during his talk how easy it can be to work with hardware hacking using JavaScript, proving it very aptly by literally programming his own slide clicker before our eyes.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Just watched <a href="https://twitter.com/pimterry?ref_src=twsrc%5Etfw">@pimterry</a> build a clicker for his talk, at the start of his talk, in 35 lines of JS... Only at <a href="https://twitter.com/hashtag/Hackference?src=hash&amp;ref_src=twsrc%5Etfw">#Hackference</a>🎉</p>&mdash; Tom Goodman (@TauOmicronMu) <a href="https://twitter.com/TauOmicronMu/status/921331076970270721?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

He showed us how you can control multiple USB cameras over wifi in less than a screen of code, using the [Johnny Five][johnny-five] framework.

Tim was a great speaker, and both his passion and knowledge came across really well.

Tim also discussed [Resin][resin], the company he works for, and their approach to make it easy to deploy applications to physical hardware, removing the need for burning SD cards, and cross compiling all your code - but instead taking the heavy work themselves, and deploying applications onto a custom Linux distribution that uses Docker to run applications.

Slides: [Slideshare][tim-slides]

### How to build a website that will (eventually) work on Mars? - Slobodan Stojanović

Slobodan had an interesting (and fundamentally important) take on the move to our expansion to Mars - how are we going to deal with the high latency of Earth-Mars communication until AWS launches `mars-west-1`?

There are some great points about how we need to optimise the way we work on poor network connectivity, which had me thinking about how trying to view internet in a rural setting is very painful, let alone when it could take 22 minutes for light to travel between the planets (remember that light is much faster than radio or microwaves, so we'd have even more latency there).

I'll cover this in a [follow-up article][slobodan-article-issue], as there are a number of interesting points I'd quite like to cover in more depth.

Slides: [Slideshare][slobodan-slides]

### Code is not only for computers, but also for humans - Parham Doustdar

[Parham][parham] raised a number of important points about building software, all centred around the fact that software is a human-centric job.

Yes, the code we write is performed by a machine, but as the famous saying goes - code is read more times than it's written.

Much like [Coding For Violent Psychopaths][coding-for-violent-psychopaths] (via [Code for the Maintainer][code-for-the-maintainer]), Parham's talk revolved around the theme of:

>  Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.

Along these lines, Parham started the talk off with how we would _interact_ with someone who wrote the code that we've just found is poorly documented, and went through to discussing the ways in which we should be **??**.

I'll cover this in a [follow-up article][parham-article-issue], as there were some great points Parham raised that I'd like to add some extra commentary to.

### Building a Serverless Data Pipeline - Lorna Mitchell


https://twitter.com/anna_hax/status/921384434913472514
https://twitter.com/bevishalperry/status/921384146798305280
https://twitter.com/sil/status/921375722463268864

[Lorna][lorna] took us through the process of creating a Serverless pipeline to help the team track questions on StackOverflow about IBM CloudAnt, and determine whether the team had replied. The idea behind the application was to have a dashboard that would have a list of questions about CloudAnt that appeared on StackOverflow and for the team to be able to self-organise and ensure that answers are provided, but also that there are not duplicate responses.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/lornajane?ref_src=twsrc%5Etfw">@lornajane</a> explained a concept that I had hardly a clue about, now I fully understand. Brilliant talk. Serverless is useful! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/RSdT0nCh4F">pic.twitter.com/RSdT0nCh4F</a></p>&mdash; Bevis (@bevishalperry) <a href="https://twitter.com/bevishalperry/status/921384146798305280?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

This was also my first introduction to IBM Cloud and was very interesting seeing that the Serverless offering, [Cloud Functions][ibm-cloud-functions] was running an Open Source project, [Apache OpenWhisk][apache-openwhisk], which really boasted an easy way to get started and test out your functions.

I'll cover this in a [follow-up article][lorna-article-issue] as it was a great showcase for Serverless and how it can be used in a really simple way, being one of the first real explanations I've had done well.

Slides: [SpeakerDeck][lorna-slides]

### JavaScript - the exotic parts: Workers, WebGL and Web Assembly - Martin Splitt

https://twitter.com/bevishalperry/status/921395202417463297
https://twitter.com/slsoftworks/status/921439171209846785


### Privacy could be the next big thing - Stuart Langridge

Stuart's talk was concerned with reminding everyone of how

https://twitter.com/JamieTanna/status/921408393532858375
https://twitter.com/bevishalperry/status/921409312974569473
https://twitter.com/JamieTanna/status/921407957274955776
https://twitter.com/JamieTanna/status/921403960497451009
https://twitter.com/pimterry/status/921403371860439041
https://twitter.com/pimterry/status/921402198495555584
https://twitter.com/Michiel_R/status/921402080853659649
https://twitter.com/bevishalperry/status/921400192447983617

[milestone-hackference]: https://gitlab.com/jamietanna/jvt.me/milestones/10


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
[coding-for-violent-psychopaths]: https://blog.codinghorror.com/coding-for-violent-psychopaths/
[code-for-the-maintainer]: http://wiki.c2.com/?CodeForTheMaintainer

[lorna]: https://twitter.com/lornajane
[lorna-article-issue]: https://gitlab.com/jamietanna/jvt.me/issues/189
[lorna-slides]: https://speakerdeck.com/lornajane/building-a-serverless-data-pipeline
[ibm-cloud-functions]: https://www.ibm.com/cloud/functions
[apache-openwhisk]: https://openwhisk.apache.org/
