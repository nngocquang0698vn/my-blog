---
title: "Introducing a library for OpenAPI contract testing with Go's `net/http` package"
description: "Creating a Go library that can verify `net/http` handlers implement\
  \ an OpenAPI contract, for use with testing."
date: "2022-05-22T19:00:12+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1528438121892913152"
tags:
- "go"
- "openapi"
- "testing"
- "contract-testing"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: "go-openapi-contract-test"
---
I've recently been working on building a Go API, which is driven through an [OpenAPI](https://openapis.org) specification, and has almost all of the code generated through the awesome [oapi-codegen](https://github.com/deepmap/oapi-codegen).

One of the common concerns of using OpenAPI, or really any documentation, that is always difficult is keeping the documentation up-to-date with the implementation, which is hard regardless of how big your project is, and how much of the code you can generate from your documentation, or vice versa.

Even worse is spending a lot of engineering time on a feature, shipping it, and then finding out that you've broken your contract with the consumer, and you need to think about rolling back, or fixing forward.

Contract testing is the solution to this, and allows us to think about it much earlier in the life cycle, giving service owners the chance to discover issues much sooner, and fix it before it causes outages.

There's an excellent [post on the APIs You Won't Hate blog](https://apisyouwonthate.com/blog/contract-testing-apis-laravel-php-openapi) in a similar vein for a Laravel PHP application, which inspired me to think about this as a problem I'd like solved for Go.

It's common to use the `net/http` handlers in Go code, so I thought that'd be a good place to start with solving this. Before barrelling into solving it myself, I looked into options and found [kin-openapi](https://github.com/getkin/kin-openapi) has a filter for validating request/response, but I couldn't see how best to make this work with test code and give me errors in my tests.

Asking around on the Go community Slack, and APIs You Won't Hate community Slack, I was recommended [this great solution](https://gist.github.com/bojanz/00187fd502b75001953d200c11dbbd97) from <span class="h-card"><a class="u-url" href="https://bojanz.github.io/">Bojanz Zivanovic</a></span>, which uses kin-openapi's filter, and wraps it in something that can be used in tests - awesome!

To make it a little more reusable, I've wrapped it into a library, which can be found [on GitLab](https://gitlab.com/jamietanna/httptest-openapi), and allows you to write the following code:

```go
import (
	validator "openapi.tanna.dev/go/validator/openapi3"
)

func Test_Handler_Contract(t *testing.T) {
	doc, err := openapi3.NewLoader().LoadFromFile("testdata/fedmodel.yaml")
	if err != nil {
		t.Error("unexpected test setup error reading OpenAPI contract", err)
	}

	v := validator.NewValidator(doc, t)
	rr := httptest.NewRecorder()
	req := httptest.NewRequest("GET", "/apis", nil)
	req.Header.Add("tracing-id", "123")

	Handler(rr, req)

	v.Validate(rr, req)
}
```

This then fails your test if you don't have a correct request contract, as well as checking that the response is well formed, based on properties defined in your OpenAPI.

I've already found it's been good to validate some existing OpenAPI documents + their implementations, and I hope to hear of others using this!
