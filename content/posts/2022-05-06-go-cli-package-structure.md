---
title: "Setting up a Go package structure for a combined library and CLI tool"
description: "How to structure a Go repository to be both a library and command-line\
  \ tool(s)."
date: "2022-05-06T09:20:03+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1522496405616701445"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-cli-package-structure"
---
I've recently been [building a Go CLI for Micropub](https://www.jvt.me/posts/2022/03/01/micropub-go-cli/), and as part of it, I've been developing both the command-line interface, and a generic library interface.

As I started on the journey to build both sides of this, I needed to work out how to structure the packages, especially as someone new to the ecosystem. I wanted the CLI and library to sit within the same repo, but it took a bit of figuring out and I didn't see any posts that explained what I needed.

I was able to follow the way that [`microformats`](https://github.com/willnorris/microformats) works, and thought I'd prepare a [sample project](https://gitlab.com/jamietanna/example-go-cli-and-library) and blog post to explain it.

# The library structure

This is the simplest piece, because you're likely already used to the structure, and will have all the library files in the top-level of the repo:

```
library.go
```

Remember to set the package to the `module` name from the `go.mod`, so consumers can import the library correctly!

For instance, for the following `go.mod`:

```
module hacking.jvt.me/libcli
```

We would have the following package declaration at the top of source files:

```go
package libcli

// ...
```

# The CLI

A convention I've seen around the Go ecosystem is to have any CLI items put under an overarching `cmd` folder, and then have a sub-folder for each CLI.

For instance, if we want to build a CLI called `os`, we would create:

```
cmd/os/main.go
```

The biggest issue here for me was that the `main` package needs to be used for these, and a `main` function needs to be added:

```go
package main

import (
  "fmt"

  "hacking.jvt.me/libcli"
)

func main() {
  fmt.Printf("Hello from %s\n", libcli.EchoInfo())
}
```

But one thing that took a bit of time to work out fully is that each CLI tool needs to have a `package main`, otherwise no executable is built.

I've also found that to build the `cmd`s in this structure you need to run:

```sh
$ go build ./cmd/os
```

At which point, `./os` is usable from the repo root.
