---
title: "Getting Go modules to work with nested GitLab groups"
description: "How to get Go modules to work with nested groups in GitLab for public or private repos."
date: 2023-10-28T16:44:34+0100
tags:
- "blogumentation"
- "go"
- gitlab
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/b41202acf7.png
slug: private-gitlab-subgroup-go
---
While trying to test for [How to publish a v2 version of a Go library](https://www.jvt.me/posts/2023/10/28/go-module-v2/), I found some issues with trying to import the new Go module I was testing with.

Via [Import private go modules from gitlab](https://medium.com/@manoj.dec22/import-private-go-modules-from-gitlab-71665daa9f9) and the [upstream issue on GitLab](https://gitlab.com/gitlab-org/gitlab/-/issues/36354), it appears that this is unfortunately a long-standing known issue with GitLab.

In the below example, we're going to use a very straightforward Go module that outputs a greeting, which is packages in both a public and private Go module. Although the private module is a private repo, the code is exactly the same as the public repo, just with a different module import path.

## Public repo, v0/v1

When using a public repo pre-v2, this works as can be expected:

<details>

<summary>Consuming module's code</summary>

```gomod
module example

go 1.20

require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2 v1.0.2
```

```go
package main

import (
	"fmt"

	"gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/pkg"
)

func main() {
	fmt.Println(pkg.Greeting())
}
```

</details>

## Public repo, v2+

Now, when we bump the major version of the module:

<details>

<summary>Consuming module's code</summary>

```gomod
module example

go 1.20

require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2 v2.0.0
```

```go
package main

import (
	"fmt"

	"gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2/pkg"
)

func main() {
	fmt.Println(pkg.Greeting())
}
```

</details>

This results in the following error:

```
$ go mod tidy
go: downloading gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2 v2.0.0
go: example imports
        gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2/pkg: gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2@v2.0.0: verifying module: gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2@v2.0.0: reading https://sum.golang.org/lookup/gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2@v2.0.0: 404 Not Found
        server response: not found: gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2@v2.0.0: invalid version: unknown revision v2.0.0
```

To fix it, we need to use `replace` directives in our `go.mod`:

```gomod
module example

go 1.20

require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2 v2.0.0

replace gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2 => gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module.git/v2 v2.0.0
```

After this, we can then use the new version of the code.

# Private repo, v0/v1

When using the private module:

<details>

<summary>Consuming module's code</summary>

```gomod
module example

go 1.20

require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module v1.0.3
```

```go
package main

import (
	"fmt"

	"gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module/pkg"
)

func main() {
	fmt.Println(pkg.Greeting())
}
```

</details>

This ends up with the following error:

```
% go mod tidy
go: downloading gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module v1.0.3
go: example imports
        gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module/pkg: reading gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module/go.mod at revision private-gitlab-subgroup-go/private-module/v1.0.3: git ls-remote -q origin in /home/jamie/go/pkg/mod/cache/vcs/598c10ef3c007f61df2dc7d33cb3a4dd1f38a94496576f32b1e46abe4c66802f: exit status 128:
        remote:
        remote: ========================================================================
        remote:
        remote: ERROR: The project you were looking for could not be found or you don't have permission to view it.

        remote:
        remote: ========================================================================
        remote:
        fatal: Could not read from remote repository.

        Please make sure you have the correct access rights
        and the repository exists.
```

Note that this is even with the following `~/.gitconfig` settings:

```ini
[url "ssh://git@gitlab.com/"]
	insteadOf = https://gitlab.com/
```

And with specifying `GOPRIVATE`:

```sh
export GOPRIVATE=gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/*
```

To make it work, we _also_ need to use the following `replace` directive:

```diff
 module example

 go 1.20

 require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module v1.0.4
+
+replace gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module => gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module.git v1.0.4
```

# Private repo, v2+

Using a module that's past v1 is a little more awkward, and requires your `git config`, `GOPRIVATE` and `replace` directives in place:

<details>

<summary>Consuming module's code</summary>

```gomod
module example.com

go 1.20

require gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module/v2 v2.0.0

replace gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module/v2 => gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/private-module.git/v2 v2.0.0
```

```go
package main

import (
	"fmt"

	"gitlab.com/tanna.dev/jvt.me-examples/private-gitlab-subgroup-go/module/v2/pkg"
)

func main() {
	fmt.Println(pkg.Greeting())
}
```

</details>
