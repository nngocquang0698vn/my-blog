---
title: "Pointing to a fork of a Go module"
description: "How to pin your Go modules to a given fork of a repository."
date: "2022-07-07T09:51:47+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1544969659874680832"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-mod-fork"
---
**Update 2023-09-20**: If you're writing a module that is consumed through `go install`, check out [this separate post to avoid a gotcha](https://www.jvt.me/posts/2023/09/20/go-mod-fork-gotcha/).

If you're building on top of an Open Source Go library through Go modules, there may be times that you need to use a forked version of the project, such as when the library hasn't yet merged your changes, or is no longer actively maintained.

Let's say that we want to pin to the forked branch [`defect/doc`](https://github.com/jamietanna/oapi-codegen/tree/defect/doc), we'd need to retrieve the latest Git SHA on that branch, which is currently `921b1b1504b413079e3cbe9457cc317014e299ce`.

This wouldn't work out-of-the-box with a `go get`, unfortunately:

```sh
$ go get github.com/jamietanna/oapi-codegen@921b1b1504b413079e3cbe9457cc317014e299ce

go: downloading github.com/jamietanna/oapi-codegen v1.10.2-0.20220707083624-921b1b1504b4
go: github.com/jamietanna/oapi-codegen@v1.10.2-0.20220707083624-921b1b1504b4: parsing go.mod:
        module declares its path as: github.com/deepmap/oapi-codegen
```

Fortunately it's super straightforward to work around this with [the `replace` directive in `go.mod`](https://go.dev/ref/mod#go-mod-file-replace).

To set up this pinning to our fork, we can run (or manually edit the `go.mod`):

```sh
go mod edit -replace github.com/deepmap/oapi-codegen=github.com/jamietanna/oapi-codegen@921b1b1504b413079e3cbe9457cc317014e299ce
```

This then produces the following at the bottom of our `go.mod`:

```go.mod
replace github.com/deepmap/oapi-codegen => github.com/jamietanna/oapi-codegen 921b1b1504b413079e3cbe9457cc317014e299ce
```

Then, when we run a `go get`, it'll pick up the right dependencies, and we'll be able to start using the forked version of the code!
