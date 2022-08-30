---
title: "Gotcha: testable examples in go need an `output` comment"
description: "Beware that your Go `Example` tests may not actually be running."
date: "2022-08-30T09:20:36+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1564531464150073345"
tags:
- "go"
- "testing"
- "blogumentation"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "gotcha-go-example-comment"
---
One thing I really like about building libraries in Go is that you can create [testable examples](https://go.dev/blog/examples) as a first-class citizen of the testing framework. This allows writing example code in the repository in a way that can make sure that expected use cases are always valid and do not break, but because it's annotated as an example test case, it then gets surfaced in documentation as examples.

For instance, we can see the below code which shows how to parse some HTTP Accept headers and the resulting response when printed out to `stdout`:

```go
// source via https://gitlab.com/jamietanna/content-negotiation-go/blob/299506d7f0487fefb9e2f1f828c7c306cbe211f9/acceptheader_test.go#L38-47
func ExampleParseAcceptHeaders() {
	parsed := contentnegotiation.ParseAcceptHeaders("text/html", "application/json")
	for _, mt := range parsed {
		fmt.Println(mt.String())
	}

	// output:
	// text/html
	// application/json
}
```

One thing you'll notice is that we've got this `output` line, which checks what output is returned from the example.

This is the crux of this post - if you don't have this `output:` line, your test will not be executed, and although it'll be compiled, it will never execute in your tests.

I found this when working through a few internal libraries, and noticed that by changing functionality in the tests - that were designed to make them fail - I saw no errors.

The solution is to make sure that you're always asserting on the `output:` of an example test, but trying to remember that all the time is difficult, so I've [raised this upstream at `golangci-lint`](https://github.com/golangci/golangci-lint/issues/3084) as something we may want to surface in linting. And lo and behold, someone has already prepared a check for it - Open Source is great!
