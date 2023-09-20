---
title: "Gotchas with pointing Go modules to a fork, when building an installable module"
description: "A gotcha around how to pin a Go module to a fork, if you're building a module that should be `go install`able."
date: 2023-09-20T14:48:30+0100
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-mod-fork-gotcha"
---
This morning I cut a release of dependency-management-data which ended up horribly breaking all consumers of the application.

As [I flagged in the tracking issue for this](https://gitlab.com/tanna.dev/dependency-management-data/-/issues/182), trying to install the CLI would lead to the following error:

```
$ go install dmd.tanna.dev/cmd/dmd@latest
go: dmd.tanna.dev/cmd/dmd@latest (in dmd.tanna.dev@v0.42.0):
	The go.mod file for the module providing named packages contains one or
	more replace directives. It must not contain directives that would cause
	it to be interpreted differently than if it were the main module.
```

This was because as part of this release, I added support for using [charmbracelet/log](https://github.com/charmbracelet/log) as a `log/slog` handler, which [isn't yet fully merged upstream](https://github.com/charmbracelet/log/issues/8) so I ended up pointing to my fork of the repo [based on this PR](https://github.com/charmbracelet/log/pull/74).

As mentioned in [Pointing to a fork of a Go module](https://www.jvt.me/posts/2022/07/07/go-mod-fork/) this should be trivial to do when you're using a `replace` directive in your `go.mod`, and was working in dependency-management-data's build pipeline, up until the point that someone tried to install from it.

I've never had this issue before - despite using `replace` statements in some projects, and through looking at [this Go issue](https://github.com/golang/go/issues/44840) it appears that this is only the case when you have an installable Go module, not when you're building it from the directory that contains the `go.mod`.

For instance, I have created [a sample project on GitLab.com](https://gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha), where we have two modules:

The `with-replace` module's `go.mod`:

```
module gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/with-replace

go 1.21.1

require github.com/charmbracelet/log v0.2.4

// indirects omitted for brevity

replace github.com/charmbracelet/log => github.com/jamietanna/log v0.2.2-0.20230912205513-bfd7186f150d
```

The `without-replace` module's `go.mod`:

```
module gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/without-replace

go 1.21.1

require github.com/jamietanna/log v0.2.2-0.20230920083807-7382cd7fbdd8

// indirects omitted for brevity
```

When we try and `go install` the module that uses `replace`s, we encounter the same error:

```
% go install gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/with-replace@HEAD

go: downloading gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha v0.0.0-20230920133000-0be73c155bc2
go: downloading gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/with-replace v0.0.0-20230920133000-0be73c155bc2
go: gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/with-replace@HEAD (in gitlab.com/tanna.dev/jvt.me-examples/go-mod-fork-gotcha/with-replace@v0.0.0-20230920133000-0be73c155bc2):
        The go.mod file for the module providing named packages contains one or
        more replace directives. It must not contain directives that would cause
        it to be interpreted differently than if it were the main module.
```

But when there's not a `replace`, and we're pinning to a fork, this works as-is.

Also note that the two projects are pinning to a slightly different set of commits - `without-replace` requires we pin to [this specific commit](https://github.com/jamietanna/log/commit/7382cd7fbdd8), which modifies the module declaration:

```diff
-module github.com/charmbracelet/log
+module github.com/jamietanna/log

go 1.21
```

Without this, we would receive the error:

```
go: github.com/jamietanna/log@bfd7186f150d (v0.2.2-0.20230912205513-bfd7186f150d) requires github.com/jamietanna/log@v0.2.2-0.20230912205513-bfd7186f150d: parsing go.mod:
        module declares its path as: github.com/charmbracelet/log
                but was required as: github.com/jamietanna/log
```

And as we can't specify the `replace` semantics, we __must__ update the `module` directive in our `go.mod`, if we want the module to be installable without someone cloning the repository and running `go install` from there.
