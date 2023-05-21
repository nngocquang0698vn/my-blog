---
title: "The Lazy engineer's guide to running your Go web application to AWS Lambda"
description: "How to take a Go web application and move it to AWS Lambda with two lines of code."
date: 2023-05-21T21:54:37+0100
tags:
- blogumentation
- aws-lambda
- go
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/770ef46545.png
slug: lazy-go-lambda
---
One of the things I really love about Go's [structural typing](https://en.wikipedia.org/wiki/Structural_type_system) is how interfaces work. It took a bit of getting used to it coming from Java, but I really enjoy the fact that just by implementing a method, you can call it a day.

For instance, if you want to implement an HTTP server, you need to have the following method defined:

```go
// package http

type Handler interface {
	ServeHTTP(ResponseWriter, *Request)
}
```

Coming from the Java world, you'd need to implement a set of bindings for each HTTP library you wanted to support, each with a slightly different interface and means to work with, but in Go you can just focus on the standard library's interface. If you wanted to do something more feature-rich that targets functionality in the HTTP router or web framework, then you can do, but having a standard library interface to target is really helpful.

Another important distinction here is that the handler is a simple method call away, whereas in a lot of languages or frameworks, it's not quite that simple. A couple of years ago I was [trying to get Wiremock running in AWS Lambda](https://www.jvt.me/posts/2021/04/29/wiremock-serverless/) I found that the difficulty was trying to shim the incoming event to AWS Lambda and convert it to an HTTP request type that was supported by Wiremock. However, with Go's way of doing things, that can be much more straightforward.

Late last year, I was looking at what it would take to have a side-by-side comparison of an ECS service and a Lambda service for the same underlying codebase to compare performance. I'd considered the previous work I'd done around this in the Java world and the way that Go's `http.Handler` interface works, and realised that it would be straightforward to write a small translation layer between the AWS types and Go's standard library.

I went about writing a library for that translation layer over an evening, and [_just_ as I was putting the finishing touches](https://www.jvt.me/mf2/2022/10/vlpoo/) to the library by adding some real-world examples with some frameworks and routers, I was pointed to AWS' existing project that does exactly this! It makes sense in retrospect that AWS would want to maintain a library for this functionality, especially when they do [similar things in other ecosystems](https://github.com/awslabs/aws-serverless-java-container).

But I still wanted to write about it, as it's a pretty fun way to see how your application works, and as the title suggests a "lazy" engineer may want to look at this as a first pass. It's generally best to rethink your application if you're looking to move it to a functions-as-a-service based approach, but in a pinch, or as a way to get some understanding of how well you'd perform as-is on a Serverless solution, it can be a good start.

For instance, let's say that we have the following runnable server in `cmd/web/main.go`:

```go
package main

import (
	"log"
	"net/http"

	"gitlab.com/tanna.dev/lazy-port-lambda-go/internal/httpserver"
)

func main() {
	mux := httpserver.NewServer()

	log.Println(http.ListenAndServe(":3000", mux))
}
```

This delegates the core functionality to our internal implementation in `internal/httpserver/main.go` to provide some basic HTTP routing:

```go
package httpserver

import (
	"fmt"
	"net/http"
)

func NewServer() http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			w.WriteHeader(http.StatusNotFound)
			return
		}

		w.Write([]byte("Hello"))
	})

	mux.HandleFunc("/post-handler", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		fmt.Println("Received new POST")

		err := r.ParseForm()
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte(err.Error()))
			return
		}

		for k, v := range r.Form {
			fmt.Printf("%s=%s\n", k, v)
		}
	})

	return mux
}
```

When we run this command as-is, we get a web server running that we can interact with as we would expect.

If we shipped this as-is to AWS Lambda this wouldn't work, as we need to handle the incoming event and return a response, rather than bind to an HTTP port.

Fortunately with aws-lambda-go-api-proxy we can write the following:

```go
package main

import (
	"gitlab.com/tanna.dev/lazy-port-lambda-go/internal/httpserver"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/httpadapter"
)

func main() {
	mux := httpserver.NewServer()

	// note that this is using V2 API Gateway proxy events, which may need to be configured
	lambda.Start(httpadapter.NewV2(mux).ProxyWithContext)
}
```

When built and shipped as a Lambda, this handles the translation from events to HTTP types for Go, and then takes the outputted HTTP response and converts it to the resulting response type - awesome!

That's it - it's pretty straightforward and can be really powerful for giving you a chance to look a lightweight wrapper to migrate to Lambda without doing the rewrite for an event-based system (yet).

Example code for this article can be found [on GitLab.com](https://gitlab.com/tanna.dev/lazy-port-lambda-go).
