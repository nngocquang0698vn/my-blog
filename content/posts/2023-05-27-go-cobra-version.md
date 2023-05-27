---
title: "Getting a `--version` flag for Cobra CLIs in Go"
description: "How to get Cobra to provide a `--version` flag."
tags:
- blogumentation
- go
- goreleaser
date: 2023-05-27T10:57:48+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-cobra-version
image: https://media.jvt.me/b41202acf7.png
---
In my post [_Getting a `--version` flag for Cobra CLIs in Go, built with GoReleaser_](https://www.jvt.me/posts/2023/02/27/go-cobra-goreleaser-version/) I wanted to add a `--version` flag to my Go command-line tools.

However, I noted that this solution only works when using GoReleaser, and doesn't work when built from source.

Fortunately this week <span class="h-card"><a class="u-url" href="https://carlmjohnson.net/">Carl M. Johnson</a></span> [wrote about a project he's built](https://blog.carlmjohnson.net/post/2023/golang-git-hash-how-to/) for this exact functionality.

So how do we do this with a Cobra CLI?

The below examples can be found in [an example repo on GitLab.com](https://gitlab.com/tanna.dev/go-cobra-version-example).

Firstly, in our `main.go`, we can pass `versioninfo`'s data to a `SetVersionInfo` method:

```go
package main

import (
	"time"

	"github.com/carlmjohnson/versioninfo"
	"gitlab.com/tanna.dev/go-cobra-version-example/cmd"
)

func main() {
	cmd.SetVersionInfo(versioninfo.Version, versioninfo.Revision, versioninfo.LastCommit.Format(time.RFC3339))
	cmd.Execute()
}
```

This then calls this snippet to allow us to set the `rootCmd`'s versioning information:

```go
func SetVersionInfo(version, commit, date string) {
	rootCmd.Version = fmt.Sprintf("%s (Built on %s from Git SHA %s)", version, date, commit)
}
```

If we build it normally with `go build` and then invoke it, we'll see the version information:

```sh
go build
./go-cobra-version-example --version
go-cobra-version-example version (devel) (Built on 2023-05-27T09:53:47Z from Git SHA 43043f4715f3878b8d13ae73fa6b12dbd1253447)
```

And if we build it using `goreleaser`, we still see the version info:

```sh
goreleaser release --snapshot --clean
# where $PLATFORM is the OS platform you're running from
./dist/go-cobra-version-example_$PLATFORM/go-cobra-goreleaser-version-example --version
go-cobra-version-example version (devel) (Built on 2023-05-27T09:53:47Z from Git SHA 43043f4715f3878b8d13ae73fa6b12dbd1253447)
```
