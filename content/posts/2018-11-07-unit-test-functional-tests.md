---
title: Why You Should Be Unit Testing Your Functional Acceptance Tests
description: A few reasons explaining why you should be writing unit tests for your functional tests.
categories:
- persuasive
- software-testing
tags:
- persuasive
- testing
- software-testing
- tdd
- bdd
- cucumber
- software-quality
- quality-engineering
- unit-testing
date: 2018-11-07
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: unit-test-functional-tests
---
If this seems like a crazy idea, I recommend you to carry on reading, as it just might change your mind!

The reasons for why I'm such a strong proponent of this is down to what I work on. I've briefly touched upon this topic in [_Creating a versionable, self-contained (fat-/uber-) JAR for Cucumber tests_][cucumber-jar], as well as speaking about it at meetups or conferences, but for those that aren't aware, I work on the Customer Identity Service at Capital One. This service is a commercial off-the-shelf product which requires more configuration than code.

This means that the "built artefact" is actually a collection of Chef cookbooks, a Java deployable application, and some JSON files that define what configuration should be applied. This configuration is required to convert the deployable application code into the full "application", which means we can't easily test all the system functionality in isolation i.e. on a PR build.

Running our full Acceptance and Performance tests requires a deployment of our application stack to our AWS development environment, which currently has a turnaround time of 2 hours!

We'd originally had our tests in the same repo as it was quicker to iterate, but after having some time to rearchitect our setup, we split them into a separate repo. However, if we were to have any confidence in our new changes to our Acceptance or Performance Tests, how could we validate them?

Well, that's where our unit tests come in. By having unit tests for both our Cucumber steps and the underlying helper functionality, we'd be much more confident that our tests would work when we actually came to run them. This can also help us catch potentially breaking refactorings that we wouldn't catch until we ran them.

It was a hugely beneficial approach, not least because we couldn't run them when we wanted. This wasn't a novel idea for a test-first, test-heavy team who was already approaching this as standard. This approach was still useful on a service that _was_ easily able to run through the tests in your build/test process.

Now you have a little context on why we've taken this approach with testing, below I've written some further reasons you too may want to follow this.

# Unit tests provide confidence

The reason we write unit tests (in general) is to build greater confidence in the code we write. This can be used as a tool to drive the design of our code, a-la-TDD, or at least it can be used to ensure that the code we've written returns an expected output for some input.

Feature delivery teams will most likely be unit testing their own code to gain confidence in their features, so we should too, to have the same increased confidence in the functionality of our test suite.

This also gives us a much greater confidence in performing refactorings on the existing code base, as broken test cases can help us catch any change in class/method APIs, as well as potentially breaking expected return types.

If we follow the process of making sure our Cucumber steps are also well tested, this helps us gain confidence that when we perform a real test run, we'll be much more likely to have everything working successfully.

# Test-driving our test's API

This can be a contentious point, so take this with a pinch of salt, but using TDD as a way to drive the design of your methods and interactions is a valuable tool.

Working in a heavy TDD team has helped brainwash me somewhat, but I've found it is a really great practice in line with writing the steps first.

# Don't be lazy, even if you can

It's easy to be lazy, I get that. As engineers, laziness is one of our best (and worst) traits. When the component you're testing is small, you can easily spin it up in your build/test process to check your functional tests pass. Why would you want to invest in writing some more tests, which requires up-front investment, when you can instead just keep running and refactoring the functional tests themselves until they pass?

My example above is different, you say, as it's a complex application which requires extra confidence in the tests and steps to ensure we're doing things right, whereas what you're working on isn't that difficult.

This sounds like you don't want to put a little extra work in now to help yourself in the future. Have you ever seen Jurassic Park? Just because _you can_ doesn't mean that you should!

You should be more than happy that your unit tests cover core functionality, so that when they _do_ get run, the only thing that may trip you up is how the scenario steps get mapped to the underlying code.

It gets harder the more you have to do in order to get your tests running, and balloons in complexity when there are multiple components that need to be in place.

However, if you look at the unit level, it's super simple. There's nothing else you need, and you can just get it running in, most often, literally seconds.

# Test-first, for contracts, not implementation

Although I'm a massive fan of cross-functional teams where engineers responsible for functional tests will work very much alongside engineers responsible for functionality, I would love to be writing my functional acceptance tests before a line of implementation code is even thought about.

For instance, I'd love to be in a place where I can create a new branch, read the documentation for the API contract, after which I'd write a new test scenario or two and then push that branch. This would then wait for "the devs" to implement the functionality, after which they can verify they're exposing the contract correctly. But there may be no way to run the tests against the finished product, so we have to have some confidence that what we've written works.

We're not writing the tests _after_ the functionality is implemented and then running it to make sure that the tests match what's been written. The test has to be created separately, honouring the specs, which we can drive through the tests to ensure we're happy with our implementation.

# Speed of execution + faster feedback

Unit tests are meant to run as quickly as possible, preferably in sub-second measurements. They provide a much faster level of feedback than running our full suite of tests with their full HTTP request/responses.

Because we don't need to have everything up and running each time we run a test, it means we can close our feedback loop considerably. If we had to wait 2 hours every time we did a one-line change, we'd be losing our minds.

# "Quality" Engineering

As a software tester/quality engineer/&lt;insert job title here&gt;, you're almost certainly responsible for ensuring quality in the software you build. So why would you not want your verification tests to be written to the same level of quality?

If developers are writing unit tests to ensure their methods and classes operate correctly, why would you not? Aren't we, as quality engineers, meant to be paving the way and helping guide developers to building truly quality software?

Additionally, by building your test suite in this way, you can start to monitor code quality of your tests themselves. This allows us to investigate whether our code functions correctly, through code coverage and [Mutation Testing], as with all other pieces of code on the project.

# Closing Remarks

I would thoroughly recommend this pattern for all the reasons detailed above.

As mentioned, I've found it most beneficial being in a place where the feedback loop is measured in hours. It's easy to be lazy and think that it won't affect you, or you don't need to put the time in, but at some point it will bite you - so I'd urge you to start writing your tests now! It'll only make the future easier, and may even help you pick up some implementation bug.

And if you're following this pattern with Java, I'd greatly recommend creating a [Cucumber JARtifact][cucumber-jar]. This is a really great pattern for improving the split of your implementation (Cucumber) code and the unit tests itself.

[cucumber-jar]: {{< ref 2018-08-16-self-contained-cucumber-jar >}}
[Mutation Testing]: https://en.wikipedia.org/wiki/Mutation_testing
