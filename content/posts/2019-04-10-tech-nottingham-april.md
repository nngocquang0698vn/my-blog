---
title: "Tech Nottingham April"
description: "A recap of Tech Nottingham's April meetup."
categories:
- events
- technottingham
tags:
- events
- technottingham
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-10T21:45:25+0100
slug: "tech-nottingham-april"
---
Usually, for [Tech Nottingham](https://technottingham.com), I just tweet on the day. However, I thought I'd try something different and write a post up afterwards on here as it allows for longer form thoughts, I'm owning my data, and can share these thoughts with a wider community, as well as meaning I spend more time thinking about the talk while I'm in it.

# Error: Property "X" does not exist on type "Genders"

<span class="h-card"><a class="p-name u-url" href="https://twitter.com/aimeegamble">Aimee Gamble-Milner</a></span> spoke about how our technology solutions need to be gender inclusive, and even whether we do need to know about the gender of our users.

Aimee stressed about how we should be careful with whether we actually need to collect a person's gender, and should be really deeply questioning whether we do need to know it - if you have to ask "do I need it?" you probably don't! Likely you only will need it if you have legal reasons to hold it, if you are providing medical information, or potentially trying to communicate appropriately for a user.

Aimee spoke about how we need to normalise Non-Binary identifications, making sure they are visible in drop-downs, and not hidden behind an "other" field. The options should be:

- Male
- Female
- Non-Binary
- Other

With possibly a free-form text box for the "other" options.

We should allow our users to self-define, for instance how Vimeo request the preferred pronouns rather than gender.

Aimee made it very clear that we need to be careful again about logging any of these sensitive details than could lead to outing someone, especially as Transexual/Non-Binary people are not protected.

This is more of an issue with the fact that it is the only protected characteristic that people _actively want to know_. It is classified as a Potentially Personally Identifiable Information, (PPII) because many others share the same trait. But that is only true when thinking in a binary manner - non-binary identifications make one more unique, especially depending on how exactly they identify.

As engineers building systems, we should make it possible for a user to change their name, genders and preferred pronouns, as well as allow them to delete the data from our systems.

Instead of assuming a gender, ask for it! Having a service that takes a name and determines gender is an awful idea and you shouldn't do it!

One comment from the audience was that in i.e. a biography for a blog post, conference talk, you could inadvertently leak your pronouns or how you identify, so we need to be extra careful about that and make it possible to change/remove data.

We need to normalise it - something I've seen commented on in the past is that cis-gendered people need to make it more "normal" to share their pronouns on i.e. Twitter, as well as on name badges. [I'll soon be sharing my pronouns on my website](https://gitlab.com/jamietanna/jvt.me/issues/437).

# If Building A Great Team Is The Question, Technology Is Not The Answer

<span class="h-card"><a href="https://tessacooper.com" class="u-url p-name">Tessa Cooper</a></span> spoke about how technology is ruining our ability to work as a team, because we're trying to solve deeply personal and human issues by throwing technology at them, without actually solving the issue.

Although technology was invented to make lives better, it often makes us shy away from the difficult problems that we have to solve with people, using them as a safety blanket of sorts.

And as a manager, you should be wanting the following:

> I want my team to make progress

Tessa spoke about how we shouldn't jump to using tools to track productivity, or jump to conclusions like "we obviously don't have enough subtasks on stories!" Instead, we should talk about why things aren't progressing as well, and tackle them.

Tessa spoke about how she's used [worry dolls](https://en.wikipedia.org/wiki/Worry_doll) in the past as a way to air problems, which can pick up on problems the rest of the team may not be aware of, both professionally or personally.

And a question to ask your team is "do you know what success looks like?", which will help focus them into what they need to be doing.

> I want my team to _be_ empowered

Tessa took great care to emphasise that _being_ empowered is very different to _feeling_ empowered, and that it's important to strive for the option that allows teams to be self-sufficient. Tessa found that asking two questions really helped people think about this better:

- What is one thing you'd change about (the company) in the next 6 months?
- How can you help make this happen?

> I want my team to make decisions

If teams can't make their own decisions, then what's the point? We don't want to be putting everything on a roadmap, or going to committee for decisions.

For instance, a design team can set out design principles, which means that development teams can make decisions themselves, within these guidelines.

We should be removing bottlenecks and getting decisions closer to the people doing the work, similar to [Damon's talk at DevOpsDays London 2018]({{< ref 2018-10-25-devopsdays-london-2018 >}}#tickets-and-silos-ruin-everything).

Also, we need to make sure that we're not shifting responsibility to i.e. inflate the ego of management to make them feel important that they get to make the decision.

We need to make sure that we have diverse teams with different interpretations of guidelines, which leads to innovation and new ideas.

> I want my team to collaborate

Instead of shoving lots of technical solutions in the mix, we should realise that technology hides nuances of body and verbal language, which tells us whether an idea actually makes sense. Yes, distributed teams will need to work with video conferencing, but still, it should be allowing everyone to see each other's reactions and the human side of a conversation.

> I want to know when my teams have a problem

If a manager isn't aware of problems in the team, they can't help. This is a communication issue, not a technology issue. And if the team isn't aware that they're late on deadlines, or their colleagues are going through difficult personal circumstances, then they can't help.

There was a question from <span class="h-card"><a class="p-name u-url" href="https://twitter.com/MrAndrew/">Andrew Seward</a></span> around how to _retire_ processes. The key answer was that we need to make sure that we don't create another process to describe how to retire a process!
