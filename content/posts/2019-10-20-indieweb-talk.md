---
title: "The IndieWeb Movement: Owning Your Data and Being the Change You Want to See in the Web"
description: "A look at what the IndieWeb is, why you should care, and how to get started with it."
tags:
- indieweb
- www.jvt.me
- micropub
- microsub
- microformats
- webmention
- public-speaking
- oggcamp
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-20T19:29:23+0100
slug: "indieweb-talk"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
---
The below is a transcript of the talk [_The IndieWeb Movement: Owning Your Data and Being the Change You Want to See in the Web_](/talks/indieweb/) that I gave this afternoon at [OggCamp 2019](https://oggcamp.com).

I've taken the advice given out in [_DDD East Midlands: Speaker Workshop_]({{< ref "2019-07-01-dddem-speaker-workshop" >}}) and decided to write out a transcript of the talk, as a way to drive out the talk's content, as well as give me a good blog post, too! What follows is fairly similar to the words I said live on stage, but includes a bit more detail that I'd not gone into or was a bit rushed to say!

Thanks again to those who came to the talk, I appreciate it and hope that it helped convince you to investigate the IndieWeb for yourself.

# `whoami`

Hello, my name is Jamie Tanna and my URL is `https://www.jvt.me` and I am [@JamieTanna on Twitter](https://twitter.com/jamietanna), both of which will be shown on each slide.

Please feel free to send me interactions on social media through the talk - I'd appreciate if you mentioned me or use the hashtag `#IndieWeb`.

I mentioned that my URL is  `https://www.jvt.me`, but what do I actually have on there? Let's have a look at the homepage:

(image was displayed, but you can visit [the homepage](/))

As we can see there are a few things here. We've got different types of content such as replies and bookmarks, as well as blog posts. I use my site for publishing content of different types, and want to publish more and use my site as the source of truth for all my content.

# Indie what now?

Before we start, I want a little audience participation. This will be the only part in this talk, so don't worry too much:

- raise your hands if you post content on Twitter/Medium/Dev.to/etc
- raise your hands if you have a personal website
- raise your hands if you post content on your personal website
- raise your hands if you've heard about the IndieWeb before / know what it's about

Ok, with that in mind, let's start off on the [why](https://indieweb.org/why) by reflecting on the abstract of this talk:

> We strive for Free and Open Source software in the world, on mobile, desktop and server. But what about the Web? The IndieWeb is all about taking control, owning your data, and scratching your itches through Open Source and Standards. We're working to take back the Web, and you can, too.

We'll dive a little deeper into what the IndieWeb stands for, and look at how you can get involved too so you can start to own your identity and data.

## Ownership

I would say that the easiest way to describe the IndieWeb is in relation to ownership. In essence, the IndieWeb is all about ownership of your identity, which is done through the ownership of a personal domain, which likely has a website on it.

With this domain, you can point it to Medium, Tumble, or your own site. But the constant there is that it'll sit under your domain and folks can come back and see all your latest content, regardless of what platform it's pointing to.

A more common trend is that you would go a step further to own your data; be that your thoughts, your workout data, or your art. By having everything centred around yourself, your own website, and maybe even your own servers, you're definitely the one in control of what is done with it.

Although you can use other sites, such as Twitter or Medium, the idea is that you post to your own website first, and then syndicate to those other sites in a way that there are links back to the original content, so folks can discover your original site and everything on it.

## What does Indie in IndieWeb stand for?

As the name suggests, the "Web" refers to the World Wide Web, and the "Indie" is for Independent. It's all about showing that we're something different to the "mainstream" Web and something separate from the silos.

## To break free from silos

The IndieWeb is a very strong contender to help us get away from the [silos](https://indieweb.org/silo). These silos are the walled gardens of Twitter, Medium, Dev.To and are companies that however open they want to be, will unfortunately be tempted by the ability to make more money and sucker their audience in further.

These sites (almost certainly) own the content you publish there, but even if not, you're posting to `twitter.com/@JamieTanna`, not to `www.jvt.me`, which means Twitter has the domain name recognition and the brand knowledge, not you.

As <span class="h-card"><a class="u-url" href="http://bradfrost.com">Brad Frost</a></span> <a href="http://bradfrost.com/blog/post/write-on-your-own-website/">puts it really nicely</a>:

> Writing on your own website associates your thoughts and ideas with you as a person. Having a distinct website design helps strengthen that association. Writing for another publication you get a little circular avatar at the beginning of the post and a brief bio at the end of the post, and that’s about it. People will remember the publication, but probably not your name.

On ownership, there's always the risk of a company's acquisition or leadership change drastically affecting they way they approach things,
such as [Yahoo Groups' user content is being deleted 3 months from announcement](https://uk.pcmag.com/news/123100/still-use-yahoo-groups-content-will-be-deleted-on-dec-14), [Tumblr's recent-ish ban on pornography](https://www.washingtonpost.com/business/2018/12/04/tumblrs-nudity-crackdown-means-pornography-will-be-harder-find-its-platform-than-nazi-propaganda/) or [500px no longer allowing Creative Commons licensing](https://www.theverge.com/2018/7/1/17521456/500px-marketplace-creative-commons-getty-images-visual-china-group-photography-open-access). If you're creating all this content, why should you let some company somewhere own it?

No matter how open a platform seems, it is unfortunately quite likely that the company will start to lock things down and inevitably become user hostile. Because, at the end of the day, a platform wants you to spend all your time there, so they can i.e. sell you ads or learn more about you, so they can sell your browsing habits to advertisers. It's a cynical way to look at the Web, I know, but is getting more and more common.

And why would you be forced to use a platform that has poor accessibility for the folks that really need it, or using infuriating User Experience patterns? If you break free from the silos and publish on your own website, you get that control back. Yes, you may build an equally inaccessible site, but that's more under your control and you can work ot make it better in the future.

## Be Your Own Platform

Instead of relying on another platform to host your thoughts, with their specific branding guidelines and restrictions, you should be the platform you want to be. By making the social network revolve around your site, you're keeping it within your grasp and built for the things you want.

And one of the best benefits of owning the platform is being able to modify it! If you're a bit more technical you can be the one to tweak the code or the styles, and mould it to how you want it to work. If you're not as technical, you can ask someone else (such as the software's maintainer) or other folks in the community to build or tweak the thing for you.

We don't want to keep people in the mindset of accepting things for what they are. The great things about Free and Open Source software, and things like the Linux-based Operating Systems are that it enables greater choice, and that flexibility to tweak what you want. Why shouldn't you get to have an edit button in the UI? Or allowing third-party applications to integrate with the platform?

## A Political Statement

At the end of the day, this is a political statement, saying "we don't trust / want your platform", and should be treated as such.

# Principles

The IndieWeb is built upon a set of [principles](https://indieweb.org/principles) which guide all work under a common mindset.

## Own Your Data

One of the most important principles of the IndieWeb is that you __own your own data__, which we've already spoken about. By integrating things into your personal website / web applications, this means that you're making sure that you really own it, rather than just happening to have access to it, as it currently is with other platforms.

I would say that the biggest benefit I've started seeing from owning my data is how I keep a track of what I'm RSVPing to. I attend a lot of tech meetups and a few conferences throughout the year, and up until owning them I'd been [using the Meetup.com's iCalendar feed with my Google Calendar]({{< ref "2019-07-27-meetupcom-calendar" >}}).

But now have I started to own these RSVPs on my website, I had a thought - what if I created a calendar feed from that? This means I now have a calendar that anyone can subscribe to, which shows which events I'm attending. This is super cool, so I can share it with my colleagues, family, or the wide world who want to discover more events.

With these capabilities, the sky really is the limit - I've recently started to [own my step count data](/kind/steps/) and I've not yet decided on what's next, but I think it'll revolve around being able to publish media to the site, and then possibly add location-based check-ins.

Note that this data doesn't necessarily need to be public, especially as it could include sensitive info like accurate location data or your health metrics.

## Use & Publish Visible Data

Although we want to have these super cool interoperable websites that can interact with each other in wild and wonderful automated ways, we need to be careful to remember that it's not the first user of our sites.

Humans are the consumers of our websites, and need to read and understand our content, and it can't be made more difficult because we want to make it easier for computers to read.

Using the [Microformats2 standard](https://indieweb.org/microformats2) for data markup allows writing of human-readable HTML, while also having computer-readable markup.

## Make What You Need / Scratch Your Itch

This next principle has two parts to it.

Firstly, don't try and make your software work for everyone, or just for a specific set of people you think may be interested. Make it for __you__.

By making it generic and possible for others to work with it, you'll make tradeoffs that may make things worse for your own usage, or may even design for an imaginary user that may not even exist, or build a system that with 17 different configuration items you could have a completely different system. Be selfish and make it more useful for yourself.

Next, you need to scratch your own itch. If there's something you really want to do, do it!

For instance, I run the [Homebrew Website Club in Nottingham](/events/homebrew-website-club-nottingham/), which is a usergroup of folks who want to work on their websites, and meet every other Wednesday. One common ask from attendees was "can we please get a reminder before it's the next one", or can we have a calendar sent out? But I went one better. I decided to scratch my itch and [built the capability for events to have calendar feeds into my site]({{< ref "2019-05-22-ical-events-hugo" >}}), after which attendees could just simply add that to their calendar. As a follow-up piece of work, I also added the ability to [add a single instance of an event to your calendarvia iCalendar / Google Calendar]({{< ref "2019-09-02-calendar-single-event" >}}).

Once I started collecting my RSVPs on my website, I found that I didn't want to keep relying on [Meetup's built in calendar support]({{< ref "2019-07-27-meetupcom-calendar" >}}), as it only showed _upcoming_ events, not previous ones. This meant it was less easy to look back in the calendar and see how busy I was for a given week, or try and find what great meetups I'd been to in a month. But at the same time, I also wanted to be able to keep an eye on what non-Meetup events I was attending. So again, [I went ahead and built a calendar for RSVPs on my site]({{< ref "2019-07-27-rsvp-calendar" >}}), including location data.

## Use What You Make / Dogfood

Although it's great to be publishing all this software and cool new specifications, why would someone else want to use it, if you've not battle tested it? You should be using it as your daily driver, with your bleeding edge personal website, and make sure that it's as good as you say it is!

This helps give others confidence in the stuff you're building, and helps you find out if decisions or assumptions you made while developing it still hold true.

## Document Stuff

By documenting the work you've done, you'll help to share your journey with others, which may inspire them, as well as helping future you remember how you did certain things!

Those who will have visited my site will know that I blog _a lot_, and am a huge fan of [blogumentation - using blog posts as a form of documentation]({{< ref "2017-06-25-blogumentation" >}}). All of my IndieWeb related posts are tagged [IndieWeb](/tags/indieweb), and anything related to changes on my site are tagged [www.jvt.me](/tags/www.jvt.me).

But not only is this a great way to share the cool thing you've just done with the world, it's also a great way to rationalise what you've done. It's a lot like [Rubber Duck Debugging](https://rubberduckdebugging.com/) and I've found has helped picked up issues with thought processes in the past, as well as helping others understand why I've made certain choices!

It can also be a great way to solidify your understanding of a topic by trying to teach it, such as my recent post [_How to RSVP to an Indie Event from your Website_]({{< ref "2019-08-21-rsvp-from-your-website" >}}).

## Share Under a Free/Open Source License

Although not a hard requirement, if you feel comfortable, you should share your software under a Free / Open Source Software license. This will allow others to get using your changes and tooling, or at least learning from what you've done.

However, it can be scary to put your work out in the public and have others use and critique it, so don't feel pressured at all to feel the need to release it!

## UX/design better than technical specs

Instead of poring over specifications for year(s) ahead of them actually reaching a user, who may then tell us how poor a specification is, we prioritise using the tooling first.

This allows us time to see how it looks in use, giving us time to refine the user experience, after which we can then standardise it.

This also means that if there's a case where we're compromising the User Experience for fulfilling the full technical specification, we should look to prioritise the user.

## Modularity

The IndieWeb should be "platform agnostic platforms", so we can swap out pieces of code and parts of the software stack to make it easier to move when there's something new or we just want to try something different.

By having "small pieces loosely joined", more people are able to reuse these tools, plugging them into different tech stacks, and improved over time.

This is very similar to the [Unix Philosophy](http://www.linfo.org/unix_philosophy.html) which says that having lots of tools that do one thing well and can be easily integrated together to fulfill a greater purpose.

## Longevity

A bold statement is that we want the Web to last for many years to come, attempting to build tooling that can still be running in 5, 10, 20 years.

## Plurality

It's common in Free and Open Source communities to hear complaints about too many projects trying to solve the same issue, and that folks from one project should pool resources to better a common platform, rather than have many competing.

This is the exact opposite in the IndieWeb - we absolutely encourage new implementations of tools and projects. We want to have lots of people trying out the specifications to weed out any documentation issues and to have neurodiverse group coming to share their thoughts on implementations. We also want to prevent monocultures to make sure that if i.e. one set of tooling becomes no longer maintained we can still recover.

## Fun

At the same time, it's also about making sure you're enjoying yourself and working on something interesting. The Web used to be a wacky place with GeoCities and MySpace, and we should still be very much pro-experimentation.

## Don't force others to move

Although this isn't necessarily an "official" principle, it's very important.

As a community, we want to move people from silos to the IndieWeb, but we can't force them to do it. It isn't fair, and it will likely put peoples' backs up if you tell folks they need to move to a completely alien technology like RSS or Indie Readers, especially if you start the conversation with:

> To follow my content, you need an Indie Reader, which requires MicroSub, which requires IndieAuth ...

We want to make sure that it's not going to give people any more reason to not switch over, and harm the long-term growth of the IndieWeb (even though we know that right now it's not there yet).

But how can we retain ownership of our data if we still want folks on silos to interact with us? This is where the concept of [_Publish (on your) Own Site, Syndicate Elsewhere (POSSE)_](https://indieweb.org/POSSE) comes in.

This allows you to publish to your website first, then integrate with a service (i.e. [Bridgy](https://brid.gy)) that can publish to the silos on your behalf. You'll likely have a link at the beginning mentioning that it's originally from your site, which means they can discover more content, but it allows them to stay using their existing platform if they want to.

# Building Blocks

There are a few ["building blocks"](https://indieweb.org/Category:building-blocks) that the IndieWeb is built upon:

- Identity: have a personal URL, that leads to some information about you (marked up with Microformats2)
- Posts: _the_ building block for producing content, whether it's a Tweet-sized piece of content, a long-form article, or a reply
- Citability: reduce the character count for your post URLs, so it's easier to put in other forms of communication i.e. Tweets
- Syndication: Publish (on your) Own Site, Syndicate Elsewhere (POSSE), or Publish Elsewhere, Syndicate to Own Site (PESOS)
- Mentions: let others know you've mentioned their content
- Login: use your domain identity as a form of authentication
- Web Actions: provide a better UI/UX for adding a like/reply to content
- Reply Context: show some information for the viewer about what you're replying to
- Link Preview: show more info to any link on the page

# Indie ecosystem

There's a tonne of technologies and standards that make up the Indie ecosystem, which I thought I'd explain a little more about.

## Microformats2

[Microformats2](https://indieweb.org/microformats2) is the successor to [Microformats](https://indieweb.org/microformats2), and is a standard for marking up (semantic) HTML with computer-readable metadata, in the form of CSS classes.

As it's HTML markup, it can be wrapped around your existing HTML in a way that doesn't impact your existing human-readable format.

And because it's HTML that will be rendered in a browser, you can hide the content with CSS, for instance if you don't think a human needs to read all the metadata, but you want a machine to.

For instance, the following markup shows a basic RSVP to an upcoming IndieWeb conference.

```html
<div class="h-entry">
  <span class="p-author h-card">
    <a class="u-url" href="https://www.jvt.me">
      <img class="u-photo" src="https://www.jvt.me/profile.png" alt=""/>
      Jamie Tanna
    </a>
  </span>:
  RSVP <span class="p-rsvp">yes</span>
  to <a href="https://indiewebcamp.nl/" class="u-in-reply-to">IndieWebCamp Amsterdam</a>
</div>
```

For those of you that can't render this in your mind, it could render something like this:

<span>
  <a href="https://www.jvt.me">
    <img style="height: 32px; width: 32px; margin: 0; display: inline-block" src="/img/profile.png" alt="Jamie Tanna's profile image"/>
    Jamie Tanna
  </a>
</span>:
RSVP yes
to <a href="https://indiewebcamp.nl/">IndieWebCamp Amsterdam</a>

We can see that there are some uses of classes to denote meaning to the parser around what type of data is contained within the tag, and that this doesn't look too scary.

## Micropub

[Micropub](https://indieweb.org/Micropub) is a standard API for creating content on a website, which doesn't need to know how the underlying site works.

I have a very specific workflow I want to use when writing long-form articles for my website, which involves a terminal, my Vim setup, and a local Hugo server, as well as utilising Git branching and GitLab Merge Requests.

But this completely falls apart when I want to be able to say that I "like" a post or share a post for my readers, because that flow has quite a time cost to write the JSON file and push it through my workflow. And because this is something I'd want to do quite a few times a day, possibly from a mobile, it's not something that the workflow scales to.

This is also a very specific workflow to how I've got my own site set up, This is also a very specific workflow to how I've got my site set up, but isn't going to be the same for someone using WordPress.

So this is where Micropub comes in. It provides a specification for a create/read/update/delete flow for content on a website, which works independently to the underlying system used in the website.

So this would allow me to move from my static Hugo website to a WordPress site, and still use the same Micropub client. By this being an open standard, there are lots of editors that we can use - across mobile and web-based applications.

## Microsub

[Microsub](https://indieweb.org/Microsub) is another standard, but this time makes it possible to follow others' content - think of it as the RSS Reader of old (I use this semi-ironically, because RSS readers are still a thing that is being used).

However, unlike existing RSS readers, this supports other forms of content, such as [JSONFeed](https://indieweb.org/jsonfeed) or [h-feed](https://indieweb.org/h-feed)s, as well as RSS. This extra support makes it much more versatile, as well as having the support pluggable for other formats in the future.

Microsub works in a client-server model, and one of its goals is to remove the complexity of post/feed parsing from the client. The Microsub server manages the list of people you're following, as well as collecting and parsing their posts, which leaves the client with the job of rendering the post. This makes it much easier to create a client as you just need to look at how you want to render content instead of having to think about how to parse the content to be rendered.

However, I hear you ask, won't Microsub just go the way of the RSS reader? And the answer is I don't think so, because RSS readers lost out to social media because RSS readers were quiet and lonely. You couldn't share with others your thoughts or easily share the content with friends. This is where Microsub can win, because an Indie reader (which would read from a Microsub server) would then be able to utilise Micropub (if your site supports it), allowing you to like/repost/reply while reading the post.

## Webmention

[Webmention](https://indieweb.org/webmention) is a standard that makes it possible to notify another site that you've written something about them.

Without Webmention, there would be no way to know that someone had sent a reply to you without you i.e. polling their site to check, which isn't ideal because you may get a mention from _any_ site on the Web!

This makes discovery of content that refers to you a little easier, as the other site will generally send you a Webmention to say "hey, I mentioned you!" or "hey, I liked what you wrote!".

This happens by someone sending an HTTP POST request to the registered Webmention server, with details of which post is sending the Webmention (`source`) and which post is mentioned (`target`).

```http
POST /webmention-endpoint HTTP/1.1
Host: aaronpk.example
Content-Type: application/x-www-form-urlencoded

source=https://waterpigs.example/post-by-barnaby&
target=https://aaronpk.example/post-by-aaron
```

Webmention brings the Social to the Social Web, enabling the real interactivity of sites' content.

## Brid.gy

[Brid.gy](https://brid.gy/), as the name suggests, is a bridge which helps connect the IndieWeb with the silo'd web. It has two purposes - to backfeed content from another platform to your own site, and to syndicate content from your own site to another platform.

For instance, I've got Twitter integration set up which send Webmentions to pages that have been interacted with. This lets me know when people like/repost/reply to content I've shared, and renders on my website as if someone had interacted it using their IndieWeb site.

But as well, if we want to POSSE content, we can do this by letting Brid.gy handle a lot of the hard work. For instance, if I wanted to have anything that's a [bookmark](/kind/bookmarks/) published to Twitter as a "recommended read", that'd be possible using Bridgy.

Over Hacktoberfest I'm looking at getting the time to finally set up [a Meetup.com integration for Bridgy](https://github.com/snarfed/bridgy/issues/873), which would allow RSVPs from my site to automagically be sent to Meetup.com, allowing me to 100% own my RSVPs!

## Web Sign In / IndieAuth

The problem with authentication/authorization systems in a centralised system is that they're reliant on knowing which providers you'd want to use, up front, as they'd need to build in the integration.

For services that do not necessarily want to set up their own authentication/authorization servers, OAuth2 is used as a way to handle this to say i.e. `Sign in with Google`.

But the issue with OAuth2 is that it requires prior knowledge of the application i.e. Google would need to know about `auth.jvt.me` or `login.indieweb.org`, which just doesn't scale based on how many websites there are on the Web.

Instead, the IndieWeb community has worked on the IndieAuth standard, also called a more friendly "Web Sign In", which allows login via your domain name.

This makes it possible for an arbitrary application to know how to go through authentication/authorization by looking up two properties within your HTTP headers / HTML body: `authorization_endpoint` and `token_endpoint`.

With these, it follows the standardised IndieAuth flow which then takes you to your authorization server, which may authenticate you some way.

### Rel-Me Auth

One method of web-sign in being made quite powerful is [rel-me auth](https://indieweb.org/RelMeAuth), which is one of the easiest ways to get set up on it. This uses the common concept of two-way links between your website and silo profiles.

For instance, from my website:

```html
<a rel="me" href="https://gitlab.com/jamietanna">
  <i class="fa fa-gitlab" title="GitLab.com Profile"></i>
  &nbsp;@jamietanna
</a>
```

This lets my IndieAuth server know that they can use a GitLab social login to prove that I am who I say I am, provided that `https://gitlab.com/jamietanna` also has a link to `https://www.jvt.me`.

# Getting Started (`/getting_started`)

To get started on IndieWebifying your website, I'd recommend finding a [Homebrew Website Club](https://indieweb.org/next-hwc) if there is one nearby to you.

It's worth also having a read of the [Getting Started page on the IndieWeb wiki](https://indieweb.org/Getting_Started), and feeding back in terms of what can be done better - we want to continuously improve it and make it easier for new folks to get started.

We have a pretty noisy set of chat rooms which are available on IRC, Slack and Matrix, all of which can be found linked from [/discuss on the wiki](https://indieweb.org/discuss).

There are also a few [IndieWebCamps](https://indieweb.org/IndieWebCamp) around the world that you can get involved in for a bit more of an in-depth IndieWeb experience compared to a Homebrew Website Club.

In terms of what to start with? [IndieWebify.Me has a good guide](https://indiewebify.me/) to getting going with some of the first few steps, as well as some of my own ideas on how to start:

- create a personal h-card to add machine-readable information about yourself
- start to mark up your content with Microformats
- add the ability to use different post types i.e. RSVP, reply
- add support for receiving Webmention on your site

But at the same time, don't feel daunted thinking you need to implement this all yourself for the IndieWeb experience. There's already a tonne of support out there, with projects such as [Known](https://withknown.com/), [Micro.blog](https://micro.blog) or various plugins and themes for WordPress that make it possible to be IndieWeb-ified out-of-the-box!

You may also be interested in reading my post [_Why I Have a Website and You Should Too_]({{< ref "2019-07-22-why-website.md" >}}) which doesn't focus on the social IndieWeb angle of it, just why you'd want to be publishing data on your own site.
