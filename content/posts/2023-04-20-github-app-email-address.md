---
title: Getting the commit author details for a GitHub App account
description: How to retrieve the git commit author details for a given GitHub App.
tags:
- blogumentation
- github
date: 2023-04-20T07:38:01+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: github-app-email-address
---
When using [GitHub Apps](https://docs.github.com/en/developers/apps/building-github-apps/), you may want to commit files to repos, and have the right commit metadata set up so the author shows correctly.

Getting this email address is unfortunately a little awkward, and doesn't seem to be made _super_ visible in the GitHub UI or docs, so I thought I'd [blogument](https://www.jvt.me/posts/2017/06/25/blogumentation/) it.

For instance, let's say that we want to find the email for [Renovate GitHub app](https://github.com/apps/renovate) and write a commit like ([example commit](https://github.com/renovatebot/renovate/commit/c5a5c891104b82c0862b5d009c697be4a4716602)), which has the commit header:

```
commit c5a5c891104b82c0862b5d009c697be4a4716602 (tag: 35.31.1)
Author: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>
Date:   Sat Apr 1 12:11:23 2023 +0200

    build(deps): update dependency @renovatebot/osv-offline to v1.2.4 (#21277)

    Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

 package.json |  2 +-
 yarn.lock    | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)
```

The ID here that is key is that we want to take the user ID of the bot account that's created for the app, which can be found on the lookup of the user, allowing us to write the following script:

```sh
app_name=renovate
username="${app_name}[bot]"
app_id="$(gh api "/users/$username" --jq '.id')"

echo "Author: $username <${app_id}+${username}@users.noreply.github.com>"
```
