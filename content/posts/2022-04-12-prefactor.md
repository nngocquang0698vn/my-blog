---
title: "Prefactoring: Preparatory Refactoring"
description: "Why I use prefactoring as a means to perform up-front refactoring for\
  \ codebases, splitting these into separate PRs/MRs where possible."
date: "2022-04-12T21:03:48+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1513973505662062593"
tags:
- "blogumentation"
- "git"
- "workflow"
- "refactoring"
- "code-review"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/53239026de.png"
slug: "prefactor"
---
Whether you're working on a new feature, a bug fix, or maybe even just a documentation tweak, touching an codebase gives you the opportunity to spot areas for refactoring.

A few options occur - raise a ticket in your backlog to resolve it, resolve it when you discover it, or resolve it after the work has been done.

I tended to lean to the latter option until one of my ex-colleagues Lewis introduced me to term _prefactoring_. As with many things in Software Engineering, it's been [written about](https://martinfowler.com/articles/preparatory-refactoring-example.html) by <span class="h-card"><a class="u-url" href="https://martinfowler.com/">Martin Fowler</a></span>, who defines it as:

> refactor the code into the structure that makes it easy to add the feature

By doing a prefactor, we can target the refactoring needed before we start working on the rest of our changes and I've found this hugely useful, as it gives us a much easier way to make the refactor without also having to take account of any new changes, which can further complicate and slow down code review on these changes.

These changes are definitely their own atomic commit, but depending on [the efficiency of your code review process](/posts/2021/10/27/measure-code-review/), I've found it's also great to get those prefactors raised as at least one, but sometimes maybe even multiple, PRs/MRs, so we can get the prefactors reviewed + maybe even merged before the feature is finished.

This gives a much smaller scope of change for a reviewer, which depending on the scale of the refactor could be quite an impact, and I'm sure reviewers will appreciate three small PRs and a big one instead of one very big one!
