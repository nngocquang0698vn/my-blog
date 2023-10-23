---
title: "How we reduced oapi-codegen's dependency overhead by ~84%"
description: "An example of how to reduce the size of a Go module's dependencies by taking advanage of Go module pruning."
tags:
- blogumentation
- go
date: 2023-10-23T17:21:50+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: oapi-codegen-v2-decrease
image: https://media.jvt.me/b41202acf7.png
---
As I [announced recently](https://github.com/deepmap/oapi-codegen/discussions/1309), oapi-codegen, the OpenAPI to Go code generator that I co-maintain, will soon release a v2 release to allow us to reduce the size of the library's dependencies by roughly ~84%.

This is a pretty good saving, and has resulted in the following changes:

<table>
	<tr>
	<th>
	</th>
	<th>
	Before (v1.13.0)
	</th>
	<th>
	After (<a href="https://github.com/deepmap/oapi-codegen/pull/1310">proposed v2.0.0</a>)
	</th>
	</tr>
	<tr>
		<td>
		Vendored dependency size (MB)
		</td>
		<td>
		40
		</td>
		<td>
		6
		</td>
	</tr>
	<tr>
		<td>
		Direct dependencies
		</td>
		<td>
		15
		</td>
		<td>
		6
		</td>
	</tr>
	<tr>
		<td>
		Indirect dependencies
		</td>
		<td>
		95
		</td>
		<td>
		34
		</td>
	</tr>
</table>

So how have we ended up being able to shave so much off the package?

## Existing project structure

Before we go into that, let's briefly review what the package is and how it works.

oapi-codegen is first and foremost a code generator that takes an OpenAPI 3.x specification and converts it to Go code. This can be done for either a client to consume an external API, or can be used to generate one of several servers, as well as allowing users to override the generation by providing their own `text/template` files.

Users of the package interact with us in two ways:

- Using the CLI to generate the relevant code for them, whether [using a `tools.go` approach](https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/) or just `go install`ing the version required,
- Using oapi-codegen as a library, depending on packages for runtime or middleware functionality, as explained below

The high-level package structure looks like this:

```
cmd/oapi-codegen
examples									Example code for various servers and use-cases, as a means to show how you can get started, as well as what a realistic usecase would look like
internal/test/						Integration / regression tests to cover bugs or features
pkg/
	chi-middleware					HTTP middleware for Chi web server, as well as anything implementing net/http compatible interfaces such as gorilla/mux
	codegen									Actual code generation functionality exposed by oapi-codegen, sometimes imported as a library by other projects
	ecdsafile								Utility for working with ECDSA public and private keys
	fiber-middleware				HTTP middleware for Fiber web server
	gin-middleware					HTTP middleware for Gin web server
	iris-middleware					HTTP middleware for Iris web server
	middleware							HTTP middleware for Echo web server
	runtime									Runtime-specific code, such as converting a URL-encoded form request to a struct, or performing `allOf`/`anyOf`/etc manipulation
	securityprovider				Perform common authentication schemes for use with the generated HTTP client
	testutil								Utilities for making it easier to test HTTP handlers with a fluent interface
	types										Types that may be required by the generated code, such as a UUID type
	util										Utilities for handling command-line flags, validating JSON media types and loading OpenAPI specs
```

This structure mostly has existed since the v1.0.0 release in 2019, and has expanded over the years as we've added support for more servers and functionality.

## Discovering the impact

In July, we received an issue on the issue tracker: [v1.13.0 introduces lots of transitive dependencies to client library](https://github.com/deepmap/oapi-codegen/issues/1142), and really appreciate Paul doing so!

We'd not (yet?) seen this as an impact on our side, and so this gave us an early indication that something was up.

This was introduced by an internal tweak to reduce some duplication across the generated code, introducing `pkg/runtime/strictmiddleware.go`:

```go
// via https://github.com/deepmap/oapi-codegen/blob/v1.13.0/pkg/runtime/strictmiddleware.go
package runtime

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/labstack/echo/v4"
)

type StrictEchoHandlerFunc func(ctx echo.Context, request interface{}) (response interface{}, err error)

type StrictEchoMiddlewareFunc func(f StrictEchoHandlerFunc, operationID string) StrictEchoHandlerFunc

type StrictHttpHandlerFunc func(ctx context.Context, w http.ResponseWriter, r *http.Request, request interface{}) (response interface{}, err error)

type StrictHttpMiddlewareFunc func(f StrictHttpHandlerFunc, operationID string) StrictHttpHandlerFunc

type StrictGinHandlerFunc func(ctx *gin.Context, request interface{}) (response interface{}, err error)

type StrictGinMiddlewareFunc func(f StrictGinHandlerFunc, operationID string) StrictGinHandlerFunc
```

Although this by itself was a reasonable change, it led to quite an impact, and we should've caught it at the time.

Go is able to [prune the dependency graph](https://go.dev/ref/mod#graph-pruning) to reduce the need to download dependencies that aren't actually in use, but this works at a package-level, not a file-level, so now any user depending on `pkg/runtime` would also need to pull down Gin and Echo, even if they weren't using them.

Over the next release's lifetime, we started looking at what we could do to reduce this, in a way that wouldn't (yet) require a breaking change.

## Considering a multi-module Go module

We'd had a discussion around trying to make these changes in-place in the repo we had right now, without requiring creating any new repos, i.e. `deepmap/oapi-codegen-runtime`, so the first approach was to create a multi-module repository.

I'd [had a go at trying to do this](https://github.com/deepmap/oapi-codegen/pull/1197), but we ended up abandoning this approach. As part of trying to integrate the end result with an example project, as well as discussing with the lovely people on the Gopher Slack, we found that moving to a multi-module project would be more difficult than we thought, would complicate releases, and didn't quite gel with what we wanted.

We found that trying to keep everything in one repo wasn't quite working for us, albeit I'm glad we tried as I enjoyed playing around with it and learning a bit more about Go modules.

Instead, we took some of the commits from that branch and moved `examples` and `internal/test` to their own Go modules as part of [Work to reduce transitive dependencies](https://github.com/deepmap/oapi-codegen/pull/1206). Neither of these packages are expected to be externally consumable, so we decided to hide these in their own Go modules, which use `replace` directives, allowing us to still use them for ensuring that our code generation works, but without polluting the top-level module with the dependencies they require.

We can see the changes introduced by [Work to reduce transitive dependencies](https://github.com/deepmap/oapi-codegen/pull/1206) in the v1.14.0 release below:

<table>
	<tr>
	<th>
	</th>
	<th>
	Before (<a href=https://github.com/deepmap/oapi-codegen/tree/55641e96fba3da8de760fda99def4555be6dca6e><code>55641e96</code></a>)
	</th>
	<th>
	After  (<a href="https://github.com/deepmap/oapi-codegen/tree/v1.14.0"><code>v1.14.0</code></a>)
	</th>
	</tr>
	<tr>
		<td>
		Vendored dependency size (MB)
		</td>
		<td>
		49
		</td>
		<td>
		47
		</td>
	</tr>
	<tr>
		<td>
		Direct dependencies
		</td>
		<td>
		16
		</td>
		<td>
		14
		</td>
	</tr>
	<tr>
		<td>
		Indirect dependencies
		</td>
		<td>
		81
		</td>
		<td>
		74
		</td>
	</tr>
</table>

As we can see, this was a pretty minimal change, but starts to move the needle with our cleanup journey.

## New project structure

The other key thing as part of  did was migrate the `pkg/types` and `pkg/runtime` packages to a completely new package, [`github.com/oapi-codegen/runtime`](https://github.com/oapi-codegen/runtime).

Right now, any changes to the runtime or middleware related functionality required a new release of oapi-codegen, which recently has taken anywhere up to 6 months (😅) which requires folks then pin to direct commits to get a fix for an issue they're seeing, which isn't ideal.

After the failed attempt to try and keep everything in a single repo, we considered it a bit further and realised that it would probably be best to decouple the code generation and other pieces in the oapi-codegen ecosystem.

This allowed the v1.14.0 release to test the waters with the first separate package, and with the v1.16.0 release today, we've migrated all packages to a multi-repo approach. I'm looking forward to having this small v2 jump behind us, and to continue to keep an eye on number of dependencies we introduce in the future.

Anything we can improve on? Give us a shout through replying to the blog post, or on [the discussion around the upcoming v2 release](https://github.com/deepmap/oapi-codegen/discussions/1309).
