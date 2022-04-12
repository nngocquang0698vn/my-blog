---
title: "Converting a Byte Array to String from a Node.JS `Buffer`, in Go"
description: "How to convert an array of bytes to a string using Go."
date: "2022-04-12T21:40:41+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1513982167105351688"
tags:
- "blogumentation"
- "go"
- "nodejs"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "buffer-array-to-string-go"
---
As noted in [_Converting a Byte Array to String with `Buffer` in Node.JS_](https://www.jvt.me/posts/2020/04/20/buffer-array-to-string/), you may encounter serialised `Buffer`s when working with Node.JS projects.

We may want to do something similar in Go, so how would we do this?

```go
package main

import "fmt"

func main() {
	a := []byte{104, 116, 116, 112, 115, 58, 47, 47, 119, 119, 119, 46, 106, 118, 116, 46, 109, 101}
	fmt.Println(string(a))
  //https://www.jvt.me
}
```
