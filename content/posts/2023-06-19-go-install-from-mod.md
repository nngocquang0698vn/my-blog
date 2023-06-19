---
title: "Using `go.mod` versions to `go install` a binary"
description: "How to use `go install` to install a binary from the version tracked in `go.mod`."
tags:
- blogumentation
- go
date: 2023-06-19T09:24:06+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-install-from-mod
image: https://media.jvt.me/b41202acf7.png
---
In my post [_Managing your Go tool versions with `go.mod` and a `tools.go`_](https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/) I talked about how to track tool dependencies in a `tools.go` to more easily run your tools without a `make setup` step or similar.

However in the [performance section](https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/#performance) I noted that there can be a slight performance hit with this, as `go run` doesn't get cached, as of Go 1.20.

Instead of `go run`, we can instead install the binaries, and execute them as part of `go generate` or our `Makefile`, or you may just want the binary installed to your `$PATH`.

To get the binary installed via our `go.mod`, we can run:

```sh
# make sure it's at the root of the repo
env GOBIN=$(git rev-parse --show-toplevel)/bin\
  go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen
```

This should be able to work out the current version of the package from your `go.mod` and install it appropriately 🙌

There are some cases where you may need to specify `-mod` manually:

```sh
# for non-vendored
env GOBIN=$(git rev-parse --show-toplevel)/bin\
  go install -mod=readonly github.com/deepmap/oapi-codegen/cmd/oapi-codegen
# or for vendoring
env GOBIN=$(git rev-parse --show-toplevel)/bin\
  go install -mod=vendor github.com/deepmap/oapi-codegen/cmd/oapi-codegen
```
