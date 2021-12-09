---
title: "Default Your Tests to run in Parallel"
description: "Discussing the benefits you can achieve by having parallel-by-default."
tags:
- software-quality
- software-testing
- quality-engineering
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-01T14:50:43+0100
slug: "parallel-tests"
series: writing-better-tests
---
One of the things that I've found is that we often don't think about setting up our test suites to run in parallel.

Although our tests usually start as being pretty lightweight and quick to run, we naturally increase test coverage as we increase functionality of the project, which means the test execution time increases to the point where it can take anywhere up to 10 minutes to verify our codebase still works after a change.

One of the options we have for speeding things up is to delete tests. A more reasonable interpretation of this is to shift tests left by moving expensive system/component tests into unit / unit integration tests, where makes sense.

Although I'd 100% recommend that (and will [blog about how to do that later](https://gitlab.com/jamietanna/jvt.me/-/issues/1084)), a shorter term solution is to look at tweaking your test suite to run in parallel, utilising multiple threads to action your test suite more effectively.

I'd recommend starting by parallelising the build process, in the Java world, [using Maven](https://cwiki.apache.org/confluence/display/MAVEN/Parallel+builds+in+Maven+3) or [Gradle](/posts/2021/03/11/gradle-speed-parallel/) as an initial boost to make the local process a bit quicker.

Next, we actually want to parallelise the tests. In Java, this depends on the test tooling you're using, but [JUnit5 can be straightforward to parallelise](/posts/2021/03/11/gradle-speed-parallel/), and Cucumber has some [good official documentation](https://cucumber.io/docs/guides/parallel-execution/) for setting up parallel execution.

I'm not saying that this will solve all your problems, and definitely comes with some gotchas both initially - when you discover there's some implicit ordering for tests - and during maintenance - when trying to keep things successfully running in parallel - but it does have some great benefits!

As mentioned in [_Writing Better Wiremock Stubs_](/posts/2021/06/01/better-wiremock-stubbing/), by having a test suite that runs in parallel, it makes it easier to take what you're running locally and have it running against an integrated environment, with other people doing similar, with a low chance of causing overlap issues.

It also leads to the ability to catch implementation issues in our tests, and in rare cases, our production code itself!
