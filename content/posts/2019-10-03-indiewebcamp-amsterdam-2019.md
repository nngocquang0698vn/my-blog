---
title: "IndieWebCamp Amsterdam 2019"
description: "Recapping my time at IndieWebCamp Amsterdam, my first 'official' IndieWeb event, and meeting some of the big names in the community."
tags:
- indiewebcamp-amsterdam-2019
- indieweb
- indiewebcamp
- webmention
- micropub
- syndication
- privacy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-03T19:14:04+0100
slug: "indiewebcamp-amsterdam-2019"
image: /img/indiewebcamp-amsterdam-2019/group-aaronpk.jpg
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: 'Lobsers'
  url: https://lobste.rs
---
I've had a great couple of days at [IndieWebCamp Amsterdam](https://indieweb.org/2019/Amsterdam). It was my first IndieWebCamp, and it was a great in-person introduction to the wider IndieWeb community, although I've been active on Chat for some time!

<figure>
  <img src="/img/indiewebcamp-amsterdam-2019/group-aaronpk.jpg" alt="The IndieWebCamp Amsterdam 2019 Attendees on Saturday" />
  <p><figcaption>The IndieWebCamp Amsterdam 2019 Attendees on Saturday, <a href="https://www.flickr.com/photos/aaronpk/48831590597/in/album-72157711161622328/">original photo CC-BY-2.0 by Aaron Parecki</a>.</figcaption></p>
</figure>

# Saturday - Sessions

Saturday was the day for conversations and sessions.

It was also quite a surreal experience meeting some of the IndieWeb folks. I've been on the edge of the community since at least June 2017, but likely before that, as I can only find so far back on my Firefox history (read: this isn't because I haven't felt welcome, but just that I've not yet got everything in the right place that I can start to "be IndieWeb"). It's been a few years of reading posts by <span class="h-card"><a class="u-url" href="https://tantek.com">Tantek</a></span> or the [IndieWeb wiki](https://indieweb.org/), building my understanding and thinking about the ways the community has looked at things, as well as some of the cool technologies in use.

But then being in a room, and being warmly greeted by Tantek, and having folks recognising me from my URL / chat avatar was really nice. It definitely gave me some warm fuzzies! It was really nice, as well, to see the faces behind the URLs/chat names that I'd become so used to seeing!

There were almost 25 of us in-person, and a number of remote participants over the day.

## Introduction to IndieWebCamp

<span class="h-card"><a class="u-url" href="https://www.zylstra.org/blog/">Ton</a></span> kicked off the day by sharing some background on the IndieWeb and what the movement is about.

Ton spoke about the agency that new technology gives us, and how awesome it can be to get playing with something new that gives you lots of new opportunities, but that really there hasn't been that much recently that has felt like that.

Ton shared a quote:

> the next big thing will be lots of smaller things

Which he mentioned was what the IndieWeb is. It's lots of smaller pieces of technology working together to make a huge difference to folks, and their agency to own their identities and data.

We heard about how silos (such as Twitter or Facebook) aren't going to be around forever, as well as sharing some of the other big names we thought would be, and that when they finally do go out of business, they're unlikely to care about whether they should let you export all your data - so why put so much data in that you know it's not going to be easy to get out?

We heard how the IndieWeb revolves, most importantly, around identity, and that identity being your website. It was interesting to talk about this at lunch with Aaron Parecki, who shared that if you used Tumblr or Medium, but did use your own personal domain, you'd still be counted as IndieWeb. This was a bit of a misconception of mine, assuming that IndieWeb meant owning data, but it's more fundamentally about identity, although it helps to have data ownership too.

Ton then spoke a little about how we should work to find others who are interested in this, but may not know it under the term "IndieWeb", and connect to them and build our community outwards. We should also look at how AI/Machine Learning/IoT will work, as well as engage folks from other side of tech, such as UX/UI/Design to build more intuitive interfaces and experiences with these tools, so it's better for a wider group of folks.

## Personal Introductions

A nice way of getting to know the folks around us was sitting around having a coffee and a chat before the day started, but also through the personal introductions section.

For this, each attendee came to the front (if they were comfortable with this) and talked through their website, if any, showing off some of the features, be it <span class="h-card"><a class="u-url" href="https://annadodson.co.uk/">Anna</a></span>'s dark mode, my [recent Micropub functionality]({{< ref "2019-08-26-setting-up-micropub" >}}) or <span class="h-card"><a class="u-url" href="https://seblog.nl/">Seb</a></span>'s private posts.

This was nice, because we were able to easily find out who was who, what level of web experience they had, and then through to experience with the IndieWeb.

One thing I'm quite bad with is names - it may be worth having name badges for the next one, as then it'll make it easier (and less awkward) for folks to get names right in sessions!

## Scheduling

In order to determine which sessions folks were going to be run, we in BarCamp/Unconference style, put post-it notes up with the talk title, after which the person proposing it would be able to give a little more info.

We then started to look at how many people wanted to attend which sessions, and split the talks down by which area would fit the amount of people.

## Web Standards and Accessibility for Everyone

The first session I attended was Anna's on building accessibility into the Web.

We spoke about how accessibility is one of those important things that will affect everyone - it's not just a matter of if, it's when! Over time we'll all encounter accessibility issues, be they buttons that are too small to click, carrying a baby, being hungover, being on a bad network connection, or inevitable old age.

It's not one of those things that we can only partially do because we're immediately locking out lots of folks who would want to get into it, effectively saying that we don't care about them!

I shared that my own site isn't the most accessible with its search functionality because it downloads my (currently) 4MB JSON Feed, just so I don't have to maintain another format for search - this isn't ideal, and makes it such a poor experience for folks who don't have the best network.

We talked about the fact that publishing software should be telling users they're posting inaccessible content, as well as having periodic audits of the site, because accessibility needs change over time.

We talked a bit about `alt` tags on images, and what level of detail folks go to - for instance, I have an automated check that blocks me committing any changes that don't have `alt` tags for images. It doesn't test the quality of them, but at least helps me think and I generally add an okay-ish description. Other folks have this as purely opt-in, but generally do add it.

And of course, there was the underlying worry of syndication to silos not supporting it. For instance, some non-IndieWeb folks are starting to add an alt tag of sorts in their tweets, but this is a manual step they're doing. We'd need our publishing software to perform this for us, taking the `alt` tag and embedding it into the syndicated content.

We talked about the fact that, on the whole, the IndieWeb community are a little more switched on accessibility wise, but that there is always more to do!

We had a bit more of a discussion around dark mode, after Anna's demo of it in the introductions, which seemed to spark ideas for Sunday's hack day - there were at least 2 sites that now have dark mode after that!

We had an interesting discussion about how Facebook has tonnes of great info on the `alt` tags for images, such as `Image may contain: 8 people, people smiling, people standing and outdoor`. This is very useful for context, but also is scary because they must be doing lots of crazy things to scrape that data from photos!

But I did also remind folks that Facebook have done some pretty horrible things accessibility-wise to stop Adblockers:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Facebook adds 5 divs, 9 spans and 30 css classes to every single post in the timeline to make it more difficult to identify and block &#39;Sponsored&#39; posts, oh my. <a href="https://t.co/OghvQU1vdw">https://t.co/OghvQU1vdw</a></p>&mdash; Wolfie Christl (@WolfieChristl) <a href="https://twitter.com/WolfieChristl/status/1071473931784212480?ref_src=twsrc%5Etfw">December 8, 2018</a></blockquote>

This was a thought provoking session, and helped set the day with an air of empathy and thinking a bit more compassionately for our users.

## Private Posts

Following on from Seb's demo in the introductions earlier in the day, this session was taking a further look at how to maintain privacy in an own-your-data world, in terms of what content you'd want to make private and then how to implement it.

We could've spent a little more at the beginning talking about the differences [unlisted](https://indieweb.org/unlisted) posts vs [private](https://indieweb.org/private) posts, as some folks weren't as aware that unlisted posts were present at a guessable URL, and would be readable if you found them, but they wouldn't be discoverable in your feeds/be linked from elsewhere. This is a subtle difference to a private post which will not allow you to read it if you're not authorized.

We spoke a little bit about restricting posts for certain people (i.e. for private conversations), circles of friends (which could provide maintenance overhead) or only visible to yourself.

It was interesting to hear that Seb uses private posts as a way to draft content before it's ready to go live (which Tantek wants to do, too) - I mentioned that as all my site is Git-driven, I use a Git branch for draft posts which gives me freedom to update it as much as possible, then clean up history and push it live.

Ton brought up a really interesting point about how in real life conversations he'll swap between "my daughter" vs "&lt;name&gt;" depending on who he's talking to, and that he'd quite like to make this possible via some functionality through private posts.

<span class="h-card"><a class="u-url" href="https://sonniesedge.net">Charlie</a></span> mentioned that for some folks, they use a different silo account depending on the audience, to which Seb mentioned that he has one Twitter account for Dutch folks, and one for English + tech, but that it could go one further to have a private Twitter account just for friends.

There was a bit of a conversation following a question from Charlie (that I was going to raise a bit later) about how to work this with static sites. I suggested that something could happen with client-side decryption of the post content, but that it'd need to be stored in source control somewhere and that key would need to be retrievable. Charlie mentioned that this was against the way that Charlie wants to publish content.

We spoke a fair bit about check-ins, and the inherent privacy/safety issues that come with them. Because this is some highly dangerous data (for vulnerable folks, or otherwise) as it could allow a stalker, attacker, etc almost real-time access to where you are, which is not to be given out lightly! Charlie mentioned that they she publishes her check-ins after multiple days later, as then it's not useful to anyone aside from owning that data.

Ton mentioned that he uses check-ins as a way to announce to folks that he's come to town, which I quite like as an idea because then people can reach out if they see it.

This was an interesting session, as I'd seen lots of conversations over the last few months on the IndieWeb Chat but not looked into it and what it could do for me, as for now, I'm happy with things being public.

Definitely some food for thought, especially with respect to how it'll work with a static site.

## Licensing and Ownership

I started off with a bit of a monologue about the importance of Free and Open Source licenses, as well as things like the Creative Commons, and that it's actually quite difficult currently to have a machine-readable way to share the licensing of a piece of content.

I spoke about how licensing has been an interesting one for me as I practice [Blogumentation - Writing Blog Posts as a Method of Documentation]({{< ref "2017-06-25-blogumentation" >}}) which means I want to be able to share these articles and tips with my colleagues. However, if they're not licensed permissively, a big company (such as the one I work for) will not be happy with it. (Aside: [I went into this a bit more in my post in 2018, _Being More Explicit on Content Licensing_]({{< ref "2018-07-29-more-explicit-post-licensing" >}})).

Following a question from one of the participants about how to understand licenses from a non-lawyer, I mentioned that I too was not a lawyer, but had spent some time looking into licensing. I recommended [TL;DR Legal](https://tldrlegal.com/) which is an awesome resource for understanding licenses in a clearer language. We also spoke about "what the best license is", to which I mentioned that unfortunately that question is incredibly personal, and that folks have different thoughts for what they want. Because it depends on whether the person you're asking is thinking of it in terms of a Free Software "this is for the user" perspective, or a permissive license "I just want people to use this".

We spoke a little time talking about how Creative Commons is better for creative content, rather than code, which is why you'll see it used for those specific uses.

We also touched upon lack of licenses on i.e. GitHub/GitLab not meaning Open Source, but actually meaning "All Rights Reserved". This is counter intuitive if you're literally showing people the source code, but is legally sound!

It was interesting to hear from Ton that in Europe, government need to specify a license if they release it, otherwise it's public domain. But for individuals, we retain copyright unless said otherwise.

And we spoke a lot more about the existing methods of indicating licensing as being a bit wanting, because using `<link rel="license" ...>` applies to the whole document, which is very inflexible for an article that includes photos from different sources as well as code snippets, as all three forms are likely to be licensed under different licenses.

I've written up some of my thoughts in [a separate blog post]({{< ref "2019-09-28-microformats-licensing" >}}) following this session, along with my proposal of how we could alternatively mark it up.

Finally we had a little chat about finding other references to your site (i.e. if they don't send webmentions) as well as license violations. I shared a misunderstanding between myself and [sizeof.cat](https://sizeof.cat/) around licensing, and Ton shared a Hong Kong newspaper (as well as 20+ other publications) using photos of his.

## Post on Established Platforms / Roadmap

In this session we spoke a lot about syndication and how to publish content across platforms.

The question "can I post on Twitter, even though I have everything on my own website?" started off conversations, which was met with a fairly resounding _yes_! Although it's not an official IndieWeb principle, we don't want to force people to move platforms, but instead want to make it easier for folks to continue using the silo'd web and hear from us, rather than split the community.

If we did try to force people to move, we'll either find that folks do it, won't find it very easy, and then end up back on the silos, but bad-mouthing the experience. Alternatively, you turn people completely against it by trying to force them to move, which is very user hostile, and they likely boycott you!

I mentioned that throughout the day, I had been tweeting about the event, as a way of giving greater visibility of what was happening to folks that weren't around, and who may not already know what the IndieWeb was.

The group definitely agreed that things weren't necessarily in the right place "for the masses", and that if a group of technical folks can't get up and running very easily, we've no hope for folks that aren't really bought in to the politics behind it, or have the technical knowledge to do it.

We spoke a bit about "what it means to be IndieWeb", which to many has been described with a vague definition. I said that's perfect, because one of the key principles of the IndieWeb is to avoid monocultures, so having a movement that is many things to many people is great. That being said, if we can't consistently describe it to new folks, maybe it's not at the right point?

We talked a bit about how <span class="h-card"><a class="u-url" href="https://aaronparecki.com/">Aaron</a></span> had mentioned that at lunch, the ownership of identity is really the most important, even if not the ownership of data. For instance, `www.jvt.me` could be pointing to this Hugo website, Tumblr or Medium, and I wouldn't be necessarily owning my data. However, I'd own the identity that corresponds to the content.

We heard a little about how we could see it as a label for a lifestyle choice and principles associated with it, instead of a set of technologies/tools.

When talking about "how do you know if you're IndieWeb", I shared that there is [IndieWebify me](https://indiewebify.me/) and [IndieMark](https://indieweb.org/IndieMark) which both add a bit of gamification to give you scores in terms of how many of the technologies you've got.

Our closing thoughts on the session was that some folks are already part of the IndieWeb, they just don't know it, at least under that exact label. A nice thought that there are more folks out there, without even knowing they're part of something bigger!

## Calendaring, Events, RSVPs, Invitations

This session was quite good as we spoke about the various ways that events can work on the IndieWeb.

As I've recently been starting to [own my RSVPs](/kind/rsvps/) much more, as well as making it easier for folks to keep up to date with Homebrew Website Club, this was an interesting session for me to hear how other folks do this.

We spoke a bit about how to own RSVPs/events on our sites, as well as the semantic differences between them - RSVPs being "I'm attending that thing", and events being "this is a thing that is happening".

There were some mentions about how RSVPing no is very important, as it may show others that there's something interesting to go to, even if you're not able to make it - I like this, and am definitely going to try and do it more!

We also spent some time talking about calendar feeds, and how some folks delegate to [H2VX](https://h2vx.com/ics/) to provide these feeds, but a couple of us mentioned that we rendered a iCalendar feed as part of our site which means we don't have to rely on others.

We spoke a little about "Add to Calendar", to which I mentioned that [I recently added "Add to Calendar" support]({{< ref "2019-09-02-calendar-single-event" >}}) for both iCalendar format and Google Calendar.

We also talked a little bit about Meetup.com, which many folks use for meetups / usergroups. I spoke about how my workflow still requires some manual work for RSVPing on Meetup.com once I've published it to my site, but that on the hack day I'd be starting work on Meetup.com support for [brid.gy](https://brid.gy/).

## Syndication

This session was largely spent with me talking through what syndication was in the context of the IndieWeb and going through the feature set of [brid.gy](https://brid.gy/) and how it can be used.

It was interesting to go through some of the differences in the flow of syndication - be it from your site to the silo (Publish on Your Own Site, Syndicate Elsewhere (POSSE)), or from the silo to your own website (commonly called Publish Elsewhere, Syndicate to your Own Site (PESOS) or reverse syndication) and where ownership lies for these.

We also had some chats about backfeed, and how this allows you to take i.e. Twitter likes to a piece of your content and translate that to a Webmention like.

It definitely made me think that I really need to start syndicating notes from my website to Twitter, so I no longer have to do it manually.

# Sunday - Hack Day

On Sunday, we had the hack day. Folks spent time working on building the things that we'd been talking about the day before, or things they've wanted to do for a while.

We had a wide range of things that folks were able to get to - private posts, dark mode, RSVP support, and starting their own blog.

My primary goal was to start looking at how to extend Brid.gy to allow Publish on your Own Site, Syndicate Elsewhere (POSSE) support for Meetup.com, which would save a manual step I have to go through for owning my RSVPs.

I'd unfortunately spent a lot of my time fighting against Python packaging issues (especially with respect to Python 2 vs Python 3) which I've definitely put down to my lack of Python skills over the last few years.

However, I'd been making a fair bit of progress, although it's still a bit of a way off until it can be actually tried, I'm feeling positive and am looking forward to sharing it!

# General Thoughts

## IndieWeb for Beginners

One thing that was clear at the beginning was that we had a few folks who weren't as familiar with a lot of the terminology and technologies within the IndieWeb, and at this point I feel that I should've volunteered to run a "getting started" session, which I could've used my [IndieWeb talk](/talks/indieweb/) that I am presenting at OggCamp in October. It could've been a good second run-through, as well as helping the new folks.

It may be worth, in the future, having an explicit "IndieWeb for beginners" track to go through some of the common things and help give a bit more understanding before getting stuck into the sessions.

## Etherpad

A nice touch that the IndieWeb community does is uses the collaborative editor [Etherpad](https://etherpad.org/) while the talks are going on, allowing all the attendees of the talk (in-person or remote) to make notes.

I was already aware of the use of Etherpad at IndieWebCamp events, but I know some folks weren't so a little discussion about what it was used for, and the way that we look to have our sessions documented for posterity.

Some attendees shared that they didn't want their names on the Etherpad which I feel we should've talked about _before_ possibly putting them in the history, and maybe talking a bit more up front on that.

## Static Websites

I had a great chat with Anna and [Marty](https://martymcgui.re/) over lunch on Sunday about the use of static websites, and the joys and difficulties of them, namely speed to publish.

The three of us all use Hugo as our static site generator, but have different models of how it gets pushed live, which means we have different speeds at which things are deployed.

Marty shared his approach for more intelligent Webmentions, which allowed him to only send webmentions for content that has changed since the last run.

I shared that mine goes through _everything in my feed_ which likely sends a tonne of unnecessary webmentions, but only because I was being a bit lazy and didn't want to think about adding any special cases / state in place, at least for my MVP.


# Closing remarks

I want to say another big thanks to Ton and <span class="h-card"><a class="u-url" href="https://diggingthedigital.com">Frank</a></span>, they did a great job with the organisation and getting everyone together.

The venue, [Codam Coding College](https://www.codam.nl/en/about-codam) was great for the event, but was also such a great idea as a place to exist. Anna and I were bowled over at the fact that you could go and learn there for free.
