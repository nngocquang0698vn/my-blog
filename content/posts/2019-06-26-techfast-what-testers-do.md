---
title: "Notts Techfast: What do testers even do all day?"
description: "A writeup and some thoughts about Dan Caseley's talk at Notts Techfast."
tags:
- events
- notts-techfast
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-06-26T18:52:51+0100
slug: "techfast-what-testers-do"
---
<div style="display: none">
  This post is a reply to <a class="u-in-reply-to" href="https://www.meetup.com/Notts-Techfast/events/262030947/">https://www.meetup.com/Notts-Techfast/events/262030947/</a>
</div>

This morning [Dan Caseley](https://twitter.com/fishbowler) gave a great talk at [Notts Techfast](https://twitter.com/nottstechfast) titled _What do testers even do all day?_ As a Software Quality Engineer (tester) I was interested to see what he was going to say, and if I learned anything new about my job - which fortunately, I did!

Dan started by talking through some of the common misconceptions folks believe about testing:

- it's a checkbox exercise
- we're documentation people
- automation can replace manual testing

Dan spoke about how, like many things, there is no such thing as "_the_ way to test", or any silver bullets. There are good and bad practices, but you can also take a good practice and do it horribly wrong!

Dan noted that it is important to deliver value to the Software Development Lifecycle, and providing value to the business, opposed to a story where he worked with NATO and their attitude was "if you don't have a heavy binder, there's no testing done". As Dan mentioned, this doesn't actually add any value to the business because if you've spent that much time documenting it, you will have therefore spent less time on actually testing, which decreases the value you will have delivered.

# Test Scripts

Dan spoke a little about how test scripts are treated as "old knowledge" that we should trust, but that they're not actually as useful as people think.

These test scripts are a set of steps, with an expected outcome. But as these are very subjective, they are often difficult to make easy for someone to pick up and get working straight away, the fix for which is then at the cost of verbosity.

Unfortunately, they're also very rigid, devalue almost immediately as things change, and are costly to write because they're step-by-step.

Dan gave the example of having a box with button and asking us how we would test it, taking us through lots of seemingly limitless possible options.

# Automation

Automation and its place in testing inevitably came up, and Dan used the time to talk about its good and bad.

On the good side, automated tests are repeatable and never vary which is great for repetitive tasks, and especially for removing human error from the equation. However, they're also _only repeatable_ - the tests can't do anything different than what we've told them!

Because the test does exactly what we tell them to do, it doesn't have the issue of human judgement getting in the way of executing a step, but then it means we have to tell it everything it needs to do.

Because it's a computer operating on the system under test, it can work much, much, much faster than a human, even working in parallel. However, that means you're operating much faster than a real life human, so may be missing certain conditions that only occur when doing things slowly. It's also going to be unrealistically parallel - a user couldn't work on 8 things at once, so is it really testing the right things?

Unfortunately, but also fortunately, we're never going to be replacing humans. But we can work to remove boring, repetitive work and allow the testers to look at do more meaningful work.

Dan recommends using automation testing for validating enforced constraints i.e. a contract or when using external APIs. Automation helps us pick up on expected things, whereas "real testing" picks up on unexpected things.

Dan warned us that we should be writing as few UI tests as possible - we'll be able to write an infinite number of tests, but likely not test the back-end interactions we need to check, nor will it capture issues like the images not being there.

Dan shared an interesting example of never seeing a project having a project with a specification to say "the images are never the wrong way round". This is something that you need "real testing" to pick up on, by having a human in the mix to discover what happens in certain cases. The same is true with an automation test to verify that i.e. the Nottingham Council House exists in the skyline, which will pass even if the sky is on fire, because _technically_ it is there, but the environment isn't quite right.

I find this interesting because my main angle for testing is to remove the manual steps and make everything automated, but at the same time I've also seen (many a time) the benefits of manually testing flows to check they operate OK, especially for not-easily-automatable flows.

# Types of Testing

Dan listed and spoke a little about some of the options of types of tests you can undertake:

- Functionality
- Usability & Accessibility
- Security & Penetration
- Performance, Load, Reliability & Scalability
- Installability, Compatibility
- Supportability & Auditability
- (Testability & Maintainability)

Dan also spoke about two other terms used a lot:

> Heuristics: pretentious wording for some mnemonics & cheatsheets, so that people think testing is “science”

> Oracles: references for information, and are often used alongside heuristics

And then shared a couple of good resources:

- [Quality Tree Test Heuristics Cheat Sheet](http://testobsessed.com/wp-content/uploads/2011/04/testheuristicscheatsheetv1.pdf)
- [Test Insane Heuristic Table of Testing](https://twitter.com/santhoshst/status/660535773905588225)

# What we do

Dan shared the below quote with us:

> Testing is an empirical, technical investigation of a product, done on behalf of stakeholders, with the intention of revealing quality-related information of the kind that they seek. - Cem Kaner

Dan noted that it's all about investigation of the product, being driven by the stakeholders' (i.e. users!) requirements, which then leads to "quality-related information", which Dan noted was **not** the same as bugs! Because it may be acceptable, or low-priority changes rather than a full-on defect.

We need to be driven by our stakeholders, because i.e. the load testing of an application doesn't really matter if there's only one user.


There was a good audience question about identifying the most important parts to test - Dan mentioned that the best way to do it is to work with stakeholders and investigate together what the priority could be. For instance, can they rank/rate what types of tests they'd want? What if they had to choose between reliability and availability?

And Dan's final comment (following on from a comment from the audience) was that having a culture of shared ownership has a much better impact on the quality and approaches of the team(s) compared to adding testing in all the places!

This was a great talk and it was good to hear from another tester in terms of what they do and how they feel about what they do.
