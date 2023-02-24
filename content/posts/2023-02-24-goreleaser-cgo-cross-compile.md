---
title: "Cross-compiling a CGO project using Goreleaser"
description: "How to use `goreleaser-cross` to cross-compile a Go command-line tool."
tags:
- blogumentation
- go
- goreleaser
- gitlab-ci
date: 2023-02-24T21:28:41+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: goreleaser-cgo-cross-compile
image: https://media.jvt.me/b41202acf7.png
---
While working on creating a new Go CLI [`dmd`](https://www.jvt.me/posts/2023/02/20/dmd-cli/), I wanted to set up [Gorelaser](https://goreleaser.com/) to make?  .

I thought I had it working until I realised that I was using a library that required CGO to be built, which meant that the binaries I was building weren't actually working.

I started looking through the [Goreleaser CGO docs](https://goreleaser.com/limitations/cgo/), but found that the examples weren't as prescriptive as I'd hoped, and as I'm not as familiar with building for CGO, I spent a bit of time trying to track down how it all works.

Fortunately, the [goreleaser-cross](https://github.com/goreleaser/goreleaser-cross) docs linked to [the Akash project](https://github.com/ovrclk/akash) which pointed me towards the right combination of configuration I needed.

I needed to set the following configuration for GitLab CI, using the `goreleaser-cross` image that includes all the build tools we need:

```yaml
release:
  stage: release
  only:
    - tags
  dependencies: []
  image:
    name: goreleaser/goreleaser-cross:v1.20
    entrypoint: ['']
  variables:
    GIT_DEPTH: 0
  script:
    - goreleaser release
```

And then I had the following `.goreleaser.yaml`:

```yaml
# via https://gitlab.com/tanna.dev/dependency-management-data/blob/v0.3.1/.goreleaser.yaml
env:
- CGO_ENABLED=1
builds:
  - id: dmd-darwin-amd64
    binary: dmd
    main: ./cmd/dmd
    goarch:
      - amd64
    goos:
      - darwin
    env:
      - CC=o64-clang
      - CXX=o64-clang++
    flags:
      - -trimpath

  - id: dmd-darwin-arm64
    binary: dmd
    main: ./cmd/dmd
    goarch:
      - arm64
    goos:
      - darwin
    env:
      - CC=oa64-clang
      - CXX=oa64-clang++
    flags:
      - -trimpath
  - id: dmd-linux-amd64
    binary: dmd
    main: ./cmd/dmd
    env:
      - CC=x86_64-linux-gnu-gcc
      - CXX=x86_64-linux-gnu-g++
    goarch:
      - amd64
    goos:
      - linux
    flags:
      - -trimpath
    ldflags:
      - -extldflags "-lc -lrt -lpthread --static"
  - id: dmd-linux-arm64
    binary: dmd
    main: ./cmd/dmd
    goarch:
      - arm64
    goos:
      - linux
    env:
      - CC=aarch64-linux-gnu-gcc
      - CXX=aarch64-linux-gnu-g++
    flags:
      - -trimpath
    ldflags:
      - -extldflags "-lc -lrt -lpthread --static"
  - id: dmd-windows-amd64
    binary: dmd
    main: ./cmd/dmd
    goarch:
      - amd64
    goos:
      - windows
    env:
      - CC=x86_64-w64-mingw32-gcc
      - CXX=x86_64-w64-mingw32-g++
    flags:
      - -trimpath
      - -buildmode=exe

universal_binaries:
  - id: dmd-darwin-universal
    ids:
      - dmd-darwin-amd64
      - dmd-darwin-arm64
    replace: true
    name_template: "dmd"
archives:
  - id: w/version
    builds:
      - dmd-darwin-universal
      - dmd-linux-amd64
      - dmd-linux-arm64
      - dmd-windows-amd64
    name_template: "dmd_{{ .Version }}_{{ .Os }}_{{ .Arch }}"
    wrap_in_directory: false
    format: zip
    files:
      - none*
  - id: wo/version
    builds:
      - dmd-darwin-universal
      - dmd-linux-amd64
      - dmd-linux-arm64
      - dmd-windows-amd64
    name_template: "dmd_{{ .Os }}_{{ .Arch }}"
    wrap_in_directory: false
    format: zip
    files:
      - none*

checksum:
  name_template: 'checksums.txt'
snapshot:
  name_template: "{{ incpatch .Version }}-next"
changelog:
  sort: asc
gitlab_urls:
  use_package_registry: true
```

This ends up building the perfect combination of binaries for each of the platforms we need.
