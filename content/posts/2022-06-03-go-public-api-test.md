---
title: "Only testing your public API in a Go package"
description: "How to test only exported parts of a package in Go."
date: "2022-06-03T13:23:08+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1532701264961753088"
tags:
- "blogumentation"
- "go"
- "testing"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-public-api-test"
---
If you're writing a library or piece of code in Go that you want to be sure works as expected when a consumer of the code uses it, you'll likely want to write some black box tests for it. These exercise only the public interface of the code, and ensure that valid use-cases for external users of the code still work.

This testing allows us to validate the public - or exported, in Go speak - parts of the package.

One way of doing this is to put the onus on yourself to do it right.

For instance, let's say we have the following library code:

```go
package lib

type Authenticator interface {
	Authenticate(user, pass string) bool
}

type authenticator struct {
	validUser     string
	validPassword string
}

func (a *authenticator) Authenticate(user string, pass string) bool {
	return a.validUser == user && a.validPassword == pass
}

func NewAuthenticator(validUser, validPass string) Authenticator {
	return &authenticator{
		validUser:     validUser,
		validPassword: validPass,
	}
}
```

We could write the following unit test:

```go
package lib

import (
	"testing"
)

func TestAuthenticatorAuthenticate(t *testing.T) {
	authenticator := NewAuthenticator("user", "pass")

	t.Run("fails when set to incorrect credentials", func(t *testing.T) {
		actual := authenticator.Authenticate("USER", "PASS")

		if actual != false {
			t.Error("Should have failed")
		}
	})

	// we'd do more exhaustive testing

	t.Run("passes when set to right credentials", func(t *testing.T) {
		actual := authenticator.Authenticate("user", "pass")

		if actual != true {
			t.Error("Should have succeeded")
		}
	})
}
```

This works, and only exercises our public interface, but there's nothing enforcing it. We could still write the following code, and it'd be using the private interface:

```go
package lib

import (
	"testing"
)

func TestAuthenticatorAuthenticate(t *testing.T) {
	authenticator := &authenticator{
		validUser:     "user",
		validPassword: "pass",
	}

	t.Run("fails when set to incorrect credentials", func(t *testing.T) {
		actual := authenticator.Authenticate("USER", "PASS")

		if actual != false {
			t.Error("Should have failed")
		}
	})

  // ...
```

As noted on [StackOverflow](https://stackoverflow.com/a/31443271/2257038), we can use our package structure to enforce this, as we would do in other languages, to make sure that we can only utilise the public interface. One nice thing about Go is that it makes it possible to keep the files in the same directory, while keeping the package name different.

This allows us to use a test-only package, like so:

```go
package lib_test

import (
	"example.com/lib"
	"testing"
)

func TestAuthenticatorAuthenticate(t *testing.T) {
	authenticator := lib.NewAuthenticator("user", "pass")

	t.Run("fails when set to incorrect credentials", func(t *testing.T) {
		actual := authenticator.Authenticate("USER", "PASS")

		if actual != false {
			t.Error("Should have failed")
		}
	})

	// we'd do more exhaustive testing

	t.Run("passes when set to right credentials", func(t *testing.T) {
		actual := authenticator.Authenticate("user", "pass")

		if actual != true {
			t.Error("Should have succeeded")
		}
	})
}
```

Notice that we have to explicitly import the `lib` module, and that our package is `lib_test` to make it clear it's purely for testing.
