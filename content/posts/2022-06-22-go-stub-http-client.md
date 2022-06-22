---
title: "Stubbing out the Go `http.Client` to test an HTTP `HandlerFunc`"
description: "How to write a unit test to validate your router's HTTP handlers work,\
  \ by stubbing out the `http.Client` implementation."
date: "2022-06-22T09:27:28+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1539528996496592899"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-stub-http-client"
---
If you're writing Go tests that interact with an API, at some point you'll want to fully test your built API, but don't necessarily want to have the server actually running + interacting with real dependencies.

For instance, you may be wanting to use [a generated OpenAPI client](/posts/2022/04/06/generate-go-client-openapi/), but want to test it against your configured server's [`ServeHTTP` function](https://pkg.go.dev/net/http#HandlerFunc.ServeHTTP) instead of executing the service for real.

Note that this is a separate set of testing to just testing the handlers in isolation, where we'd be able to unit test just those method calls. In this version, we're testing that the fully configured router works as expected, with i.e. an OpenAPI client.

It's actually pretty straightforward by taking advantage of Go's `httptest` package, and interface types, which allow us to write the following:

```go
import (
	"context"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
	// this would also include the `api` package, which is expected to contain the `oapi-codegen`'d API client
)

type server interface {
	ServeHTTP(w http.ResponseWriter, r *http.Request)
}

type fakeClient struct {
	server server
}

func (c *fakeClient) Do(r *http.Request) (*http.Response, error) {
	rr := httptest.NewRecorder()
	c.server.ServeHTTP(rr, r)
	return rr.Result(), nil
}

func TestRouter(t *testing.T) {
	var server server
	// construct the server i.e. by `mux.NewRouter()`

	fakeClient := fakeClient{
		server: server,
	}

	client, err := api.NewClientWithResponses("", api.WithHTTPClient(&fakeClient))

	resp, err := client.Healthcheck(context.TODO())
	if err != nil {
		t.Errorf(err.Error())
	}
	if 200 != resp.StatusCode {
		t.Errorf("Expected status code 200, but was %d", resp.StatusCode)
	}
}
```
