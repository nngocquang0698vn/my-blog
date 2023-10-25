---
title: "Which version of Go was used to compile this binary?"
description: "How to use a few means to work out what version of Go a given binary was compiled with."
tags:
- blogumentation
- go
date: 2023-10-14T14:11:44+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-compile-version
image: https://media.jvt.me/b41202acf7.png
---
Sometimes it can be handy to work out what version of Go a given binary was complied with, for instance to find out if it's affected by any CVEs.

One option we can follow is [this post](https://dave.cheney.net/2017/06/20/how-to-find-out-which-go-version-built-your-binary), where we can dig into the binary with a debugger:

```sh
### NOTE that can be unsafe, as it requires actually parsing the file
gdb `which gopls`
(gdb) p 'runtime.buildVersion'
$1 = 0x4d8f78 "go1.20.4"
```

This can be a little awkward, and as mentioned, can be unsafe, so what about if we follow [this StackOverflow](https://stackoverflow.com/a/18991157) and use `go version`?

```sh
% go version `which zsh`
/usr/bin/zsh: could not read Go build info from /usr/bin/zsh: not a Go executable
% go version `which gopls`
/usr/bin/gopls: go1.21.0
```

Finally, we could also follow the [Go source code for the `version` command](https://cs.opensource.google/go/go/+/refs/tags/go1.21.3:src/cmd/go/internal/version/version.go) and see that it uses the [`debug/buildinfo#ReadFile`](https://pkg.go.dev/debug/buildinfo#ReadFile) method, which means we can write a similar piece of code:

```go
package main

import (
	"debug/buildinfo"
	"fmt"
	"os"
)

func main() {
	f, err := buildinfo.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("f.GoVersion: %v\n", f.GoVersion)
}
```

Which gives us a purely programmatic way of determining this version, which outputs i.e.

```sh
% go run main.go `which zsh`
2023/10/14 14:07:52 could not read Go build info from /usr/bin/zsh: not a Go executable
exit status 1
% go run main.go `which gopls`
f.GoVersion: go1.21.0
```
