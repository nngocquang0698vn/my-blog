---
title: "Enabling/Disabling GitHub Issues via the GitHub API"
description: "How to use the GitHub API to update whether Issues are enabled on a given repo or not."
date: 2023-01-03T17:58:51+0000
tags:
- blogumentation
- github
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-issues-enable-api
---
I recently needed to toggle whether GitHub Issues is enabled for a number of repositories, and wanted to automate it.

Searching through the GitHub docs I couldn't find anything super explicit, aside from [a UI-driven configuration](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/disabling-issues).

Thankfully one of my colleagues pointed me to the [Update a repo](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#update-a-repository) functionality, which includes the ability to specify PATCHing the `has_issues` field.

For instance, using the [`gh` CLI](https://cli.github.com/manual/gh_api):

```sh
# enable Issues
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /repos/jamietanna/oapi-codegen \
 -F has_issues=true
# disable Issues
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /repos/jamietanna/oapi-codegen \
 -F has_issues=false
```
