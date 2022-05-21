---
title: "Testing Go `net/http` handlers"
description: "How to write unit tests to validate an HTTP handler."
date: "2022-05-21T21:44:24+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1528116825938075648"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-test-http-handler"
---
When writing Go web services, it's very likely that you'll be unit testing the HTTP handlers, as well as doing some wider integration tests on your application.

Something nice about Go is the [httptest package](https://pkg.go.dev/net/http/httptest) in the standard library, providing a very handy means to test HTTP logic.

This means that if we had the following, very straightforward handler:

```go
func Handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("tracing-id", r.Header.Get("tracing-id"))
	w.WriteHeader(401)
}
```

We can then write the following unit test:

```go
func Test_Handler_status(t *testing.T) {
	rr := httptest.NewRecorder()
	req := httptest.NewRequest("GET", "/apis", nil)
	req.Header.Add("tracing-id", "123")

	Handler(rr, req)

	if rr.Result().StatusCode != 401 {
		t.Errorf("Status code returned, %d, did not match expected code %d", rr.Result().StatusCode, 401)
	}
	if rr.Result().Header.Get("tracing-id") != "123" {
		t.Errorf("Header value for `tracing-id`, %s, did not match expected value %s", rr.Result().Header.Get("tracing-id"), "123")
	}
}
```
