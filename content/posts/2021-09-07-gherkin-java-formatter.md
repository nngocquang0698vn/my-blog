---
title: "Releasing a Java Library for Gherkin Formatting"
description: "Announcing the release of a Java library that can pretty-format a Gherkin feature file."
tags:
- java
- gherkin-formatter
- cucumber
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-09-07T09:15:34+0100
slug: "gherkin-java-formatter"
image: /img/vendor/cucumber.png
---
# Inception

In early July <span class="h-card"><a class="u-url p-name" href="https://www.testingsyndicate.com/">Jack Gough</a></span> and I were talking about my [recent contribution to the Spotless code formatting project to autoformat JSON files](https://github.com/diffplug/spotless/pull/853), and he mentioned that something he was interested in having Gherkin feature files consistenly formatted.

Consistently formatting source code is a hugely beneficial practice - both for existing and new contributors - and it can also make code review much easier.

We spent the next few weeks talking on and off about it, and looking at Open Source options for us to be able to just pull in and use, but we couldn't find anything that was quite fit for purpose, which would be straightforward to use and would allow the configurability we'd want, and ideally would be based on the official Gherkin parsers, rather than being hand-written.

# The Project

I'm happy to announce that as of last night, [<i class="fa fa-gitlab"></i> jamietanna/gherkin-formatter](https://gitlab.com/jamietanna/gherkin-formatter) is now ready for general usage.

If you'd like to use it, the README has details of example usage, but more importantly, you may want to see what a before and after looks like. You can do this by comparing, for instance `datatables_with_comment.feature`'s [before](https://gitlab.com/jamietanna/gherkin-formatter/-/blob/main/src/test/resources/input/good/datatables_with_comment.feature) and [after](https://gitlab.com/jamietanna/gherkin-formatter/-/blob/main/src/test/resources/output/datatables_with_comment.feature), which results in a nicely formatted:

```gherkin
Feature: DataTables

  Scenario: minimalistic
    Given a simple data table
      | foo | bar |
      | boz | boo |
    And a data table with a single cell
      | foo |
    And a data table with different fromatting
      | foo | bar | boz |
    And a data table with an empty cell
      | foo |     | boz |
    And a data table with comments and newlines inside
      | foo  | bar  |
      | boz  | boo  |
      # this is a comment
      | boz2 | boo2 |
```

You can see more examples of pretty-printed output in the [repository's `output` test resources folder](https://gitlab.com/jamietanna/gherkin-formatter/-/tree/main/src/test/resources/output).

# Implementation Details

One of the first things I did when starting this was to think about the test harness I needed to be able to validate that I'd correctly implemented this. Although I've been working with Gherkin for five years, I was sure I'd not got a very deep knowledge of all the edge cases in the language, so wanted to be very sure I'd implemented this right, especially as I didn't want to end up with accidentally removing part of someone's feature files just because I didn't support something!

Although I'd started creating some scenarios, I'm glad I didn't just stick with them, as when I found the [test data the Cucumber project maintains](https://github.com/cucumber/gherkin-java/tree/master/testdata), I realised there's a lot more that needs to be thought about, and a few concepts such as `Rule`s that I'd never seen before.

This gave me a really good footing, and bit by bit I'd started to implement the cases - first without looking at indentation, allowing me to focus on semantics, then adding indentation where appropriate, until last night I finally solved the last test case that was failing.

I've spent about 6 weeks working on the code, and I'd love to say that I was exagerating, but it took at least 7 rewrites to be in the state it is - working, although maybe not my favourite code. I'd spent several attempts trying to use the underlying `GherkinDocument` / `Pickle` / `Parser.Builder`s, but each time I came up against comments, I was stumped, as there were a few cases they were really awkward.

After all these attempts, I went back to a solution Jack had early on, and that solved things, so I guess that's a lesson in of itself.

I've learned a lot more about Gherkin than I'd originally thought I'd know, but it's been a great experience, and I'm glad with the outcome!

# Wider usage

I'm working to get it integrated into the [Spotless project](https://github.com/diffplug/spotless/pull/928), and hope that others get the benefits from it that I am hoping to!

I'm also going to suggest to the IntelliJ folks that maybe they adopt this as part of their Cucumber plugin, which will allow them to remove some custom Gherkin parsing.

Frustratingly, I'd not raised an issue on the Cucumber repos to let them know, which means around the same time I was looking at this, so was [another person in the community](https://github.com/cucumber/common/issues/1662), who [had an initial PR raised the other day](https://github.com/cucumber/common/pull/1725). I'll be working with Nicholas and the maintainers to merge work from this library into their PR, so it's part of the official project, but until then, this library will be available for use independently.

# Future enhancements

As mentioned the codebase isn't maybe the best it could be so I'll look at what I can do to rewrite it, if it remains its own library separate from Cucumber.

I'm [cultivating a backlog](https://gitlab.com/jamietanna/gherkin-formatter/-/issues), so if there's anything that doesn't work, or you would like something else to be added, let me know!
