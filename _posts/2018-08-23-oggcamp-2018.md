---
title: OggCamp 2018
description: A look at my time at OggCamp 2018, the talks I presented and attended.
categories: events
tags: events chef public-speaking openapi swagger free-software open-source collaborative-culture
image: /assets/img/vendor/oggcamp-twitter.jpg
---
Over this last weekend, I attended my first [OggCamp]. The weekend was best described by the phrase `Collaborative Culture`, coined by [Jon](https://twitter.com/jontheniceguy), and from their Twitter description "Free Culture, Free and Open Source Software, hardware hacking, digital rights, and all aspects of collaborative culture".

I wasn't quite sure what to expect, but I thought it may be somewhat like [FOSDEM][fosdem], but on a smaller scale. It had similarities, but you could definitely feel it was a lot smaller, which in itself was very different to other conferences I've been to in the past. It was a very varied conference in levels of technicality and of talk topics, not least due to design of having 2/3 of the talks in Unconference format.

It was also pretty cool that the Open Source Initiative sent through some cupcakes!

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Cupcakes have arrived <a href="https://twitter.com/oggcamp?ref_src=twsrc%5Etfw">@oggcamp</a> <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> <a href="https://t.co/2FM0i7zQkM">pic.twitter.com/2FM0i7zQkM</a></p>&mdash; Sean O&#39;Mahoney (@Sean12697) <a href="https://twitter.com/Sean12697/status/1030773618786099202?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

## Day 1

### Welcome Speech

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Let the talks commence! <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> <a href="https://t.co/USFWS6KXQ6">pic.twitter.com/USFWS6KXQ6</a></p>&mdash; Lucy B (@LinuxLucy) <a href="https://twitter.com/LinuxLucy/status/1030809589221076993?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

Starting off the day with WiFi passwords, safety details, and a great big welcome, Jon didn't waste any words, as he wanted to make sure we all had time to get Unconference talks up on the boards, and give people time to decide what they wanted to attend.

### [Infrastructure as Cake - Testing Your Configuration Management in the Kitchen, with Sprinkles and Love](https://joind.in/event/oggcamp-18-2018/infrastructure-as-cake---testing-your-configuration-management-in-the-kitchen-with-sprinkles-and-love)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">First talk of the day <a href="https://twitter.com/oggcamp?ref_src=twsrc%5Etfw">@oggcamp</a> &amp; it’s  <a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> &amp; his talk on baking &amp; cupcakes! <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> <a href="https://t.co/6M052Fg6kn">pic.twitter.com/6M052Fg6kn</a></p>&mdash; Colette Weston (@ColetteWeston) <a href="https://twitter.com/ColetteWeston/status/1030758441332158465?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Here&#39;s <a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> starting his talk on baking and cupcakes! <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> <a href="https://twitter.com/hashtag/chef?src=hash&amp;ref_src=twsrc%5Etfw">#chef</a> <a href="https://twitter.com/hashtag/ConfigMgr?src=hash&amp;ref_src=twsrc%5Etfw">#ConfigMgr</a> <a href="https://t.co/1mTi5wv27r">pic.twitter.com/1mTi5wv27r</a></p>&mdash; Anna (@anna_hax) <a href="https://twitter.com/anna_hax/status/1030756691342700544?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

I had a few minutes to prepare with the audio/visual connectivity before I kicked off the conference's main stage talks! There were at least fifty people who wanted to learn about Configuration Management using Chef, which was really exciting as it was easily the largest group I've presented to. A good 2/3 of them were familiar with Configuration Management, but not with Chef, so I hope I shared some good insight and some of the reasons why you'd want to adopt it as your tool of choice.

I was still chopping-and-changing my talk the night before, but as soon as I'd got my laptop connected, I was feeling pretty comfortable and ready to drop some knowledge. Something which initially threw me off, but I hope I recovered from, was not having a microphone - I only realised when I was starting to introduce the talk that I didn't have a microphone at the podium. Not wanting to lose any time on the strict 25 minute slot, I tried to project my voice a little better, which I hope I was able to do well enough - I didn't hear any complaints at least.

I didn't need to refer to my notes, and I felt that the talk actually went pretty well aside from being a little rushed towards the end. The rush towards the end was mainly due to me spending too much time on the "what is config management" section, which I feel I should've glossed over due to the audience saying they were pretty comfortable with the term. I also definitely didn't need each of the `kitchen` commands to be run through, when instead we went through the full lifecycle of `kitchen test`. I'll likely move them to an appendix of sorts, rather than being in the main slides.

As I've [presented the talk a number of times before][chef-talk], I was feeling fairly confident and had done a couple of read-throughs before the day to make sure it would be well delivered.

I'd been asked a question about my use case differences between Ansible and Chef, which I mention in the talk - the main one being testing, but also having a source of truth in a separate place than Git, i.e. a Chef server, to which another audience member mentioned that Ansible Tower can fill that role.

I'd also been sent a box of swag from Chef, which went down a _treat_, and only had a few _morsels_ left after the talk, which I then moved to the main reception area.

I also found it pretty cool that @computa_mike was given a new spark of inspiration to get started again with Chef after my talk:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">I&#39;ve been playing with <a href="https://twitter.com/chef?ref_src=twsrc%5Etfw">@chef</a> last week - and I had gotten somewhat disheartened - but seeing <a href="https://twitter.com/JamieTanna?ref_src=twsrc%5Etfw">@JamieTanna</a> &#39;s chef talk left me all inspired again. particularly about params.  Wondering about a standard recipe for deploying a website onto a server. Man I love going to <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a></p>&mdash; Mike Hingley (@computa_mike) <a href="https://twitter.com/computa_mike/status/1031458306685063169?ref_src=twsrc%5Etfw">20 August 2018</a></blockquote>

### [Redis: Past, present and future](https://joind.in/event/oggcamp-18-2018/redis-past-present-and-future)

Unfortunately we'd arrived late to this talk, so didn't get too much out of it, not least because we didn't have any experience with Redis or Kafka!

### [Running your own mainframe on Linux (for fun and profit)](https://joind.in/event/oggcamp-18-2018/running-your-own-mainframe-on-linux-for-fun-and-profit)

Jeroen took us through his work with emulating mainframes using [Hercules 390](http://www.hercules-390.org/). With no experience of how mainframes work, there was a lot of new content and it was quite cool to see how one would write and execute code for a mainframe. Jeroen shared how he works in the not-so-thriving community and how he's struggled with inactive maintainers of software, and very few picking up the mantle.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">The difficulty of maintaining Open Source - what happens if you move on from a project, but don&#39;t officially announce it? Jeroen Baten shares his struggles with finding support for Hercules 390 <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1030777781280489473?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

### [How to overcome your fears to become a conference speaker](https://joind.in/event/oggcamp-18-2018/how-to-overcome-your-fears-to-become-a-conference-speaker)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Great hints &amp; tips <a href="https://twitter.com/oggcamp?ref_src=twsrc%5Etfw">@oggcamp</a> <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> <a href="https://twitter.com/hashtag/OggCamp18?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp18</a> <a href="https://t.co/fFSG6ege1w">https://t.co/fFSG6ege1w</a></p>&mdash; Colette Weston (@ColetteWeston) <a href="https://twitter.com/ColetteWeston/status/1030820404468899842?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

Antonio took us through his tips for how to get started with conference speaking.

One observation he made was how although many conferences mention that their Call For Papers / Call for Proposals process may be touted as "anonymous", often it may not be as you may be asked for supporting information such as previous talks which will inadvertently identify yourself.

To get an edge against all the other proposals going in for a conference, Antonio recommended that if it's possible, you should try to target your proposal to the conference's themes, so it doesn't sound like a generic re-posting of your talk, as well as making sure you don't submit a talk that doesn't fit in with the theme of the conference.

He mentioned that after speaking at local meetups and gaining confidence, applying for a conference in eastern Europe is a great way to get a name for yourself. In his experience, they will be more willing to pay for travel/accommodation and it's great marketing for them to have speakers from various areas. And when you're looking to go for a larger conference it could require planning a year ahead in - as he says, it's a marathon, not a sprint!

One of Antonio's strongest points was the act of getting feedback on the talk both before and after the CFP process, be it successful or not. I'd add on this that it helps to share around your talk abstracts with your peers, both those who will and won't know the topic well - if you don't [think about your audience] and the chance they won't be subject matter experts, you won't be able to sell it correctly. You need to ensure you're getting continual, incremental feedback to polish your talk.

There was a question about oversaturation, which linked into a comment about questioning _why_ you want to speak. For me, it's because I just want to share my knowledge a la [blogumentation]. Although I enjoy building up a personal brand, I'm more excited by the ability to share and learn from others. I find blogging a great way to get started, but being up on stage and having some dedicated time to get my passion and knowledge across can be much more effective than just reading some written words. This oversaturation of talks also makes it hard to get your foot in the door, as there could be i.e. 10 other talks about Configuration Management at a conference. Having a different angle for your talk makes it more interesting than a generic talk, and helps give your audience something new to learn, even if they're already quite knowledgeable on the topic.

Although it sounds like common sense, I've definitely fallen prey to not practicing the talk _out loud_ in the past. As Antonio put it, "when you perform the talk in your head, it's always the best talk you've ever done" - by speaking out loud, you'll get used to saying the words, you'll make mistakes that you can then improve, and find sentences and phrases that don't quite work.

And finally, there was the talk of rejection - it'll happen, but if you can get feedback on _why_, then you'll be in a better place for the next one.

### Lightning Talks

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Such a great range of topics in the lightning talks at <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> — starting in 15 min! <a href="https://t.co/YtaUFWMJ64">pic.twitter.com/YtaUFWMJ64</a></p>&mdash; Jost (@JostMigenda) <a href="https://twitter.com/JostMigenda/status/1030805048396328960?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

Unfortunately a speaker dropped out last minute, which meant that there was a slot of lightning talks, with a great variety of talks. I'd have found a couple of lightning talk sessions interesting, as there was already a great range of talks, and think that if it was planned into the event, more attendees may have been interested. I definitely would've been up for talking about other, shorter, topics if I'd had the chance.

#### UPS Canary

Mark talked about having a device on the network which would warn when power has switched from mains to the UPS, allowing devices to cleanly shut down. Although not an issue I face currently, I can see it working!

#### Things I learned kid-wrangling at Hacker Con

Tanya talked us through the awesome work she does to look after kids at conferences such as SteelCon, allowing parents and guardians to attend events.

She spoke about how, unlike with adults, you can't just get children to sit on their phones if they're not interested in the activities, but instead have to provide many alternative activities.

She also mentioned the various organising issues, such as labelling / counting children so you don't lose them, ensuring that Criminal Record Bureau checks are done, and that no matter how low your patience, you stay calm around them.

#### Are LUG and small events even relevant any more?

Sebastian spoke about how Linux User Groups are no longer much of a thing, he believes because it mostly "just works" so there is less tech support needed. There's a lot of time, money and effort that can be expended to set up a usergroup for very little gain, when coming to a larger event may be more rewarding.

#### Google isn't sure this building exists

What weird things are there on Google Maps? Are they staged, or is it just "day in a life"? We visited some of Jon Rafman's blog [9 Eyes](http://9-eyes.com/) which explores some wacky events from around the globe.

#### PiDP8/I

This was quite an interesting talk about the [PiDP-8/I](https://www.raspberrypi.org/blog/pidp-8i-remaking-the-pdp-8i/), a project to help retain computing history by turning a Raspberry Pi into a functioning PDP8/I emulator.

### [Mobile Network Technology Primer](https://joind.in/event/oggcamp-18-2018/mobile-network-technology-primer)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Learning about how the Mobile Networks actually work, and getting down with all the lingo <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1030820171961851905?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

Keith took us through some of the many acronyms that exist in mobile networking, how the progression in networking technologies (such as 2G, 3G) has unfolded, and what looks to be coming next.

### [Main Stage Extravaganza](https://joind.in/event/oggcamp-18-2018/main-stage-extravaganza)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Some awesome, thought-provoking conversations about Collaborative Culture, rationalising use of Proprietary Software, and everything in between at the Main Stage Extravaganza at <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1030846068655878146?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>
<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Biggest take away from the session would be &quot;Be the change you want to see in the world&quot; - you need to take Collaborative Culture into your network and promote the right things <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1030847071081914368?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

This session was a live recording for a podcast, containing a few people that I've only ever heard, not seen, so it was quite a cool experience.

There were two main questions the group were concerned with:

- Are we doing enough for collaborative culture?
- Where do we rationalise the choice for proprietary software?

Around collaborative culture, there's the worry that at events like OggCamp we're preaching to the converted - likely those attending these events will already be bought into the concepts. We need to get out into other groups and spread awareness of the alternatives to the monopolies.

It was mentioned a few times by either the cast or the audience that they worked "for the man", and that they were "forced" to use proprietary tools, to which the response was "No you're not forced to use them. You can leave whenever you want". By all means can we be masters of our own destiny, but as one audience member rebutted, the company they worked for had recently started to realise that Free/Open Source solutions were an option, and that if there weren't those of us who remained to help guide the conversation, we'll never be able to make the difference.

The Performing Rights Society is in charge of chasing licensing royalties and they teach young artists they need to restrict their works, perpetuating bad habits. It'd be great if we could convince more to share their works, but how? There didn't seem to be a decision for how best to approach thi.

Interestingly [Iron Maiden planned concerts around locations where high number of torrents of their music were found][iron-maiden]. Compare this to Metallica who were made popular by the radio not playing their songs, requiring sharing of cassettes of their music to be shared, but now are clamping down on torrenting.

Another point raised was that podcasts are _technically_ All Rights Reserved as they don't explicitly license themselves differently. But if they were Creative Commons licensed, would that give anyone anything? Would it allow anyone to cut the podcast themselves and edit out sections they don't believe in? Yes, but who cares?

One rationalisation was that for entertainment such as TV, films and games, where we wouldn't necessarily be going in and editing a scene we don't believe in, proprietary licensing is fine. But for creations such as software that we'd want to be able to go in and fix a bug or add a new feature, we should be able to do that.

There's always the pragmatism - Jon's comment was that if it works when he needs it to, then he'll use it. As much as I love to host my own services and rely on my own infrastructure, I recently stopped running a personal [Seafile] server, as I couldn't be bothered with managing reliable backups and maintenance for our family. I'd much rather spend the extra few £s on a hosted service than spend hour(s) of my own time on it.

One comment was that actually, if we're spending the money anyway, why would we not put it in i.e. hosted Seafile services? __This is a great point!__ I'm going to look to which of my services I can offload to others so I:

- don't have to think or worry about it myself
- can support upkeep of products

Not only that, but I'm going to look at _actually_ setting up payments to projects I use daily, as it's really unfair me just taking without giving back. Unfortunately I don't seem to have a lot of time to spare, so it'd be good if I could compensate them with some money instead.

One final point on ethical ramifications of using certain software, media, etc is that actually it doesn't really matter - for instance, large companies such as Coca Cola have _literally killed people_ but people still drink it. After that comment was brought up, I still saw people drinking it. It's hard to go out of your way to "do the right thing", but that doesn't mean we shouldn't try!

I have such huge respect for the hugely philosophy-driven people like Richard Stallman, and would love to be more rigid in how I approach the software and hardware world, but I feel it's one of those things that currently I need to be pragmatic, but with the aim to leave the world in a better place.

## Day 2

### [Load Balancing 101 & Building a Linux Load Balancer](https://joind.in/event/oggcamp-18-2018/load-balancing-101--building-a-linux-load-balancer)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Load balancing 101 with <a href="https://twitter.com/AndrewXanadu?ref_src=twsrc%5Etfw">@AndrewXanadu</a> at <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> <a href="https://t.co/pwwQPARr5Q">pic.twitter.com/pwwQPARr5Q</a></p>&mdash; Gary Williams (@ThisGeekTweets) <a href="https://twitter.com/ThisGeekTweets/status/1031121216449531904?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">After a cracking <a href="https://twitter.com/hashtag/Sheffield?src=hash&amp;ref_src=twsrc%5Etfw">#Sheffield</a> breakfast I&#39;m back at <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> for the first talk of the day on Linux Load Balancing <a href="https://t.co/QfEnD6phi8">pic.twitter.com/QfEnD6phi8</a></p>&mdash; Anna (@anna_hax) <a href="https://twitter.com/anna_hax/status/1031121143107907584?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

Andrew shared how Load Balancing can be used to improve scalability, high availability and for helping with server maintenance, as well as the networking methods that are applied in order to make it work.

Although I play with Amazon AWS' Elastic Load Balancers almost daily, it was really interesting to understand more about _how_ they work and the different methods in which they can be applied within the network topology.

### [Matrix, the year to date](https://joind.in/event/oggcamp-18-2018/matrix-the-year-to-date)

Although I'd first encountered Matrix at FOSDEM 2016, I'd not really kept on top of what's been happening in that space.

I could remember that it was all about having a decentralised open network for real-time communications, and that there was something about bridging networks i.e. IRC, Slack, Mastodon, but I didn't realise how Matrix could be used with arbitrary tech such as Philips Hue devices.

Ben explained the architecture of Matrix as a system with the various challenges of a distributed system with syncing state, giving us great insight into the complexities involved.

Ben also explained how they practice fully open development both in terms of Open Source and Open Communication with their issue tracker being used for _all_ conversations, rather than there being some hidden communication channels used by the team. As with GitLab, I'm a huge fan of this method of Open Operations and the confidence and community involvement in these decisions.

Another interesting piece of news was the [French Government deciding to use Matrix and Riot as its secure messenger base](https://matrix.org/blog/2018/04/26/matrix-and-riot-confirmed-as-the-basis-for-frances-secure-instant-messenger-app/), which shows a huge amount of promise for Open Source communications platforms instead of hosted, proprietary services like Slack.

I really need to get started with it, as well as determining if it would be a good fit for some community projects I'm part of.

### [Morality and Ethics - Caring is Everything](https://joind.in/event/oggcamp-18-2018/morality-and-ethics---caring-is-everything)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr"><a href="https://twitter.com/sjwarner_?ref_src=twsrc%5Etfw">@sjwarner_</a> is telling us all about Morality and Ethics at <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a>, definitely an important topic in the current digital age <a href="https://t.co/8n3jDdTqKW">pic.twitter.com/8n3jDdTqKW</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1031134530420269056?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Thought provoking talk from <a href="https://twitter.com/sjwarner_?ref_src=twsrc%5Etfw">@sjwarner_</a> at <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> <a href="https://t.co/TEWKMZABx5">pic.twitter.com/TEWKMZABx5</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1031139684943126528?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Think before you write! <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> <a href="https://t.co/knaZ6cyFYg">pic.twitter.com/knaZ6cyFYg</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1031140281893224449?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

Sam spoke about how, in the current digital age, we need to consider the ethical implications of our tech and:

- at least, don't make the world a worse place
- at best, cause social good

The key questions were what impact can we actually make on the world, and how can we use metrics to drive this? According to the [Stack Overflow 2018 survey]:

- 79.6% believe obligation to consider ethical implications
- 19.7% believe ultimate responsibility for unethical software would be their fault

Although there are these many that _believe_ they should consider it, I wonder how many actually do? And of those who don't believe the ultimate responsibility is theirs, why not?

### [Error Messages in the wild](https://joind.in/event/oggcamp-18-2018/error-messages-in-the-wild)

Mike shared some photos of various error messages he's encountered at ATMs, billboards, and various other screens around the world. His main point was that instead of dumping out a massive error message to a user, we should instead strive to provide user-friendly, non-jargon messages that can help the user report the issue. In the ATM's case, we could say where the nearest other ATM could be. We need to consider the context for our users, not scaring them with weird error codes, and instead log them silently to provide the developers with a chance to debug them separately.

### [DeGooglify with NEXTCLOUD](https://joind.in/event/oggcamp-18-2018/degooglify-with-nextcloud)

Unfortunately not as deep in the _why_ you'd want to use Nextcloud over a proprietary solution like Google's cloud solutions, this talk showed the various steps and commands you'd use to set it up. Interesting to see the use of different apps such as [DavDroid] and [ICSdroid] as alternatives to the Google Calendar apps.

### [OpenAPI / Swagger Specification](https://joind.in/event/oggcamp-18-2018/openapiswagger-specification)

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Thanks to those who came to my impromptu <a href="https://twitter.com/hashtag/OpenAPI?src=hash&amp;ref_src=twsrc%5Etfw">#OpenAPI</a> <a href="https://twitter.com/hashtag/Swagger?src=hash&amp;ref_src=twsrc%5Etfw">#Swagger</a> and <a href="https://twitter.com/hashtag/ContractDrivenDevelopment?src=hash&amp;ref_src=twsrc%5Etfw">#ContractDrivenDevelopment</a> talk at <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> I hope to have a blog post about it soon <a href="https://t.co/Od1qsVkKaf">pic.twitter.com/Od1qsVkKaf</a></p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1031180233007882240?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

This was a late entry, given I'd not fully planned it. I mentioned on Twitter I wanted to talk about it:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">So I&#39;m doing one of the planned talks today at <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> which has meant that I&#39;ve not had a chance to fully prepare another talk I&#39;d like to do around proving OpenAPI specs are representative of your API. It won&#39;t be a full 25 minutes and I&#39;d hate to take a slot from someone else</p>&mdash; Jamie Tanna (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1030733760357117953?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Please please open api specs! I&#39;m just starting to work with it and would love to hear more or just meet others to chat</p>&mdash; Lorna Mitchell (@lornajane) <a href="https://twitter.com/lornajane/status/1030743746529374211?ref_src=twsrc%5Etfw">18 August 2018</a></blockquote>

I started by talking through Swagger/OpenAPI and the reasoning behind it; creating a standard, programming language-agnostic representation for REST(ful) APIs. I talked about how making the specs both human and computer readable was a great selling point, allowing tooling to exist around it, but also not requiring it for reading.

I discussed a use case for why you'd want to create them, with the example of some integration work we've been recently doing at Capital One on the PSD2/Open Banking workstream. Contracts for API services haven't always been the best defined, so having them fully fleshed out in a consumable format would be really awesome, and would prevent the integration issues we were seeing. This also helps to reduce the many places in which your API documentation can live - `README`s, Confluence pages, scribbled on whiteboards, etc.

I then spoke about how to get started with Swagger - autogenerating it from the codebase if possible, and then writing the rest manually. Although it can be a bit daunting, the manual touch is required to help assess if there are holes in your object model or duplicated resources, as well as helping to add a bit more context for your APIs. I talked about how the use of `Model`s is key to understanding interactions with your API and to help reduce duplication.

Although generating nice UIs for your contract documentation through [Swagger UI] is great, but so is the ability to generate a client/server implementation from the spec.

This led me into a brief overview of Contract Driven Development, where we can use Swagger's client codegen ability to prove our API documentation matches our implementation. I won't go into this in any more depth, [I have an article nearing readiness](https://gitlab.com/jamietanna/jvt.me/issues/266) which will be more interesting. Originally I was going to do a talk on just this topic, but I'm glad I didn't as I didn't really have enough prepared to talk through it. Once I've got the article written, I'll be in a much better place to talkify it.

The twenty attendees all seemed to be interested, and I had some questions around the best way to hook it into existing applications, as well as some specific use cases.

One main bit of feedback I received was that because I didn't have any slides (as it was last minute) it meant I jumped straight into it instead of sharing who I was and why I was talking about it.

### [Rafflecast](https://joind.in/event/oggcamp-18-2018/rafflecast)

Throughout the weekend we could buy raffle tickets to try and win a variety of freebies, from leftover Chef swag to Pimoroni goodies to an [Entroware laptop]! All prizes were donations from various organisations, which meant that the profit from tickets and associated swag we'd bought (like a mug and T-shirt) would go to pay for the conference. Anna won a really cool Ubuntu Xenial Xerus USB with Ubuntu 18.04 on it:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Thanks for an awesome weekend <a href="https://twitter.com/oggcamp?ref_src=twsrc%5Etfw">@oggcamp</a>! All the organisers, crew and sponsors have done a great job of a hosting a welcoming and interesting weekend <a href="https://twitter.com/hashtag/oggcamp?src=hash&amp;ref_src=twsrc%5Etfw">#oggcamp</a> <a href="https://twitter.com/hashtag/foss?src=hash&amp;ref_src=twsrc%5Etfw">#foss</a> <a href="https://twitter.com/hashtag/linux?src=hash&amp;ref_src=twsrc%5Etfw">#linux</a> <a href="https://twitter.com/hashtag/Ubuntu?src=hash&amp;ref_src=twsrc%5Etfw">#Ubuntu</a> <a href="https://t.co/Be2BojAp7z">pic.twitter.com/Be2BojAp7z</a></p>&mdash; Anna (@anna_hax) <a href="https://twitter.com/anna_hax/status/1031189752664543232?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

And I won a [Pimoroni Unicorn pHAT] which was pretty cool!

## Ending Remarks

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Thank you <a href="https://twitter.com/hashtag/OggCamp?src=hash&amp;ref_src=twsrc%5Etfw">#OggCamp</a> crew! You are excellent humans and I can&#39;t wait to do it all again next year! <a href="https://t.co/3KXjpeOSVT">pic.twitter.com/3KXjpeOSVT</a></p>&mdash; Lorna Mitchell (@lornajane) <a href="https://twitter.com/lornajane/status/1031188366195388416?ref_src=twsrc%5Etfw">19 August 2018</a></blockquote>

One thing we found interesting was that there were actually very few attendees using Twitter, which I guess you'd expect from the group. It was still quite nice to see the principles living strong.

The second day was a lot better organised, with the order of the morning talks being decided by 1100 and the afternoon talks by 1300, making it easier to plan out where you'd be in for the sessions, rather than having to pop down to the boards each time in case there were any new talks added.

There still wasn't any organised timekeeping, so lots of talks were starting late and/or running past the allotted time, meaning we'd often miss the start of the next talk which was unfortunate, and I can imagine not helping the speaker by having a trickle of attendees through the first few minutes of their talk.

It's definitely refreshed in my mind that I need to get involved in Free and Open Source software, and the biggest thing I've taken back to Capital One is that we need to give back to the community!

[OggCamp]: http://oggcamp.com/
[blogumentation]: {% post_url 2017-06-25-blogumentation %}
[chef-talk]: /talks/chef-infrastructure-as-cake/
[think about your audience]: {% post_url  2018-08-16-context-is-king %}
[iron-maiden]: https://torrentfreak.com/iron-maiden-tracks-down-pirates-and-gives-them-concerts-131224/
[Seafile]: https://www.seafile.com/
[Stack Overflow 2018 survey]: https://insights.stackoverflow.com/survey/2018
[DavDroid]: https://www.davdroid.com/
[ICSdroid]: https://icsdroid.bitfire.at/
[fosdem]: http://fosdem.org
[swagger UI]: https://swagger.io/tools/swagger-ui/
[Entroware laptop]: https://twitter.com/bouncysteve/status/1031230418622853121
[Pimoroni Unicorn pHAT]: https://shop.pimoroni.com/products/unicorn-phat
