---
title: "Running commands against every module in a Go multi-module project"
description: "How to run commands like `go test` when using a multi-module Go project."
tags:
- blogumentation
- go
date: 2023-08-18T16:08:22+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-multi-module-execute
image: https://media.jvt.me/b41202acf7.png
---
I've recently been [migrating oapi-codegen](https://github.com/deepmap/oapi-codegen/pull/1197) to a [multi-module project](https://go.dev/doc/modules/managing-source#multiple-module-source).

As part of it I've seen that running an innocuous "test all the packages below this one":

```sh
go test ./...
```

Does _not_ work any more, as `go test` will only traverse packages that the current module knows about.

We _could_ write something like the following `find` command:

```sh
# ⚠ don't use this!
find . -iname "go.mod" -exec sh -c 'cd $(dirname {}) && go test ./...' \;
```

However, as [this StackExchange mentions](https://unix.stackexchange.com/questions/134693/break-out-of-find-if-an-exec-fails), this doesn't fail if any of the `exec`s fails, which means we could be lulled into a false sense of security if we're not actively watching the output of `go test` for errors.

Instead, we can use `find | xargs`, or in a slightly better version `git ls-files | xargs` to do the same, but set a failure exit code if any commands fail:

```sh
# find the top-level, and all child Go modules
                                                         # -x to show what commands are being run, to give an idea of which module is being tested
git ls-files go.mod '**/*go.mod' -z | xargs -0 -I{} bash -xc 'cd $(dirname {}) && go test -cover ./...'
```
