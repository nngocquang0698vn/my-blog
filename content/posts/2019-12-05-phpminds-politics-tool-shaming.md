---
title: "PHPMiNDS August - the Politics of Tool Shaming"
description: "A writeup of James' talk at PHPMiNDS about the impacts of criticising others for their technology choices."
tags:
- events
- neurodiversity
- inclusivity
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-05T11:56:35+0000
slug: "phpminds-politics-tool-shaming"
---
# Introduction

At [PHPMiNDS](https://phpminds.org) [in August](https://www.meetup.com/PHPMiNDS-in-Nottingham/events/263270719/) we had a talk from <span class="h-card"><a class="u-url" href="https://devtheatre.net/">James Seconde</a></span> about [The Politics of Tool Shaming](https://devtheatre.net/tool-shaming/) which was defined as the act of criticising or attacking others for their choice of technology.

This is unfortunately something that many of us have been on the receiving end of, and I will admit that I've also been on the giving end of it, too.

James started off by talking through the true pioneers of Computer Science - Ada Lovelace, Grace Hopper, Katherine Johnson and Margaret Hamilton. This was a time where the men would do the "manly work" and work on hardware, whereas women would be doing the software. Once computers came into the home, it became very hard for women to get into using them because they became a "man's toy".

From this as a basis, James fast-forwarded to [the 1995-06-24 Dilbert strip](https://dilbert.com/strip/1995-06-24) where we're seeing peoples' use of technology starting to define them, in this example as "one of those condescending UNIX computer users".

However, we know that this isn't true at all, because a tool is just a means to an end (albeit the above comment was based on some realism). Someone working on mainframes may not be working on hip Go microservices deployed to Kubernetes in their free time, but it sure doesn't mean that they're less of an engineer because they'll have a wealth of knowledge from everything leading up until then.

I've seen this before with folks looking down on front-end/full-stack development teams as "just doing colouring" or "not being real developers", but as the wonderful <span class="h-card"><a class="u-url" href="https://carolgilabert.me">Carol</a></span> puts it, maybe the people saying that are just scared of the difficulties of building cross-browser and ecosystem CSS and Javascript? It's not like creating a JSON API is that difficult compared to making a feature-rich application working across many browsers, Operating Systems, and devices, so why do backend developers look down on everyone else?

# James' Journey

James took us through his journey as someone without a Computer Science background coming into tech and having some really toxic experiences.

For someone already having some pretty strong imposter syndrome (sidenote: I'd recommend a listen of the [Ladybug podcast's episode on imposter syndrome](https://www.ladybug.dev/impostor-syndrome)), but meeting some more senior developers with strong opinions didn't really help much.

In the space of a year, James had gone through three different PHP frameworks, and was asking some questions of this cycle:

> how am I going to keep up?

Having to constantly be on top of all the latest and greatest tools and practices, especially for fear of ridicule was already beginning to cause serious burnout and heighten his imposter syndrome.

> how can self-taught folks keep up with this?

> how can taught people keep up with this?

But as well, what about for the folks who are from a traditional background, learning about i.e. Java/.NET, design patterns and relational databases? Would that really teach you enough to build an Angular app one day, and then the next be using React? Unlikely!

James then took us through some of the things he's heard from folks. Unfortunately I didn't get these quotes down verbatim, but that's probably for the best as they're all pretty shocking, yet worryingly familiar.

We heard about how "you're a bad dev if you use Jetbrains products, because they do too much work for you" and that "people working with WordPress aren't real developers", and a lot of other hurtful, horrible statements, that unfortunately many people reading will recognise.

James also touched on the fact that someone saying something about a language isn't necessarily tool shaming. For instance, saying that i.e the older versions of PHP were quite buggy could be objectively true. But saying "using that old version of PHP makes you a bad developer" would be classed as tool shaming.

James mentioned that [_PHP: A fractal of bad design_](http://me.veekun.com/blog/2012/04/09/php-a-fractal-of-bad-design/) is a good (but now out of date) read as it shows how to talk about a language's bad design without insulting the people writing it or developing with it.

# Impacts of Tool Shaming

So what happens if your culture breeds these occurrences of tool shaming?

- You'll hurt peoples' feelings, regardless of whether that's the intention.
- You'll scare them off, most likely losing a lot of good domain knowledge from your business, and it's likely that they wouldn't want to hand over as much of their knowledge when they leave
- Whether or not they leave, they _will_ talk to other people. And those people will be less likely to want to work in that environment - bad referrals travel and seriously harm your business
- You'll make people less likely to share their thoughts or look to collaborate with others if they're constantly worried that they'll be attacked for their choices, which leads to silos in your organisation
- You'll make more people like you - more people who see it as an "okay thing to do" will do the same, and the circle of bad attitudes will continue and become a vicious cycle
- It also has other impacts on your recruitment - if you ask for a "senior React engineer with Zend framework", then the chances are that you will be already getting a small group of relevant applicants for the location you're in

James also brought up the fact that at the end of the day, your clients or your Product Owner, won't care whether you use Emacs or Vim, they just care whether you're delivering what they're paying you for!

I'd recommend [Alex Stanhope's talk _Fighting toxic working environments_ from DevOpsDays London 2019]({{< ref "2019-10-12-devopsdays-london-2019" >}}#fighting-toxic-working-environments) where he talks about what it's like trying to get out of a toxic work environment, and that'll also help convince you that you really shouldn't make it one.

Technology and Software Engineering is now so much more diverse than it used to be - not just gender identity or race, but whether you have formal education, as well as neurodiversity, and even to the job role. We have so many different lovely people who are now involved in what it means "to be in tech", that we need to make sure we're not actively shunning them by being dogmatic or horrible people.

James spoke about how we should abide by [Nudge Units](https://en.wikipedia.org/wiki/Behavioural_Insights_Team) and that when these situations appear, we push back on them. By slowly nudging perceptions and pushing back on comments, we can slowly move the industry away from it.

# Closing Thoughts

This was an interesting talk from James, and it helps bring attention to an important issue. Fortunately I feel like the people I work with and the friends I have in the tech communities are onboard with this, so it wasn't anything controversial for me to hear, but we need to see how we can get the message out to folks who aren't attending these meetups or realising the damage they're causing.

I used to use PHP a fair bit before others made me want to learn something different because they saw it as a lesser language, and I've also had conversations with folks that feel like unless you're using a programming language that compiles to a binary, you're doing it wrong.

From someone who co-organises a PHP meetup (despite not being a PHP dev) I still hear a lot of tool shaming for folks using it, which really sucks. It's especially true where some people have been burned by bad pieces of software or outputs from these tools, and I think for some things, having a lower barrier to entry increases the risk of not as good tech out there. You can see this more recently with the Javascript ecosystem, and various incidents like [left-pad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/). But they do also see this tool shaming too, so :shrug:.

This is an interesting thing because I'd love to be able to find out why folks tarted to get these ideals, and what we'd be able to do to resolve this, aside from making sure that every conversation has someone who's at least a bit kind.
