---
title: "Setting up a matrix for GitHub Actions with Go's `go.mod` and specific versions"
description: "How to use a Go setup matrix in GitHub Actions that can target the `go.mod` version and arbitrary other version(s)."
date: 2023-09-11T09:55:16+0100
tags:
- blogumentation
- github-actions
- go
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-actions-go-matrix
---
When you're building a library or set of tooling in Go, you may want to test against different versions of Go to give confidence in the project for both you and your users.

I set about doing this today for oapi-codegen, and found that I wanted to take the following configuration:

```yaml
name: Build project
on: [ push, pull_request ]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Check out source code
        uses: actions/checkout@v3

      - name: Set up Go
        uses: actions/setup-go@v3
        with:
          go-version-file: 'go.mod'

      # ...
```

But I also wanted to specify that this should run against Go 1.21, without hardcoding 1.20 and 1.21 here, so I could use the `go.mod` as the guide for the version.

I came up with the following, somewhat complicated, setup:

```yaml
name: Build project
on: [ push, pull_request ]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      # perform matrix testing to give us an earlier insight into issues with different versions of supported major versions of Go
      matrix:
        # strategy is used to allow us to pin to a specific Go version, or use the version available in our `go.mod`
        strategy: ['go-version']
        version: [1.21]
        include:
          # pick up the Go version from the `go.mod`
          - strategy: 'go-version-file'
            version: 'go.mod'
    steps:
      - name: Check out source code
        uses: actions/checkout@v3

      - name: Set up Go
        uses: actions/setup-go@v3
        with:
          ${{ matrix.strategy }}: ${{ matrix.version }}
```
