---
title: "Managing Buildkite Agent Images with Renovate"
description: "How to use Renovate to manage Buildkite Agent Images."
date: 2023-08-22T11:52:52+0100
tags:
- "blogumentation"
- "renovate"
- "buildkite"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-buildkite-images
---
If you're using [Buildkite](https://buildkite.com/) for your builds, you may end up defining Docker images that you want your agents to run on, for instance:

```yaml
agents:
  image: "golang:1.19"
```

As with everything, I'm always striving to get [Renovate](https://docs.renovatebot.com) to make it easier to keep these versions updated.

As [mentioned on GitHub](https://github.com/renovatebot/renovate/discussions/24015), Renovate doesn't _yet_ support this in the [Buildkite manager](https://docs.renovatebot.com/modules/manager/buildkite/), so in the meantime we can use the [regex manager](https://docs.renovatebot.com/modules/manager/regex/):


```javascript
{
  "regexManagers": [
    {
      "fileMatch": [
        // default filepaths from the Buildkite manager
        "buildkite\\.ya?ml",
        "\\.buildkite/.+\\.ya?ml$",
        // additional configuration for nested directories
        "\\.buildkite/.+/.+\\.ya?ml$"
      ],
      "matchStrings": [
        "image:\\s*\"?(?<depName>[^\\s]+):(?<currentValue>[^\\s\"]+)\"?"
      ],
      "datasourceTemplate": "docker"
    }
  ]
}
```
