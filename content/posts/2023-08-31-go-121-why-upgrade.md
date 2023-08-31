---
title: "Why is Go trying to upgrade my `go.mod` to Go 1.21?"
description: "Why you may be seeing Go trying to upgrade the Go version in your `go.mod` to Go 1.21."
tags:
- blogumentation
- go
date: 2023-08-31T10:47:32+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-121-why-upgrade
image: https://media.jvt.me/b41202acf7.png
---
On oapi-codegen we recently [had a report](https://github.com/deepmap/oapi-codegen/issues/1221) that Go 1.21 results in `go test` being unable to run without having `go mod tidy`'d the project.

If you're running Go 1.21:

```sh
$ go version
go version go1.21.0 linux/amd64
```

Then checking out the project (as of the [latest commit](https://github.com/deepmap/oapi-codegen/commit/beb29bbbf0a66812ebe03110a493e27c07414f85) and running `make tidy` shows the following diff:

```diff
diff --git go.mod go.mod
index dd8b906..2122b0e 100644
--- go.mod
+++ go.mod
@@ -1,6 +1,8 @@
 module github.com/deepmap/oapi-codegen

-go 1.20
+go 1.21
+
+toolchain go1.21.0
```

Through discussion in the Go community (Gopher) Slack, it appears that this is due to one of the modules in my dependency tree using Go 1.21, and therefore Go is upgrading the whole project to Go 1.21.

As noted in [the Go 1.21 release notes](https://go.dev/doc/go1.21#tools), the `go` directive now defines an explicit minimum, whereas before it could be possible to try and build a future version of Go code, and maybe it would _just work_, or fail.

I've blogumented that process to determine the versions in [a separate blog post](https://www.jvt.me/posts/2023/08/31/go-list-module-versions/).

But if you're seeing this issue, your best course of action is to take the changes and upgrade the whole project to 1.21.
