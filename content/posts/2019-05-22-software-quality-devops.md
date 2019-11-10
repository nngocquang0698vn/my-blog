---
title: '.NET Notts May: Software Quality in the DevOps World'
description: A writeup of Matteo's talk at .NET Notts about Software Quality and DevOps.
tags:
- events
- dotnetnotts
- software-quality
date: 2019-05-22T20:24:48+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: software-quality-devops
aliases:
- /replies/6dfae7bb-9561-439f-a4ce-18c4edff26f7/
- /mf2/6dfae7bb-9561-439f-a4ce-18c4edff26f7/
---
This is a writeup of the <a href="https://www.meetup.com/dotnetnotts/events/261020929/" class="u-in-reply-to">.NET Notts May: Software Quality in the DevOps World</a>.

[Matteo](https://mattvsts.blogspot.com/) kicked off the session by asking the audience some questions:

> who has an automated build pipeline?

> who quality control, that doesn't include manual steps?

> what does your pipeline look like?

To this last one I mentioned about how in my team we've got a fully automated build + deployment pipeline with a number of system tests, including various key regression tests. Which seemed like a shock to most of the room, as they had mostly manual testing everywhere.

But then we started talking about "what actually is quality". We talked about how it's not just whether you've got all the test cases passing, or what code coverage percentage you have, but it's about whether the code is maintainable, or whether it follows good patterns. It's not just the testing, but the practices.

And of course, we've all met people who say:

> my code is perfect, it doesn't have any bugs

To which we can say that "works != quality".

DevOps has been based upon the foundation of quality, ensuring that we can reduce cycle times and ship early and often, owning our products all the way to production. Automation is key to building the greatest value through maximum quality.

We need to be careful of what checks we do, as there is a difference between objective (i.e. cyclomatic complexity) and subjective (i.e. tabs/spaces) measures.

Matteo spoke about "two camps" of quality:

- industry standards i.e cyclomatic complexity, secure coding standards
- team standards i.e. code style, coverage, patterns

We need to make sure that we apply quality in terms of the processes and practices, otherwise we are just adding gates that no one believes in.

This is different to i.e. fulfilling the spec, as a specification isn't just what you want. For instance, do you want something with a warranty of 1 year, or that (feels like) it's built to last a lifetime?

Remember the quote:

> even the best craftspeople need a helping hand

Instead of thinking "I can do it all myself", realise that you're fallible, may have an off day, etc. Look to automating cruft and focussing on the important things.

We have a few ways to enable quality and raise the bar, with tools:

- automated build pipelines
- code quality gatherers
- security vulnerability scanners
  - Dynamic Application Security Testing (DAST i.e. Zapp) - at runtime
  - Static Application Security Testing (SAST) - without running it
- force your PRs to require a successful build before it can be accepted

Or with practices:

- peer review
- bug bashes
- Test Driven Development
- secure development lifecycle
- continuous integration (in the true sense of the term, not automated build pipelines)

It's very much recommended to embed quality checking with a tool like Sonarqube, as it provides all the goodness of linting and quality checking i.e. cyclomatic complexity. It's preferable to use SonarLint which means it is done client-side, instead of needing a connection to your server.

Useful too is licensing scanning, i.e. to determine whether you're in risk of violating business rules, or at risk of violating GPL.

You should also look at security scanning, i.e. Whitesource, to help pick up on security issues in dependencies.

In the Java world, you can use Checkstyle, PMD and FindBugs which achieve similar, in the comfort of your own build process.

With Azure there are a tonne of other services to help secure your applications, such as security scanning your Azure templates to find out if you're doing anything insecure. There are also a number of other secvices in Azure you can use for locking down your security.

Matteo's recommendation is:

- use circuit breakers as a great way to isolate problems if i.e. a service is unexpectedly broken
- add deployment gates, so you can only promote artefacts when they're ready
- define patterns, and embed the quality mindsets, instead of it being a checklist that people are forced to go through
