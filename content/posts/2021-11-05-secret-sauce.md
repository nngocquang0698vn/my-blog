---
title: "How We Built a Team with a High Net Promoter Score"
description: 'Sharing the "Secret Sauce" of why the Purple Pandas was a team that was highly effective, and had a high NPS, too.'
date: 2021-11-05T20:30:14+0000
tags:
- capital-one
- job
- communication
- diversity-and-inclusion
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "secret-sauce"
image: https://media.jvt.me/14c50096c8.png
syndication:
- 'https://news.ycombinator.com/item?id=29149641'
---
In September 2020, I was asked to move into a Tech Lead role in a to-be-formed team, which would be a mix of existing Capital One employees, as well as a few new folks who'd be joining over the next few months.

Forming this new team during lockdown was difficult, because trying to build human connections was a little more awkward. To make it easier, Shama, my manager, and I spent a lot of time building an environment that the team would be able to thrive in.

At the end of June, there was a survey done of engineering teams in Capital One, and it was found that our team had one of the highest Net Promoter Scores (NPS)!

As part of this, over the next quarter, the team wrote a series of blog posts and did a talk about what our "Secret Sauce" was, and I wanted to share in my own words what we did as a team to make it great. I'm sad the blog posts themselves couldn't be shared, as it was a really awesome set of posts, with each member contributing to sections, so you had the voice of the whole team, and some fun panda facts.

[Leaving the Purple Pandas](/posts/2021/08/19/joining-cabinet-office/) was hard, and I want to be able to share some insight into why it was such a great team, and what worked for us so well.

(Below are not only my efforts - my manager Shama, our Technical Programme Manager Nic, and the team did input a lot too - but there's a lot that I'm proud of in here and want to shout about)

# Culture & Psychological Safety

One thing very important to Shama and I when starting the team was to make sure that we had the right culture. It was most important to us that we got the culture in the team right, because even if we didn't have a well-defined "ways of working" set up, at least we would have a common base for how we act towards each other. We wanted to make sure that having a set of shared values everyone agreed with was key, and from there, we could improve them over time. This led to a really good in-team dynamic while we formed, and set things on a great trajectory.

One of the first things that Shama shared as part of our team forming was about [Psychological Safety](https://www.youtube.com/watch?v=LhoLuui9gX8). This gave us all the right level of context to the discuss it as a team, and was a great way of starting things off.

I've been in teams with varying levels of psychological safety, and I can absolutely speak to the benefits it has when you have it, and the impact it has when you really don't. Being able to challenge a viewpoint without fear of reprisals by other members of the team, or asking a question without someone telling you that's a stupid question (of which there are _no_ stupid questions - very important we all remember that!)

As a Tech Lead, I wanted to make sure that I didn't come across too strongly in discussions to the point that others would feel that it was required they listen to me, because it's only through listening to diverse opinions that we can get to a better solution, and without being able to deal with constructive criticism, we would stagnate as a team with my opinions. I wouldn't say I always got this balance right, and sometimes found it hard to then lean on the "do as I say" part, but we also had a lot of compromise as a team, which is how you know you're doing it right!

As part of a team with Psychological Safety, it's also very important that we have a blameless culture. As a team developing and shipping services for customers and then operating them after they're in production, we were naturally going to get things wrong. Breaking stuff is generally good - within reason, we don't want to take down production just for kicks - as it means we're able to learn the cases where things break, and understand our systems more appropriately, because we then need to fix them. Every time we would miss a deadline, break a test in a staging environment, or have an issue with production services, we'd make it visible, discuss it objectively as a team, and learn from it.

In all of these conversations, we never called out the one person who caused the issue for two reasons - firstly, it's hugely unhelpful to blame someone for things going wrong, and means that next time they likely just won't own up to doing something wrong. Secondly, it would be impossible for only one person to be at fault - due to code review requirements, quality assurance and change management at Capital One, it's impossible for one person to get something wrong, you need a whole bunch! As <span class="h-card"><a class="u-url" href="https://carol.gg">Carol</a></span> says in her talk _Panic Driven Development_, having guardrails is hugely important to support (junior) engineers, and give them the comfort to fail, knowing that things won't be too bad.

Something I do a lot of is use the term `we` not `I`. This isn't just the case for when talking about failures, but whenever I'd be talking about the team - or even when I was talking about other teams. It's a subtle nudge that as a team, we're in it together, and no one person gets either the riches or the blame.

It was also really important to make sure that the team was as open as possible. A team that is empowered to deliver works much better, where the team have control over their destiny, and are able to progress when members of the team aren't available - knock down those silos!

In cases where there are decisions happening for the team - such as a need to pivot to a different set of deliverables - making that reasoning clear, with as much context as possible from the leadership, any other relevant teams affected, and how it fits into the strategy going forward is hugely important, and even if the team don't feel like they were involved in the decision, it helps them understand why it's happened.

Building a good culture is also a case of being able to actively discuss, challenge and improve the way that the team works as a whole. Whether that means in a synchronous means, or through being able to provide anonymous feedback via Shama, and then we'd be able to discuss it appropriately.

I was happy with where we got to as a team, but know that we still had places to improve, as can be expected everywhere.

## Meeting Minutes

One way of breaking down silos we found worked well was to take meeting minutes.

As a large team that was starting to work on multiple workstreams, we found that it was getting difficult to keep on top of things, and so standups were getting a bit hard to follow at times. Then, because there was a mix of planning future work, or talking about things that were happening cross-team, it wasn't always possible to get all the information replayed in the standup you were in.

The solution we found was to start writing up notes for meetings and sharing them with the team. We decided that we'd write up _more_ meetings, without defining a percentage, and left it to gut feel - for instance, if there was a meeting discussing the next quarter's planned architecture, that would be a good one to do, but not one that was a Tribe-wide planning session that was recorded.

We'd then put them into Slack, with some easily searchable information like the date and any tags that could be related (i.e. CI/CD or a project name) and then in the thread share the full meeting notes.

We found that we would reply in the threads to discuss things about it, which had mixed results.

Since working at the Cabinet Office, I've found that the Google Calendar's option for taking meeting minutes would also have been a great way of doing it, although it loses some of the visibility we got through Slack, unless you make sure to put all the Google Docs into a single shared Drive.

## Inclusive Communication

If you've ever met me, you'll know that I'm quite keen on improving the way that we communicate. It's so important to make sure that we provide a space that people do feel safe, accepted, and welcomed into, so small changes to the words we use can make a huge difference.

By using terminology like `guys`, `crazy`, `grandfathering`, `pair of eyes`, and even saying `jeez`, we're using terms that are very likely to exclude someone, and even if they're not coming from someone trying to make people feel excluded, it still has that impact.

It definitely doesn't happen overnight, and although I've spent years improving my communication I'm still not anywhere near perfect, but it makes such a difference.

I have a number of resources, but I'd primarily recommend:

- [selfdefined.app](https://selfdefined.app/) for a list of lots of terms that you should be looking to understand and avoid
- [You Guys](https://www.xaprb.com/blog/you-guys/)
- [Why do I care?](https://medium.com/@skpodila/why-do-i-care-c2ef43a25837)
- [heyguys.cc](https://heyguys.cc/)

It's also worth a read of [Context is key: thinking about your audience](/posts/2018/08/16/context-is-king/), a post I wrote a few years ago, which is also really important - being able to communicate correctly to the stakeholders in the (virtual) room is important, and even though you may be using the most technically correct language, it's very likely to cause members in the room to be excluded / need to seek clarification. Being able to clearly explain a concept so everyone understands is such an important skill, especially as engineers!

# A consistent and Evolving "Ways of Working"

At the end of our first PI planning as a team, I wrote up the agile ways of working that we agreed to as a team, and made a start on the technical ways of working, which looked like a good start from my point of view.

In terms of our agile ways of working, we covered three main things:

- what do we want our culture to be
- how do we want to run meetings (for instance, co-located, the preference would be people aren't on their laptops unless it's _very much_ meeting related)
- how do we want to run our ceremonies, what time are they, etc

These, being a public page, meant that not only would be it usable in team, but folks looking to work with us, or i.e. join our standups would be more than welcome to, as they'd know when they'd be, and as mentioned below, there would be a shared team calendar they'd be able to access.

Over the first couple of sprints, we actually put them into action, and found there were tweaks we naturally needed to make, and after a couple of quarters using them, they were fairly different to where they'd started. The team's changing focus, mixing of workstreams, and a few new folks in the team meant that we'd amended them to better fit the team.

The technical ways of working did change, too - largely because I'd originally written things that weren't very clear and needed more examples of what we needed to do, such as [appropriately testing time with Java](/posts/2021/03/08/java-test-time/). These tweaks came out of us actually having conversations in code review where we could validate whether the practices we said we'd follow actually made sense, and gave us some good conversations.

The whole point of your team's ways of working is that it evolves, and doesn't stay static over the years. Chances are if they do, it's that you're probably not having a mix of people join/leave the team, or getting diverse viewpoints which can help improve the way that you all think about things, and tweak the way you approach things.

You should be regularly reviewing them - we made sure to look at them every time we got to the end of a quarter, as well as when had changes in the team. And if anything came up i.e. in code review that we spent a bit of time going back and forth over, we'd stick that in the technical ways of working, so it was clear for next time.

# Appreciation / Recognition

Something I really liked about Capital One was the culture of recognition. Over the last few years I'd accumulated enough by last May that I had enough "Onederful points" to be able to buy a Dyson vacuum cleaner, two pairs of Bluetooth headphones and a Dyson hairdryer.

(I apologise that seems like a brag, I don't mean it to)

It's by all means not just monetary, because we also had a number of other opportunities to recognise the great stuff people are doing:

## Retro

At the end of each of our sprint-end retrospectives, we had a section for recognition.

It allowed us to take a moment and think about the great stuff that happened from members in team, and in a number of cases, out of team, and we would often fill a Google Jamboard with sticky notes of peoples' great achievements, and then go round the room talking more about it.

It was a great way to end each retro, and because everyone would have done at least one thing worth recognising each sprint, was a really great motivator for folks and gave everyone the warm and fuzzies.

## Town Hall Meetings

Something that the Grow Tribe, that we were part of, did was to have a regular Tribe-wide town hall in which there would be a number of business updates, presentations about things that have launched, etc. As part of this, there was always a section to recognise people for the great stuff they'd done.

Most months of the year, a member of the Pandas was recognised for the great work they'd done, and we had a number of overall winners. Being nominated is a great chance to be recognised for the stuff you're doing, making your accomplishments visible to the whole Tribe, and winning is the icing on the cake, with some Onederful points, too!

It's a lovely way to be reminded you're doing great stuff, and people are noticing and appreciative.

## Onederful

As mentioned, Capital One has Onederful points which allows sending monetary incentives.

When we've interacted with people outside of the team who are doing an awesome job, or we've had someone in-team going especially above-and-beyond, we'll given them some Onederful points.

It's a nice thank you on the receiving end, as someone's gone out of their way to say thank you, and getting a small monetary bonus is nice too!

# Celebrations

Someone's birthday or anniversary at the company are important milestones.

Especially under the Coronavirus situation, where some of the team were more isolated than others, being able to have something nice on the day was something that we could do to make a bit of a difference to having just another day.

We'd scour social media for pictures of the person celebrating, create a Zoom background, and then at standup we'd all switch to the background and start playing a recording of "happy birthday".

For certain events, like big anniversaries, we've even sent cakes!

# Stand Down

Standup would be the first meeting of the day, and although there would be a couple of minutes of chat, we'd then jump into a focussed, work-oriented meeting. When co-located, there would be the chance to chat while walking to/from standup, and it'd give a chance for a bit more conversation, but remotely it didn't lend to this as easily, as well as the fact that remotely it's not as natural to break into splinter conversations.

Especially with us being a distributed team, not meeting in person for almost a year, we wanted to give the opportunity to have a bit more (structured) social interaction. Something other teams had been doing is having a "stand down" later in the day as a mirror to standup.

The stand down would be an unstructured session, in which people could drop in if they had the chance, but weren't required to, and which we'd spend time having non-work-related chats, playing games such as Drawasaurus, and in some occasions talk about work, but generally we'd avoid it. Depending on your working hours, it could be the last thing you did in the day, so would end up being a nice way to ease into the evening.

My previous team had also been doing this with a "coffee chat" twice a day, which also worked nicely, and gave flexibility to folks who may not be able to make it at the end of the day.

# Pair Programming / Ad-hoc support

As a large team of 10-12, we decided to not mandate pair programming, instead focussing it around times where we knew that we'd be able to get good learning opportunities. This came out of experience from being at both sides of the extreme, and wanted to make it something that people could be empowered to ask for, but not feel like they would have to by default.

For instance, implementing a new means for [testing JSON (de)serialisation](/posts/2021/06/02/testing-json-spring-boot/) was something we'd pair on for new learnings, but there were BAU tasks that wouldn't make sense for multiple peoples' time to be used on it.

Although there were often enough stories for everyone to be busy, there would be times that support would be needed for the work currently happening - whether that was a second/third opinion or another person to help debug the thing. Being in a team where we know the benefits that getting that support to unblock you is really important, there would generally be someone willing to park what they're doing to support.

We'd got into good habits of being responsive to help requests, while also being very happy with the fact that folks would need to context switch, so support wouldn't be instant. If it were very high priority, the team would have ways of `@`ing the team on Slack to get eyes more quickly.

# Team Meetings

Something Shama started was the Team Meeting, which has had a load of benefits.

This was a regular time to come together as a team to talk about something that wasn't necessarily work related, but was something that could help us grow as a team.

For instance, we had sessions to talk about facts that others may not know about us, we talked about what we'd like our return to the office to look like, and talked about challenging our biases.

These were really great sessions run by Shama, and gave us an opportunity to come together - something that would be more likely to happen if we were co-located - and learn together.

# Agile Processes

There were a number of things we did, within the SAFe Agile environment we had at Capital One, to improve the way that we could deliver as a team:

## Early refinement

Because we've been bitten in the past by going into PI planning without epics well-refined, we spend time up front doing refinement of epics, with allocated feature champions. Through further experimentation, we found that spending time over the whole PI doing epic refinement led to a happy team going into planning, and much happier out of planning.

## Goals/not

We experimented with a few ways of better visualising what sprint goals were on our Jira board - a mix of using priorities with a filter, and prefixing the story title with `[GOAL]`.

## Capacity

We'd spent a while looking at graphing out how much work we could take in, based on the number of days that each member of the team would be available for, excluding things like ceremonies.

I won't share the specifics, but it definitely helped and gave us at least a rough idea of how many points we could try delivering, especially while we were a fresh team with no idea what our velocity could be.

## Story refinement

Story points are something that every team does slightly differently - which is kinda the point - and as the team grew, became more experienced, and changed as team again, we wanted to try and keep on top of the way we pointed stories.

One thing we did as part of sprint review was to make sure we review whether stories were actually the amount of effort they were pointed at. Where they weren't, we'd record it, so then during refinement, we'd check that points aligned correctly against what was in the tracker for example stories.

In cases where a story had been refined in a previous sprint, and was being brought into planning, we'd make sure that we'd re-refine it, just to make sure that points, acceptance criteria, etc were all still valid - as well as "do we still need to do this story" was answered. We ended up closing a fair few stories that no longer made sense / had been delivered in 10% time!

## Better standups

Something we'd experimented with over time is how we wanted our standup meetings to run.

We've tried various formats, approaches and learned that not being afraid of experimenting one sprint to a next was important.

Especially as we started working in multiple workstreams, including some cross-team collaboration that required multiple teams in our standup, and had different stakeholders at times, we found that we needed to react accordingly, instead of following the same process.

We generally found that focussing on sprint priorities first, making sure updates were to-the-point so that stakeholders know what was going on was prioritised, and then any detailed conversations could be once the board had been run through, or completely out of standup.

I'd recommend try yourself to see what works best for the team, your leadership, and stakeholders who are attending. If you are finding a mix of stakeholders and engineers in the room, see my blog post above about providing the right context.

And as mentioned above, remember to update your ways of working!

# 10% Personal Development Time

Something I really liked at Capital One was that we had a dedicated time for self-directed personal development time, which was called 10% time, as it was allocated to be 10% of our delivery time. We decided to make this our first Friday of the sprint, as it was a good day to do it before we got too busy with sprint work to end up deprioritising it.

During this time, it was generally free for the team to organise how they wanted to do it - with some days being spent pairing, but generally being self-directed.

We've spent it on a number of improvements, such as writing [assertion helpers](/posts/2021/11/04/assertion-helpers/) for our libraries for better experience, looking at how to [use structured logging for Spring Boot services](/posts/2021/05/31/spring-boot-structured-logging/), the initial work for upgrading services to Java 11, and some folks even used the time for Open Source contributions.

It was a great chance to invest in working on things that were interesting to you, and may not necessarily make it into sprint delivery quite yet. We built a lot of interesting things and it definitely helped give folks a chance to invest in different opportunities to sprint work.

## Maintenance Day

Something we didn't get around to trying, but that one of my old teams started doing, was a Maintenance Day.

Some engineers would use their 10% time to get on top of updates to services to i.e. make sure we were on the latest Gradle versions, or using [better dependency management](/posts/2021/08/28/java-bom/), it was noted that we needed to have an extra day allocated to keeping on top of things. Whereas in my team we only had 3 services, this team had more than 10, and a number of libraries, so the maintenance burden was higher.

I've heard some really good stuff out of it, and think that we would've wanted to adopt something similar as the maintenance load increased, even with [Whitesource Renovate](/posts/2021/09/26/whitesource-renovate-tips/) making some of the version bumps easier.

# Team calendar

Something that was very helpful was having a shared calendar that everyone in the team could add events to - generally we'd use this for tracking who was on annual leave, but we'd also organise our ceremonies using this. This central place meant that there was a quick view of "am I missing anything important", but also meant it was super easy to see at-a-glance how many of the team were going to be around on a specific day, as well as us sharing things like whether we were going to be in the office.

This team calendar was also made public, so anyone could pop into any of the meetings organised on the team calendar such as standup, stand down or retro, so we could have our leadership swing by to say hi, which made it nicer than them needing to ask to be invited to specific meetings.

# Using photos on social platforms to humanise each other

With hybrid/remote, not having the chance to bump into people in the office means that there's less chance to build up a personal connection, no matter how small. That's fine, and I'm not saying that only being in-person makes it possible, but there are things we can do while remote to make that easier.

With a default avatar on services like Slack/GitHub/Jira/Zoom/etc, which for a number of interactions with people is all you'll use, it can lead to it being quite an impersonal experience.

By using a photo of yourself, I find that it's easier to remember that behind that photo, there's a human person with a life - especially useful when you're potentially having a moan about something. I also find that by having that, it's easier to chat generally because you get a vague idea of the dynamic you'd have in-person, seeing each other.

This was something I required that as a team we did, and found that it was nice to have the whole team's faces on a Zoom call, even if their videos were off.

I realise that there will likely be some (unconscious) bias introduced by the fact you're seeing someone's appearance, but personally, I would like to think this is outweighed by the benefits of humanising each other.

(Aside: I've not seen any research into the impact of this, or biases introduced - please let me know if there is anything!)

# Slack Etiquette

With Slack being such a prevalent form for our communication, especially while in a remote capacity, we had to do a few things to make it easier to work with:

- Heavily use threads:
  - By using threads, it allowed our team channel (of ~15 people at times) to be more focussed, instead of a long stream of consciousness, and allowed you to dip into each conversation more easily
- Using reactions instead of replies
  - In cases where yes/no/thanks replies were able to be replaced with an emoji reaction, we opted for that to reduce the noise
- Splitting out conversations into channels
  - Something hard to get right, but we wanted to try, was having lots of channels to allow focus - i.e. one for code review, one for all GitHub notifications, one for alerts per service we owned, meeting minutes, etc. It makes a difference not having a massive stream of everything, although has the tradeoff of _yet more_ Slack channels to join!
- Never say "hi" to someone
  - As noted in [nohello.net](https://nohello.net) and [nohello.com](https://nohello.com), it's to great to make sure that you're actually providing someone with the context they need to reply to you. With everyone being on Slack, there'd be a lot of messages outstanding, and if all you had from someone is `hi`, it's hugely unhelpful, especially if someone has something fairly important to ask, but there's the awkward back-and-forth of "hi, how are you"

# Solving Blockers

I was reading [Why the status quo is so hard to change in engineering teams](https://www.okayhq.com/blog/status-quo-is-so-hard-to-change-in-engineering-teams) the other day, and it struck me that [Learned Helplessness](https://en.wikipedia.org/wiki/Learned_helplessness) is something I've fought before, and it's great to have terminology for this.

In the Purple Pandas, we would be happy to get stuck into things to try and reduce these, such as [Improving Team Efficiency By Measuring and Improving Code Review Cycle Time](/posts/2021/10/27/measure-code-review/).

It makes a lot of difference to a team being empowered to be able to solve problems that are hampering their development, or in cases that it's not possible to completely solve it, take actions that can make it less of a roadblock.

# Conclusion

This isn't a prescriptive list of things you should necessarily do to have a team that works well - it very likely won't all work for you, but I'm hoping there's enough interesting viewpoints and a few learnings that you can take away for your own teams.

I'm really happy with how our first year as a team went - we got along as a group of people, we learned over time better ways to work, discuss and challenge opinions, and delivered a fair bit, too, with some great cohesion! As I said, I'm going to miss the Pandas, but I'm really excited to see where the team evolves to next.
