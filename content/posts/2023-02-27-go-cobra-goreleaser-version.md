---
title: "Getting a `--version` flag for Cobra CLIs in Go"
description: "How to get Cobra to provide a `--version` flag when using GoReleaser."
tags:
- blogumentation
- go
- goreleaser
date: 2023-02-27T17:19:16+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-cobra-goreleaser-version
image: https://media.jvt.me/b41202acf7.png
---
As part of working on my new Go CLI [`dmd`](https://www.jvt.me/posts/2023/02/20/dmd-cli/), I wanted to implement a `--version` flag to be able to check what version is currently installed.

I'd started looking at how to do this after I spotted that [GoReleaser populates `main.version` ldflags](https://goreleaser.com/cookbooks/using-main.version/) which mean that you can easily consume the data introduced.

I started looking around for solutions, finding [_Go Version for Cobra Projects_](https://www.hein.dev/blog/2018/07/go-version-for-cobra-projects/) and just as I was looking to implement this, I found that [Cobra now supports it out-of-the-box](https://github.com/spf13/cobra/blob/v1.6.1/user_guide.md#version-flag) if you set the `rootCmd.Version`.

So how do we do this?

The below examples can be found in [an example repo on GitLab.com](https://gitlab.com/tanna.dev/go-cobra-goreleaser-version-example).

Firstly, in our `main.go`, we can ensure that there are variables set to receive the values from the ldflags, and pass them to a `SetVersionInfo` method:

```go
package main

import "gitlab.com/tanna.dev/go-cobra-goreleaser-version-example/cmd"

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

func main() {
	cmd.SetVersionInfo(version, commit, date)
	cmd.Execute()
}
```

This then calls this snippet to allow us to set the `rootCmd`'s versioning information:

```go
func SetVersionInfo(version, commit, date string) {
	rootCmd.Version = fmt.Sprintf("%s (Built on %s from Git SHA %s)", version, date, commit)
}
```

If we build it normally with `go build` and then invoke it, we'll not see any version data:

```sh
go build
./go-cobra-goreleaser-version-example --version
go-cobra-goreleaser-version-example version dev (Built on unknown from Git SHA none)
```

However, if we use `goreleaser` to build it, we do see the version info:

```sh
goreleaser release --snapshot --clean
# where $PLATFORM is the OS platform you're running from
./dist/go-cobra-goreleaser-version-example_$PLATFORM/go-cobra-goreleaser-version-example --version
go-cobra-goreleaser-version-example version 0.0.0-SNAPSHOT-none (Built on 2023-02-27T17:09:11Z from Git SHA none)
```
