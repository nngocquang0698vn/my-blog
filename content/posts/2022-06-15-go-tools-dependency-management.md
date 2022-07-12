---
title: "Managing your Go tool versions with `go.mod` and a `tools.go`"
description: "Better dependency management for your tools and without needing to `go\
  \ install` the tools before executing them."
date: "2022-06-15T22:21:37+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1537185383913488384"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-tools-dependency-management"
---
When working with Go codebases, it's likely that you'll be delegating some functionality out to helper tools to make your life easier.

For instance, you may be generating code with [`mockgen`](https://github.com/golang/mock) or [`oapi-codegen`](https://github.com/deepmap/oapi-codegen), or linting your project with [`golangci-lint`](https://golangci-lint.run/).

Something that's [recommended on the Wiki](https://github.com/golang/go/wiki/Modules#how-can-i-track-tool-dependencies-for-a-module) and that I've seen across a few projects is the idea of a `tools.go`.

As explained in more depth in [_Manage Go tools via Go modules_](https://marcofranssen.nl/manage-go-tools-via-go-modules), this gives you a central place to look for + manage dependencies.

However, this, and the example in the wiki fall down on is that it doesn't work super well 😅

If we take the [example project](https://github.com/go-modules-by-example/tools), we receive an error if we don't pre-install the `stringer` command.

```sh
$ go get
$ go generate
painkiller.go:5: running "stringer": exec: "stringer": executable file not found in $PATH
```

This isn't super helpful, as it requires we do some work up-front to get the commands prepared. This means new developers, as well as automated build environments, need to have done some work to get started, which may not even be consistent across repositories.

So what are our options for managing this better, and making it easier to get started?

## Makefile

One approach is to have a `Makefile` task that allows you to parse the `tools.go` and install those dependencies, but it's a little awkward, and I tend to try and avoid parsing complex text with things like `sed` or `awk`.

This approach isn't ideal, and leads to another command needing to execute before we get started, as well as depending on an arguably brittle text parsing approach.

## `go.mod`

Alternatively, because we've already got the dependencies and their versions pinned in our `go.mod`, through the declaration in the `tools.go`, we can actually get rid of the `Makefile` magic.

To do this explicitly, we'd create a `tools.go` with the following in it:

```go
//go:build tools
// +build tools

package main

import (
	_ "golang.org/x/tools/cmd/stringer"
)
```

Thanks to [this comment on GitHub](https://github.com/golang/go/issues/25922#issuecomment-1065971260), we can replace our invocations of the command-line application with a `go run` invocation on the package, like so:

```diff
-//go:generate stringer -type=Pill
+//go:generate go run golang.org/x/tools/cmd/stringer -type=Pill
```

This is true whether they're in a `Makefile`, a standalone script, or in our code.

This gives us the benefit of being purely managed through our `go.mod`, meaning we can get tools like Dependabot to manage our dependency updates for us, too!
