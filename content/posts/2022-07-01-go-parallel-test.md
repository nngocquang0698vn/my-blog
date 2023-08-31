---
title: "Running Go tests in Parallel"
description: "How to get Go tests to run in parallel for speed."
date: "2022-07-01T16:52:53+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1542901723035062272"
tags:
- "blogumentation"
- "go"
- "testing"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-parallel-test"
---
If you're writing software in Go, you're likely to not be hitting any particularly slow tests, as the language and tooling is very efficient.

But as written about in [Default Your Tests to run in Parallel](https://www.jvt.me/posts/2021/06/01/parallel-tests/), I recommend always running in parallel, so you can surface implementation issues, as well as further speed up an already quick codebase.

As highlighted on [StackOverflow](https://stackoverflow.com/a/44326377/2257038), and in the docs for `go help testflag `, running parallel tests via `go test` require the `-parallel` flag:

> -parallel n
>     Allow parallel execution of test functions that call t.Parallel, and
>     fuzz targets that call t.Parallel when running the seed corpus.
>     The value of this flag is the maximum number of tests to run
>     simultaneously.
>     While fuzzing, the value of this flag is the maximum number of
>     subprocesses that may call the fuzz function simultaneously, regardless of
>     whether T.Parallel is called.
>     By default, -parallel is set to the value of GOMAXPROCS.
>     Setting -parallel to values higher than GOMAXPROCS may cause degraded
>     performance due to CPU contention, especially when fuzzing.
>     Note that -parallel only applies within a single test binary.
>     The 'go test' command may run tests for different packages
>     in parallel as well, according to the setting of the -p flag
>     (see 'go help build').

But it _also_ needs us to explicitly opt in tests by making the following change:

```diff
 func TestTimeConsuming(t *testing.T) {
+    t.Parallel()
     // the test
 }
```

This is a bit of a shame, as it'd be great to be able to parallelise by default, but I get that it's useful to allow tests to opt-in.

You may also want to read <span class="h-card"><a class="u-url" href="https://brandur.org/">Brandur</a></span>'s post [On using Go's `t.Parallel()`](https://brandur.org/t-parallel) as there are some interesting points on the practicality of it.
