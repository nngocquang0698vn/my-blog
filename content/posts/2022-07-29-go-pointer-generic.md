---
title: "Using generics to get a pointer to any type, in Go"
description: "How to use Go generics to create a helper method for getting a pointer\
  \ to any type."
date: "2022-07-29T16:21:42+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1553042105634807808"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-pointer-generic"
---
In Go, we use pointers to define that a value may be optional.

Often, we'll use the `&` operator to provide the pointer value to a method, so we can do something like this:

```go
method(&api.Response{})
```
The issue is that not every type can use the `&` operator, for instance we can't do this with a string:

```go
ptr := &"foo"
// compilation error:
// invalid operation: cannot take address of "foo" (untyped string constant)
```

So how can we get around this? One option is to use an intermediate variable:

```go
s := "foo"
ptr := &s
```

But depending on how many parameters need to be coerced into pointers, this can be a little awkward.

Alternatively, with Go 1.18's support for generics, we can create a helper method like the below, which gives us the ability to do this with any type:

```go
func PtrTo[T any](v T) *T {
  return &v
}

func main() {
	fmt.Println("foo")
	fmt.Println(PtrTo("foo"))
}
```
