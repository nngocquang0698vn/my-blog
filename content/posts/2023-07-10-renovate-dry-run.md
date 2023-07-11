---
title: "Validating Renovate configuration changes before merging"
description: "How to perform a dry run to validate your Renovate config before it's merged."
date: 2023-07-10T21:25:36+0100
tags:
- "blogumentation"
- "renovate"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-dry-run
---
If you're developing custom rules within Renovate, in particular as part of [shareable config presets](https://docs.renovatebot.com/config-presets/) but even if they're just within your repo, it's handy to be able to test it first.

This is something I've done several times and have put together a little boilerplate for, so thought I'd blogument it.

We can create a file, `config.js` and add the following configuration to it. Note that this _must_ be called `config.js` for Renovate to pick it up.

```javascript
module.exports = {
  // --------------------------------------------------------------------------------
  // required configuration, which makes sure that we
  "onboarding": false,
  "requireConfig": "ignored",

  // --------------------------------------------------------------------------------
  // optional configuration

  // optional but recommended to keep if you don't want to have PRs/issues raised. Alternatively, set it to `full` to see what Renovate would compute as expected updates
  "dryRun": "extract",

  // --------------------------------------------------------------------------------
  // finally, the configuration we're looking to validate

  // make sure that we reduce the work that this test run is going to perform - this isn't meant to be in your production configuration!
  "enabledManagers": [
    "regex"
  ],

  // the actual rules
  "regexManagers": [
    {
      "fileMatch": [
        "^tools/dev/loki-boltdb-storage-s3/dev.dockerfile$"
      ],
      "matchStrings": [
        "go install (?<depName>[^@]+?)@(?<currentValue>v[0-9.-a-zA-Z]+)"
      ],
      "datasourceTemplate": "go"
    }
  ]
}
```

Notice that we're writing our configuration as if it's JSON - this is intentional to make it easier to copy-paste between the `config.js` and our subsequent JSON configuration.

Then we can run:

```sh
# I'd recommend using `LOG_LEVEL` to get more info about exactly what Renovate has parsed out of your rules
env LOG_LEVEL=debug renovate --token $GITHUB_TOKEN grafana/loki
```

This will then give us:

```
DEBUG: Applying enabledManagers filtering (repository=grafana/loki)
DEBUG: Using file match: ^tools/dev/loki-boltdb-storage-s3/dev.dockerfile$ for manager regex (repository=grafana/loki)
DEBUG: Matched 1 file(s) for manager regex: tools/dev/loki-boltdb-storage-s3/dev.dockerfile (repository=grafana/loki)
DEBUG: manager extract durations (ms) (repository=grafana/loki)
       "managers": {"regex": 2}
DEBUG: Found regex package files (repository=grafana/loki)
DEBUG: Found 1 package file(s) (repository=grafana/loki)
 INFO: Dependency extraction complete (repository=grafana/loki, baseBranch=main)
       "stats": {
         "managers": {"regex": {"fileCount": 1, "depCount": 1}},
         "total": {"fileCount": 1, "depCount": 1}
       }
 INFO: Extracted dependencies (repository=grafana/loki)
       "packageFiles": {
         "regex": [
           {
             "deps": [
               {
                 "depName": "github.com/go-delve/delve/cmd/dlv",
                 "currentValue": "v1.20.2",
                 "datasource": "go",
                 "replaceString": "go install github.com/go-delve/delve/cmd/dlv@v1.20.2"
               }
             ],
             "matchStrings": [
               "go install (?<depName>[^@]+?)@(?<currentValue>v[0-9.-a-zA-Z]+)"
             ],
             "datasourceTemplate": "go",
             "packageFile": "tools/dev/loki-boltdb-storage-s3/dev.dockerfile"
           }
         ]
       }
```

Which as we can see, has successfully picked up the right dependency and version.

(Aside - this exact example [doesn't quite work](https://gitlab.com/tanna.dev/jvt.me/-/issues/1310))
