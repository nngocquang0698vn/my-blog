---
title: "Sharing state between `net/http` method calls in Go"
description: "How to construct a `struct` in Go that can have its state shared between HTTP server handler functions."
tags:
- blogumentation
- go
date: 2023-07-03T20:43:08+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-http-server-state
image: https://media.jvt.me/b41202acf7.png
---
I've recently been writing some HTTP server code with Go, and found it not-super-searchable to find out how to have a `struct` that shares state between method calls, so I thought it'd be good to blogument it.

For a super contrived example, we want to share the `state` along our `server` type, which requires we have our HTTP handler functions defined on the struct, and we set up the `HandleFunc`s on the instance of the `struct`:

```go
package main

import (
	"log"
	"net/http"
)

type server struct {
	state string // not handled atomically, as it should be in production code
}

func (s server) handleFunc(w http.ResponseWriter, _ *http.Request) {
	w.Write([]byte(s.state))
}

func main() {
	mux := http.NewServeMux()

	server := server{
		state: "this is shared",
	}

	mux.HandleFunc("/", server.handleFunc)

	s := http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	log.Fatal(s.ListenAndServe())
}
```
