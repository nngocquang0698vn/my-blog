---
title: "Gotcha: Field casing is important when marshalling `struct`s to JSON in Go"
description: "Why you may be missing fields from your `struct`s in your Go `json.Marshal` calls."
tags:
- blogumentation
- go
- json
date: 2022-02-25T11:14:24+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-struct-json-case-gotcha
image: https://media.jvt.me/b41202acf7.png
syndication:
- "https://brid.gy/publish/twitter"
---
I'm trying to learn a bit of Go, and while working through a few things, I spotted a little gotcha with marshalling JSON from `struct`s.

In tutorials and example code, I've seen a mix of `struct`s with uppercase field names:

```go
type User struct {
Name string
}
```

But also some with lowercase field names:

```go
type User struct {
name string
}
```

Thinking that this didn't matter, I started using lowercase names, as I'm more used to lowercase, as a Java developer, and to my surprise, found that serialising this to JSON didn't work.

The following code:

```go
package main

import (
	"encoding/json"
	"fmt"
)

type User struct {
  name string
}

func main() {
	r, err := json.Marshal(User{name: "Bob"})
	if err != nil {
		panic(err)
	}
	fmt.Println(string(r))
}
```

Would return me the following output:

```json
{}
```

It turns out that this is an expected case, because [according to this answer on StackOverflow](https://stackoverflow.com/a/24837507/2257038):

> This is because only fields starting with a capital letter are exported, or in other words visible outside the curent package (and in the json package in this case).

Therefore, the fix here was to make the following change, so the `Name` field would appear in the JSON as the `$.name` property:

```diff
 type User struct {
-  name string
+  Name string `json:"name"`
 }
```
