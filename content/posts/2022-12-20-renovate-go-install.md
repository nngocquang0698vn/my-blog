---
title: "Using Renovate to manage updates to `go install` commands"
description: "How to run Renovate to manage dependency version updates for cases where you're `go install`ing them."
date: 2022-12-20T09:40:45+0000
syndication:
- https://brid.gy/publish/twitter
tags:
- "blogumentation"
- "renovate"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-go-install
---
As mentioned in [_Using Renovate to manage updates to `golangci-lint` versions_](https://www.jvt.me/posts/2022/12/15/renovate-golangci-lint/),  Renovate is great for managing your dependency updates.

By using [the custom regex manager](https://docs.renovatebot.com/modules/manager/regex/), we can craft the following Renovate configuration:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "regexManagers": [
    {
      "fileMatch": [
        ".sh$"
      ],
      "matchStrings": [
        "go install (?<depName>[^@]+?)@(?<currentValue>[0-9.-a-zA-Z]+?)"
      ],
      "datasourceTemplate": "go"
    }
  ]
}
```

This then allows us to take commands such as:

```sh
go install github.com/deepmap/oapi-codegen@v1.11.0
```

Note that this will not try and update dependencies that aren't pointing to tags, such as `@latest`, `@HEAD` or pointing to a Git SHA.
