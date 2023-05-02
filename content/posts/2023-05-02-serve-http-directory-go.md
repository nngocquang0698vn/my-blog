---
title: "Serving the current directory over HTTP with Go"
description: "How to use Go's standard library to serve the current directory over HTTP."
tags:
- blogumentation
- go
date: 2023-05-02T16:41:03+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: serve-http-directory-go
image: https://media.jvt.me/b41202acf7.png
---
I've recently been updating a few lightweight static websites and have wanted to preview the changes locally.

Although I usually reach for `python -mhttp.server`, it's a bit cumbersome to type, so I wanted something a little shorter. I was thinking of writing a script to make it quicker to type, when I thought - "what if I can do it quicker in Go"?

It turns out, it's blazingly fast to do so, in two lines(!) of code:

```go
package main

import (
	"log"
	"net/http"
)

func main() {
	http.Handle("/", http.FileServer(http.Dir(".")))
	log.Fatal(http.ListenAndServe("127.0.0.1:8080", nil))
}
```

That's it! This allows you to serve the current directory that the built binary is executed in over HTTP.

I've wrapped this into [a standalone tool](https://gitlab.com/tanna.dev/serve) just to make it easier to install and run, and I may end up adding some more (limited scope) functionality, while leaving it as lightweight as possible.
