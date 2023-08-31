---
title: "What Go versions are my modules and dependencies targeting?"
description: "Without using `go mod vendor`, how you can look at the version of Go that each of your modules and dependencies target."
tags:
- blogumentation
- go
date: 2023-08-31T10:47:32+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-list-module-versions
image: https://media.jvt.me/b41202acf7.png
---
As noted in [_Why is Go trying to upgrade my `go.mod` to Go 1.21?_](https://www.jvt.me/posts/2023/08/31/go-121-why-upgrade/), we've [had a report on oapi-codegen](https://github.com/deepmap/oapi-codegen/issues/1221) that Go is trying to upgrade our `go.mod` to a newer Go version.

Through discussion in the Go community (Gopher) Slack, it appears that this is due to one of the modules in my dependency tree using Go 1.21, and therefore Go is upgrading the whole project to Go 1.21.

I reached for `go mod vendor` to confirm this behaviour, as I know that `vendor/modules.txt` usually contains this information, but wondered if there's a better way - which fortunately there is!

We can take inspiration from [How to get golang package import list](https://pmcgrath.net/how-to-get-golang-package-import-list) and craft the following `go list` command, for all modules:

```sh
go list -f '{{.Path }} {{.GoVersion}}' -m all
```

This then outputs something like:

```
github.com/deepmap/oapi-codegen 1.21
github.com/BurntSushi/toml 1.16
github.com/CloudyKit/fastprinter 1.13
github.com/CloudyKit/jet/v6 1.12
github.com/Joker/hpp 1.12
github.com/Joker/jade 1.14
github.com/RaveNoX/go-jsoncommentstrip 1.12
github.com/Shopify/goreferrer 1.17
github.com/ajg/form
github.com/andybalholm/brotli 1.12
...
```

You could tweak this to return the version first, and then try and sort based on this, or provide [any other information](https://pkg.go.dev/cmd/go#hdr-List_packages_or_modules) as necessary.
