---
layout: post
title: Hackference 2017
description: My summary of the Hackference 2017 conference and hackathon.
categories: events
tags: events conference hackathon
---
## An Overview

For the first time in a number of years attending [Hackference][hackference]'s awesome hackathon, I was able to make it to the conference portion of the event. I had an amazing first time and both learned a lot and also met a number of really awesome people.

This also happened to be the year that I was invited to speak - I was covering [Chef: Infrastructure as Cake][chef-talk], a talk which I have __done__ a couple of times internally at Capital One, but had not yet done it externally. Additionally, it was the first time that I'd been speaking to a group of ~50 people! It was a really great experience, and I was very pleasantly surprised to find that my nerves weren't too overwhelming.

I was truly humbled to be a part of the event as a speaker - there were some really distinguished names I was speaking with, and it was a real honour to be one of them!

## The Conference

There were some really awesome talks here! I've documented each of the talks I attended, in chronological order, and am looking at [follow-up articles][milestone-hackference] for a few of the talks that I had some extra content and thoughts for on top of.

### So I heard you like engineering.. - Jonathan Kingsley

Jonathan spoke about the impending doom of the insecurity of tech everywhere, including how he worked on making his drone perform a flip when he whistled. It was a great start to the day, thinking about the sorry state of the world we're living in.

### Infrastructure as Cake - Testing Your Configuration Management in the Kitchen, with Sprinkles and Love - Jamie Tanna

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> digging into Chef and writing cookbooks, and what pains it can save you! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/Ec53ym97BS">pic.twitter.com/Ec53ym97BS</a></p>&mdash; Jess West (@jessicaewest) <a href="https://twitter.com/jessicaewest/status/921317470375497728?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

My talk was about why Configuration Management should be used, and how using Chef can allow you to fully test it and build it in the correct way.

Although I'd done variations on this talk a couple of times previously at Capital One, this was the first time I had done the talk externally. I felt the talk went well, and gave a good _taste_ for what Chef and Configuration Management can do for you.

I'd also had a few engagements post-talk regarding the best ways to use Chef, including how to build it into your pipelines, for which I was able to share some insight from my previous work with it.

The Reveal.JS slides for my talk can be found served on [GitLab pages][chef-talk-slides].

### Hardware Hacking for JavaScript Developers - Tim Perry

[Tim][tim-perry] showed us during his talk how easy it can be to work with hardware hacking using JavaScript, proving it very aptly by literally programming his own slide clicker before our eyes.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Just watched <a href="https://twitter.com/pimterry?ref_src=twsrc%5Etfw">@pimterry</a> build a clicker for his talk, at the start of his talk, in 35 lines of JS... Only at <a href="https://twitter.com/hashtag/Hackference?src=hash&amp;ref_src=twsrc%5Etfw">#Hackference</a>🎉</p>&mdash; Tom Goodman (@TauOmicronMu) <a href="https://twitter.com/TauOmicronMu/status/921331076970270721?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

He showed us how you can control multiple USB cameras over wifi in less than a screen of code, using the [Johnny Five][johnny-five] framework.

Tim was a great speaker, and both his passion and knowledge came across really well.

Tim also discussed [Resin][resin], the company he works for, and their approach to make it easy to deploy applications to physical hardware, removing the need for burning SD cards and cross compiling code. The heavy work is taken by them, where they build and deploy the applications for you, using a custom Linux distribution that uses Docker to run applications.

Slides: [Slideshare][tim-slides]

### How to build a website that will (eventually) work on Mars? - Slobodan Stojanović

Slobodan had an interesting (and fundamentally important) take on the move to our expansion to Mars - how are we going to deal with the high latency of Earth-Mars communication until AWS launches `mars-west-1`?

There are some great points about how we need to optimise the way we work on poor network connectivity, which had me thinking about how trying to view internet in a rural setting is very painful, let alone when it could take 22 minutes for light to travel between the planets (remember that light is much faster than radio or microwaves, so we'd have even more latency there).

I want to [follow this up later][slobodan-article-issue] as there were some great points here.

Slides: [Slideshare][slobodan-slides]

### Code is not only for computers, but also for humans - Parham Doustdar

[Parham][parham] raised a number of important points about building software, all centred around the fact that software is a human-centric job.

Yes, the code we write is performed by a machine, but as the famous saying goes - code is read more times than it's written.

Much like [Coding For Violent Psychopaths][coding-for-violent-psychopaths] (via [Code for the Maintainer][code-for-the-maintainer]), Parham's talk revolved around the theme of:

>  Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.

Along these lines, Parham started the talk off with how we would _interact_ with someone who wrote the code that we've just found is poorly documented, and went through to discussing the ways in which we should be **??**.

Parham had some really interesting points that I'd like to add some extra commentary to in a [follow-up article][parham-article-issue].

### Building a Serverless Data Pipeline - Lorna Mitchell

[Lorna][lorna] took us through the process of creating a Serverless pipeline to help the team track questions on StackOverflow about IBM CloudAnt, and determine whether the team had replied. The idea behind the application was to have a dashboard that would have a list of questions about CloudAnt that appeared on StackOverflow and for the team to be able to self-organise and ensure that answers are provided, but also that there are not duplicate responses.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/lornajane?ref_src=twsrc%5Etfw">@lornajane</a> explained a concept that I had hardly a clue about, now I fully understand. Brilliant talk. Serverless is useful! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/RSdT0nCh4F">pic.twitter.com/RSdT0nCh4F</a></p>&mdash; Bevis (@bevishalperry) <a href="https://twitter.com/bevishalperry/status/921384146798305280?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">I&#39;m sold on Serverless and CouchDB great talk by <a href="https://twitter.com/lornajane?ref_src=twsrc%5Etfw">@lornajane</a>  <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://twitter.com/hashtag/attractedToDatabases?src=hash&amp;ref_src=twsrc%5Etfw">#attractedToDatabases</a> <a href="https://t.co/TS5gj8ZvJP">pic.twitter.com/TS5gj8ZvJP</a></p>&mdash; Anna (@anna_hax) <a href="https://twitter.com/anna_hax/status/921384434913472514?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

This was also my first introduction to IBM Cloud and was very interesting seeing that [Cloud Functions][ibm-cloud-functions], their Serverless offering, was running on the [Apache OpenWhisk][apache-openwhisk] Open Source project. OpenWhisk boasted an easy way to get started and test out your functions, and seemed to have some good tooling.

I'll cover this in a [follow-up article][lorna-article-issue] as it was a great showcase for Serverless and how it can be used in a really simple way, being one of the first real explanations I've had done well.

Slides: [SpeakerDeck][lorna-slides]

### JavaScript - the exotic parts: Workers, WebGL and Web Assembly - Martin Splitt

Although not working on any front-end Javascript myself, I have been **?exposed past?**.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">This is speaking my language, JavaScript image analysis and why its so slow without web workers and webGL! <a href="https://twitter.com/g33konaut?ref_src=twsrc%5Etfw">@g33konaut</a> <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/SzOyfgSJAy">pic.twitter.com/SzOyfgSJAy</a></p>&mdash; Bevis (@bevishalperry) <a href="https://twitter.com/bevishalperry/status/921395202417463297?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

Martin's talk was a big eye-opener into how the usage of Web Workers could provide drastic speed increases, and how the further usage of Web Assembly would increase that gain.

### Privacy could be the next big thing - Stuart Langridge

Stuart's talk was concerned with reminding everyone of just how much data exists about us, and can be summed up in the contents of the following two tweets:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Privacy could be the next big thing: &quot;This is the first century that erasing history became more important than makinging it&quot; <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a></p>&mdash; Michiel Roos (@Michiel_R) <a href="https://twitter.com/Michiel_R/status/921402080853659649?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Superb definition of &#39;creepy&#39; analytics by <a href="https://twitter.com/sil?ref_src=twsrc%5Etfw">@sil</a> - &quot;data collection is creepy when you use it to deduce things you weren&#39;t told and shouldn&#39;t know&quot; <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/RSsRuKgYY7">pic.twitter.com/RSsRuKgYY7</a></p>&mdash; Tim Perry (@pimterry) <a href="https://twitter.com/pimterry/status/921402198495555584?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

Although I'm someone who is increasingly careful about their personal data; creating a new email on my personal domain for each service I sign up to so I can determine if I receive spam on this unique email, helping me track down services sharing my contact details, through to using [Firefox Multi-Account Containers][firefox-containers] to limit the leakage of cookies and identifiable data across browsing sessions.

However, Stuart's main point was that we have steps in which we can limit the data that is collected about us in the future, however, there's often a difficult, if not impossible, route to scrubbing data that _already exists_ on us, and how that data can be used to **predict future behaviours**.

Additionally, there's cases where behaviours or extrapolations can be made _without_ data being provided by you, but through mining of similar **demographics**.

**http://www.businessinsider.com/the-incredible-story-of-how-target-exposed-a-teen-girls-pregnancy-2012-2?IR=T**


Only the other day, I received this exchaneg on LinkedIn, where a recruiter had used some tool to scrape my personal data and send me a direct email to a personal address:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">On the topic of recruiters at <a href="https://twitter.com/hashtag/technott?src=hash&amp;ref_src=twsrc%5Etfw">#technott</a>, watch out for recruiters like this <a href="https://twitter.com/hashtag/privacy?src=hash&amp;ref_src=twsrc%5Etfw">#privacy</a> <a href="https://twitter.com/hashtag/Recruiters?src=hash&amp;ref_src=twsrc%5Etfw">#Recruiters</a> <a href="https://t.co/mA36Zf8ZOd">pic.twitter.com/mA36Zf8ZOd</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/936336908615061504?ref_src=twsrc%5Etfw">30 November 2017</a></blockquote>

This is due to at some point, somewhere on the internet, my personal email address was exposed.

**Having** to wonder where your data ends up is **??**.





<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">.<a href="https://twitter.com/sil?ref_src=twsrc%5Etfw">@sil</a> &quot;I like putting the power of our data in our hands&quot; . YES! <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a></p>&mdash; Bevis (@bevishalperry) <a href="https://twitter.com/bevishalperry/status/921409312974569473?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">What I&#39;m hearing is &quot;who wants free chocolate?&quot; <a href="https://twitter.com/sil?ref_src=twsrc%5Etfw">@sil</a> <a href="https://twitter.com/hashtag/hackference?src=hash&amp;ref_src=twsrc%5Etfw">#hackference</a> <a href="https://t.co/W9RPfg9dRT">pic.twitter.com/W9RPfg9dRT</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/921403960497451009?ref_src=twsrc%5Etfw">20 October 2017</a></blockquote>


https://tosdr.org/

https://twitter.com/pimterry/status/921403371860439041
https://twitter.com/pimterry/status/921402198495555584
https://twitter.com/Michiel_R/status/921402080853659649
https://twitter.com/bevishalperry/status/921400192447983617

## The Hackathon

[Anna][anna] and I build a hack to help automate the process of freelance web developers putting changes live once receiving full payment.

![Be Paid to Get Deployed](./assets/img/projects/be-paid-to-get-deployed.png)

We built this using Flask and the QuickBooks, Starling and GitHub Status APIs, and I've documented the project more on [its project page](/projects/be-paid-to-get-deployed/).

From Intuit, we won **?** and from GitHub we won a choice of swag - we both got a [GitHub hoodie][github-hoodie] and [GitHub Contributions Mug][github-contribution-mug].

[milestone-hackference]: https://gitlab.com/jamietanna/jvt.me/milestones/10
[hackference]: https://2017.hackference.co.uk

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

[firefox-containers]: https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/

[anna]: https://twitter.com/anna_hax

[github-hoodie]: https://github.myshopify.com/collections/all-products/products/invertocat-hoodie
[github-contribution-mug]: https://github.myshopify.com/collections/all-products/products/contribution-mug
