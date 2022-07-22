---
title: "Optional configuration for configuring Go code"
description: "How to use optional types to allow configuring your library's Go code."
date: "2022-07-22T16:55:20+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1550511978463895552"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-optional-options"
---
When you're writing a reusable piece of code in a library, you often want to allow your code to be extensible to a point, in a way that allows safely modify behaviour without exposing too many of the internal workings.

A pattern that seems to be working really well in Go is by providing a varargs option type, when  constructing the type, which leads to a method signature like so:

```go
func NewClient(server string, opts ...ClientOption) (*Client, error) {
```

Since using this - and having the chance to implement it myself - I'm definitely liking it as a pattern.

So how does it work? Let's see how the [oapi-codegen's example generated client code](https://github.com/deepmap/oapi-codegen/blob/2cf7fcf5b26d1a4362e7c300bd65c20f4f6c4298/examples/petstore-expanded/petstore-client.gen.go) does this. The examples are modified for brevity.

By providing `ClientOption` as a `func` as the, it allows it to be callable in the construction of `NewClient`, and modify the underlying `Client`, and then we can provide some pre-built methods to modify the client.

```go
type Client struct {
	Server string
	Client HttpRequestDoer
	// ...
}

type ClientOption func(*Client) error

func NewClient(server string, opts ...ClientOption) (*Client, error) {
	client := Client{
		Server: server,
	}
	for _, o := range opts {
		if err := o(&client); err != nil {
			return nil, err
		}
	}
  // ...
  return &client, nil
}

func WithHTTPClient(doer HttpRequestDoer) ClientOption {
	return func(c *Client) error {
		c.Client = doer
		return nil
	}
}

func WithRequestEditorFn(fn RequestEditorFn) ClientOption {
	return func(c *Client) error {
		c.RequestEditors = append(c.RequestEditors, fn)
		return nil
	}
}
```

This works very nicely by having a varargs constructor, so we don't need to add new methods to set up various options.

In the case above, the `Client` type uses a struct that includes public, exported fields, but that's also not always the case. You may want to hide the implementation details and instead expose an interface, or a struct with a restricted set of public fields.

In that case, we may instead have something like:

```go
type Client interface {
	Do(req *http.Request) (*http.Response, error)
}

type client struct {
	server string
	client HttpRequestDoer
}

type clientOption func(*client) error

func WithHTTPClient(doer HttpRequestDoer) clientOption {
	return func(c *client) error {
		c.Client = doer
		return nil
	}
}
```

This allows us to continue configuring the client, and doesn't require we make `clientOption` exported, if we so wish.
