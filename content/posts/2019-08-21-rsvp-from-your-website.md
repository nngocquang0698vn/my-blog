---
title: "How to RSVP to an Indie Event from your Website"
description: "How to use your personal website in conjunction with Microformats and Webmention to be able to RSVP to Indie events."
tags:
- blogumentation
- indieweb
- microformats
- webmention
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-21T22:55:33+0100
slug: "rsvp-from-your-website"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: 'Hacker News'
  url: https://news.ycombinator.com
- text: 'Lobsers'
  url: https://lobste.rs
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
---
As some of you may know, I'm a [big advocate](/tags/indieweb/) for the [IndieWeb movement](https://indieweb.org/why).

I have been starting to [own my RSVPs]({{< ref "2019-07-27-rsvp-calendar" >}}), and publishing them from my personal website, but I know not everyone has got to that stage in their IndieWeb journey, and I wanted to give a helping hand.

For those of you who attend [Homebrew Website Club Nottingham](/events/homebrew-website-club-nottingham/), you may notice that there is no event on i.e. Meetup.com or Eventbrite. That is partly because I don't want to have to pay to host the event, but mostly because I get some more control when hosting the event, which is the whole point of the IndieWeb.

This allows me to put whatever information I want, in whatever format I want, and **??**.

But the thing is, attendees don't necessarily know how to RSVP to the event, so I never really know how many people are going to turn up - but I only have myself to blame for this!

# Creating Your RSVP

In order to create an RSVP to your favourite event (such as Homebrew Website Club Nottingham) you need to write some HTML. This can be anywhere on your site - for instance, I have a separate type of content stored in [/mf2/](/mf2/) which includes my RSVPs. It can be anywhere, as long as it's publicly accessible.

This HTML isn't your plain ol' HTML, it's using [Microformats](https://indieweb.org/Microformats). These are a standardised extension to HTML which allows you to provide lots of extra metadata in the form of CSS classes.

To show you what you need to do, let's go through [this example from the IndieWeb wiki](https://indieweb.org/rsvp#How_to_RSVP_with_HTML), line by line.

<details>
  <summary>RSVP example from the IndieWeb wiki, in entirety</summary>
```html
<div class="h-entry">
  <span class="p-author h-card">
    <a class="u-url" href="HTTP://YOURSITE.EXAMPLE.ORG/">
      <img class="u-photo" src="HTTP://EXAMPLE.ORG/YOURPHOTO.JPG" alt=""/>
      YOUR FULL NAME HERE
    </a>
  </span>:
  RSVP <span class="p-rsvp">yes</span>
  to <a href="HTTP://EXAMPLE.ORG/EVENTURL" class="u-in-reply-to">INDIEWEB EVENT</a>
</div>
```
</details>

```html
<div class="h-entry">
```

Around the whole RSVP, we have a Microformat container `h-entry`, to make the person receiving the RSVP aware that this is an entry type, opposed to i.e. an `h-event`.

```html
<span class="p-author h-card">
```

Next, we want to add some authorship information, so we know who this RSVP is from. The author is wrapped in an `h-card` container, which makes it possible to add other information about you.

Note that the authorship information is technically optional, and if you left it out it'd just say i.e. `www.jvt.me RSVP'd yes`, but it's good form and makes it better for seeing who's coming.

```html
  <a class="u-url" href="HTTP://YOURSITE.EXAMPLE.ORG/">
```

Inside the author information, we have a link to your home page, which may contain more information about the person, such as where you work.

```html
    <img class="u-photo" src="HTTP://EXAMPLE.ORG/YOURPHOTO.JPG" alt=""/>
```

To make the RSVPs render better, it can be helpful to share the author's photo.

Please note that your photo is definitely optional - don't feel like you need to have it there!


```html
    YOUR FULL NAME HERE
```

We also add your name, which makes it easier for the event organiser to see who it is RSVPing, as `www.jvt.me` may not be as helpful if you don't know their domain off by heart.

Again, remember that this doesn't have to be your real name if you don't want to share it for privacy reasons.

```html
  RSVP <span class="p-rsvp">yes</span>
```

The RSVP itself can be one of four options `yes`, `no`, `maybe` or `interested` depending on whether you'll be able to make it or not.

```html
  to <a href="HTTP://EXAMPLE.ORG/EVENTURL" class="u-in-reply-to">INDIEWEB EVENT</a>
```

Finally, we need to have a link to the event we're RSVPing to, with the special markup to say we're "replying" to it.

You can also have a look [at an RSVP I have set in the past](/mf2/233a6c3c-94b3-48ee-933c-fe48ea7f5554/), and notice that the rendering of this Microformats-marked-up HTML is written to be human-readable _first_ and machine-readable second, even if it's at the cost of making it more complicated.

# Letting the Event Know

Now you've got your Microformats-marked-up page available somewhere on your website, you need tell the event whether you're going or not.

There is another web standard for sending notifications between sites, called [WebMention](https://indieweb.org/webmention).

This allows the sending of notifications from one website to another, in a standardised form. There is a bit of extra work for you to determine exactly how to send these, so you can use [mention.tech](https://mention-tech.appspot.com/), [WebMention.app](https://webmention.app) or [Will Norris'](https://willnorris.com) [command-line tool `webmention`](https://github.com/willnorris/webmention) to automate this.

For instance, let's say you want to RSVP to [the Homebrew Website Club Nottingham on September 4th](/events/homebrew-website-club-nottingham/2019/09/04), and you have created the page `https://mydomain.example.com/rsvp/hwc-sept/`. You can go to [mention.tech](https://mention-tech.appspot.com/) and use:

```
source: https://mydomain.example.com/rsvp/hwc-sept/
target: https://www.jvt.me/events/homebrew-website-club-nottingham/2019/09/04/
```

And once that's sent, you're sorted - you've successfully RSVP'd to an Indie event!
