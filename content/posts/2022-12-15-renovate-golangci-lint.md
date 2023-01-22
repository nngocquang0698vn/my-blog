---
title: "Using Renovate to manage updates to `golangci-lint` versions"
description: "How to run Renovate to manage your `golangci-lint` dependency versions, using the official installation script."
date: 2022-12-15T21:44:14+0000
syndication:
- https://brid.gy/publish/twitter
tags:
- "blogumentation"
- "renovate"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: "renovate-golangci-lint"
aliases:
- /posts/2022/12/15/renovate-golangci-lint/
---
Although I used to recommend using a [`tools.go` to track the dependency versions](https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/) for [`golangci-lint`](https://github.com/golangci/golangci-lint), I've since learned why it's not the recommended route, and have gone back to the [official install instructions](https://golangci-lint.run/usage/install/#other-ci).

With the official install, you use a shell script to download this, which means you'll have, presumably in a `Makefile`:

```make
$(GOBIN)/golangci-lint:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(GOBIN) v1.50.1
```

However, with me recently using Renovate for dependency management, I've been disappointed by not being able to keep up-to-date with version upgrades automagically with this way of installing `golangci-lint`, or at least so I thought

While looking through some unrelated things in the Renovate docs, I discovered [the custom regex manager](https://docs.renovatebot.com/modules/manager/regex/) for dependencies, which means we can write the following Renovate configuration:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "regexManagers": [
    {
      "fileMatch": ["^Makefile$"],
      "matchStrings": [
        "curl .*https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- .* (?<currentValue>.*?)\\n"
      ],
      "depNameTemplate": "github.com/golangci/golangci-lint",
      "datasourceTemplate": "go"
    }
  ]
}
```

This allows us to use `golangci-lint`'s dependency data from Renovate, and performs an in-place update for the dependency as and when it's updated - awesome 🙌
