---
title: "Ignoring slow-running tests in Go"
description: "How to use Go's `-short` testing mode to avoid running slower tests."
date: 2022-07-01T16:23:11+0100
syndication:
- https://brid.gy/publish/twitter
tags:
- "blogumentation"
- "go"
- testing
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-short-test"
---
If you're writing software in Go, you're likely to not be hitting any particularly slow tests, as the language and tooling is very efficient.

But sometimes there are tests that you don't want to execute when `go test` is run, for instance if they're full integration/application tests, or are exercising external integrations like a database.

Fortunately, there's a built-in means to do this using `go test`'s `-short` flag. This allows us to run:

```sh
# ./... for the whole module, or you can specify a given package
go test -short ./...
```

Then, in the tests, we can follow the [documentation](https://pkg.go.dev/testing#hdr-Skipping), and where we can self-select tests that will be likely to run slowly, we can skip them if running in short mode:

```go
func TestTimeConsuming(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping test in short mode.")
    }
    // the test
}
```

This is super handy for isolating larger tests, and giving you the chance of making sure you have the fastest feedback for your code changes!
