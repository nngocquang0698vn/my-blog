---
title: "Idea for Open Source/Startup: monetising the supply chain"
description: "An idea I've had for how to better distribute support to Open Source libraries in the supply chain for your software."
date: 2022-06-01T22:06:19+0100
syndication:
- https://brid.gy/publish/twitter
tags:
- ideas
- security
- open-source
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "idea-supply-chain-monetisation"
---
While at Capital One, one of my colleagues was working on a side project to look at dependencies we were using, as a means to better understand our dependency trees, and lead to easier determining of when we needed to do dependency upgrades.

It'd got to a pretty great place, just as we'd started to adopt [WhiteSource Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/), so we were discussing other options for it, as it was now redundant for that original purpose.

Among other options raised, I suggested using it as a way to understand what libraries we were using, across our software estate, and use it to more appropriately distribute (financial) support to our projects.

As the [xkcd comic highlights](https://xkcd.com/2347/), a tonne of projects are maintained by very few folks, and if you understood that i.e. 80% of your company's critical infrastructure was in the hand of a couple of projects, maybe you'd want to do something about that.

Now, providing financial support isn't always the solution, as you may have hobbyists who just want to work on what they're doing, and not need to answer to paying customers (who may feel a little more entitled for work to be done) nor may the money get through the foundation to the handful of developers on a library, as we saw with Log4Shell.

For instance, I'm a hobbyist who has enough of a problem prioritising my own projects and efforts, as well as [the Open Source libraries I maintain](/open-source/), so I can definitely see why being paid for work can be difficult.

But even if the projects aren't set up for financial contributions, there may be other things you can do with that information, even if it's just getting contributions going upstream, or looking at how the maintainers can be supported if they were to need a hand, as well as whether your company could support development through a fork.

I feel like this could work really nicely in partnership with a supply chain healthcheck like [Socket.dev](https://socket.dev/), and would be able to provide an easy way for companies to say "we want to give ££££/month for Open Source, where is best?" and it spit out a prioritised list by how much it's in use by your projects.

Maybe I'll end up looking at it one day, but you're welcome to the idea, just gimme a shout out 😉
