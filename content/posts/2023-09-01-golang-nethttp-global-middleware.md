---
title: "Creating global middleware for `net/http` servers in Go"
description: "How to wrap `net/http` servers in Go with middleware(s) on every request."
tags:
- blogumentation
- go
date: 2023-09-01T10:33:18+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: golang-nethttp-global-middleware
image: https://media.jvt.me/b41202acf7.png
---
When you're writing pure `net/http` HTTP services with Go, you may want to wrap them in a middleware, for instance to ensure that authentication is provided, or to provide logging.

Having largely just used gorilla/mux, I found it was a little bit awkward to do so, but with thanks to [Gregor Best](https://unobtanium.de) for the help with this on the Gopher Slack, we got to the following solution.

```go
package main

import (
	"log"
	"net/http"
)

func use(r *http.ServeMux, middlewares ...func(next http.Handler) http.Handler) http.Handler {
	var s http.Handler
	s = r

	for _, mw := range middlewares {
		s = mw(s)
	}

	return s
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Before %s", r.URL.String())
		next.ServeHTTP(w, r)
		log.Printf("Before %s", r.URL.String())
	})
}

func acceptHeaderMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Accept: %v", r.Header.Get("Accept"))
		next.ServeHTTP(w, r)
	})
}

func path1(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

func path2(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("also-ok"))
}

func main() {
	r := http.NewServeMux()
	r.HandleFunc("/path1", path1)
	r.HandleFunc("/path2", path2)

	wrapped := use(r, loggingMiddleware, acceptHeaderMiddleware)

	log.Fatal(http.ListenAndServe(":3000", wrapped))
}
```
