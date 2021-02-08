---
title: "Deploying a Branch to Netlify on the Command-Line"
description: "How to use Netlify's Node CLI to deploy a given branch to Netlify."
tags:
- blogumentation
- netlify
- netlify-cli
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-03T19:40:19+0100
slug: "netlify-cli-branch"
image: /img/vendor/netlify-full-logo-white.png
syndication:
- https://news.ycombinator.com/item?id=23407344
- https://lobste.rs/s/iuvnzx/deploying_branch_netlify_on_command_line
- https://dev.to/jamietanna/deploying-a-branch-to-netlify-on-the-command-line-44pg
---
I'm very excited to say that the Netlify CLI tool ([<i class="fa fa-github"></i>&nbsp;netlify/cli](https://github.com/netlify/cli)) [now](https://github.com/netlify/cli/pull/907) has the ability to deploy a branch on the command-line.

This has been a feature request since [at least 2018](https://github.com/netlify/cli/issues/44) and has been greatly anticipated from the community, and I've been wanting to use it for some time when using [GitLab CI]({{< ref 2018-04-12-gitlab-ci-netlify >}}) pipelines.

As of [netlify-cli@2.53.0](https://www.npmjs.com/package/netlify-cli/v/2.53.0), it's now possible to deploy using the `-b $branchName` flag:

```
% netlify deploy -b wibble
Deploy path:        /home/jamie/workspaces/talks/public
Configuration path: /home/jamie/workspaces/talks/netlify.toml
Deploying to draft URL...
✔ Finished hashing 286 files
✔ CDN requesting 0 files
✔ Finished uploading 0 assets
✔ Deploy is live!

Logs:              https://app.netlify.com/sites/epic-wozniak-9aa019/deploys/5ed7eaedb88cedbb42a9d341
Website Draft URL: https://wibble--epic-wozniak-9aa019.netlify.app

If everything looks good on your draft URL, deploy it to your main site URL with the --prod flag.
netlify deploy --prod
```

This is super exciting, and will help help folks deploying from Continuous Integration platforms, or with use cases where they don't want to use Netlify's Webhook integrations.
