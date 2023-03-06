---
title: "Extracting the dependency tree from Renovate for given repositories"
description: "Creating a (hacky) solution to retrieve the dependency graph from Renovate\
  \ for a set of repositories."
date: "2022-11-01T17:03:11+0000"
syndication:
- "https://twitter.com/JamieTanna/status/1587494598410223616"
tags:
- "blogumentation"
- "renovate"
- "open-source"
- "security"
- "typescript"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: "renovate-dependency-graph"
---
As I wrote about in [_Analysing our dependency trees to determine where we should send Open Source contributions for Hacktoberfest_](https://www.jvt.me/posts/2022/09/29/roo-hacktoberfest-dependency-analysis/) I've been recently playing around Dependabot and the GitHub Advanced Security API, and using it both for managing maintenance of our dependencies, as well as getting better visibility across dependency usage.

One thing I've been finding with Dependabot is that it's leading to notification fatigue - partly due to being originally set up as daily updates (my bad!) but also because it doesn't allow workflows like combining PRs into one.

While talking about options to write some tooling to be able to do this for us, I took a step back to being able to leverage other tools for this purpose, instead of just Dependabot.

Fortunately I've used [Renovate](https://docs.renovatebot.com/) before for dependency management (and have [some good tips for getting the most out of it](https://www.jvt.me/posts/2021/09/26/whitesource-renovate-tips/)) both professionally, and personally with my projects on GitLab.com. Renovate is much more fully-featured with the functionality it supports, allowing these workflows, among other great features.

(Fun aside - this is the first time I heard that WhiteSource, the company that runs Renovate, had been renamed Mend! I'll update the tags across my posts at a later point)

After getting it set up for trialing it on a few projects, I considered that retrieving the dependency graph should be possible, as the Renovate runner executes purely locally, so at some point the full dependency graph should be usable.

Looking around the documentation or `renovate --help`, I couldn't find anything, but eventually found [this GitHub Discussion](https://github.com/renovatebot/renovate/discussions/13150) where someone had found a solution for doing this. Unhappy with this as a solution, last night I decided to play around with the Renovate code and see if I could get a raw export of the dependency graph Renovate sees.

The TL;DR is, yes you can, but it's a little hacky. You can find [the project on GitLab.com](https://gitlab.com/tanna.dev/renovate-graph).

Via the README, running the following:

```sh
npm i @jamietanna/renovate-graph
renovate-graph --token $GITHUB_COM_TOKEN jamietanna/jamietanna
```

Will create the file `out/jamietanna-jamietanna.json`, which contains the internal dependency data that Renovate sees, i.e.:

```json
{
  "github-actions": [
    {
      "deps": [
        {
          "autoReplaceStringTemplate": "{{depName}}@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentDigest": "ec3a7ce113134d7a93b817d10a8272cb61118579",
          "datasource": "github-tags",
          "depIndex": 0,
          "depName": "actions/checkout",
          "depType": "action",
          "replaceString": "actions/checkout@ec3a7ce113134d7a93b817d10a8272cb61118579",
          "updates": [
            {
              "branchName": "renovate/actions-checkout-digest",
              "newDigest": "1f9a0c22da41e6ebfa534300ef656657ea2c6707",
              "updateType": "digest"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        },
        {
          "autoReplaceStringTemplate": "{{depName}}@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentDigest": "c1aec4ac820532bab364f02a81873c555a0ba3a1",
          "datasource": "github-tags",
          "depIndex": 1,
          "depName": "ossf/scorecard-action",
          "depType": "action",
          "replaceString": "ossf/scorecard-action@c1aec4ac820532bab364f02a81873c555a0ba3a1",
          "updates": [
            {
              "branchName": "renovate/ossf-scorecard-action-digest",
              "newDigest": "066a051e5c2c336158e3c5728cd80ccb1276afbf",
              "updateType": "digest"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        },
        {
          "autoReplaceStringTemplate": "{{depName}}@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentDigest": "82c141cc518b40d92cc801eee768e7aafc9c2fa2",
          "datasource": "github-tags",
          "depIndex": 2,
          "depName": "actions/upload-artifact",
          "depType": "action",
          "replaceString": "actions/upload-artifact@82c141cc518b40d92cc801eee768e7aafc9c2fa2",
          "updates": [
            {
              "branchName": "renovate/actions-upload-artifact-digest",
              "newDigest": "83fd05a356d7e2593de66fc9913b3002723633cb",
              "updateType": "digest"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        },
        {
          "autoReplaceStringTemplate": "{{depName}}/upload-sarif@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentDigest": "5f532563584d71fdef14ee64d17bafb34f751ce5",
          "datasource": "github-tags",
          "depIndex": 3,
          "depName": "github/codeql-action",
          "depType": "action",
          "replaceString": "github/codeql-action/upload-sarif@5f532563584d71fdef14ee64d17bafb34f751ce5",
          "updates": [
            {
              "branchName": "renovate/github-codeql-action-digest",
              "newDigest": "72bd9cbe6202944172589017f5da396f981101cf",
              "updateType": "digest"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        }
      ],
      "packageFile": ".github/workflows/main-scorecards-analysis.yml"
    },
    {
      "deps": [
        {
          "autoReplaceStringTemplate": "{{depName}}@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentValue": "v2",
          "currentVersion": "v2",
          "datasource": "github-tags",
          "depIndex": 0,
          "depName": "actions/setup-go",
          "depType": "action",
          "fixedVersion": "v2",
          "isSingleVersion": true,
          "replaceString": "actions/setup-go@v2",
          "sourceUrl": "https://github.com/actions/setup-go",
          "updates": [
            {
              "branchName": "renovate/actions-setup-go-3.x",
              "bucket": "major",
              "newMajor": 3,
              "newMinor": null,
              "newValue": "v3",
              "newVersion": "v3",
              "releaseTimestamp": "2022-10-17T16:33:22.000Z",
              "updateType": "major"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        },
        {
          "autoReplaceStringTemplate": "{{depName}}@{{#if newDigest}}{{newDigest}}{{#if newValue}} # tag={{newValue}}{{/if}}{{/if}}{{#unless newDigest}}{{newValue}}{{/unless}}",
          "commitMessageTopic": "{{{depName}}} action",
          "currentValue": "v2",
          "currentVersion": "v2",
          "datasource": "github-tags",
          "depIndex": 1,
          "depName": "actions/checkout",
          "depType": "action",
          "fixedVersion": "v2",
          "isSingleVersion": true,
          "replaceString": "actions/checkout@v2",
          "sourceUrl": "https://github.com/actions/checkout",
          "updates": [
            {
              "branchName": "renovate/actions-checkout-3.x",
              "bucket": "major",
              "newMajor": 3,
              "newMinor": null,
              "newValue": "v3",
              "newVersion": "v3",
              "releaseTimestamp": "2022-10-04T09:37:06.000Z",
              "updateType": "major"
            }
          ],
          "versioning": "docker",
          "warnings": [

          ]
        }
      ],
      "packageFile": ".github/workflows/rebuild.yml"
    }
  ]
}
```

From here we can see the `depName`, `depType` and `packageFile` as the key information here, but could also add other metadata as appropriate.

Alternatively, and handier for when running against quite a few repos, you can run it with `--autodiscover`:

```sh
# or with autodiscovery and a filter
renovate-graph --token $GITHUB_COM_TOKEN --autodiscover --autodiscover-filter 'jamietanna/*'
```

Which then populates many files in the `out` directory.

As per the README of the project, you can then use the [`dmd` CLI](https://gitlab.com/tanna.dev/dependency-management-data/) to convert this to an SQLite database, as well as perform other transformations.
