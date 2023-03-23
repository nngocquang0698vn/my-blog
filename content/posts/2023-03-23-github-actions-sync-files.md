---
title: Ensuring files are synced between repos with GitHub Actions
description: Creating a GitHub Action workflow to indicate when vendored files are out-of-sync between GitHub repos.
tags:
- blogumentation
- github
- github-actions
date: 2023-03-23T21:12:28+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: github-actions-sync-files
---
There are cases where you want to keep files in-sync between repos by manually vendoring them, and periodically updating them.

I've been doing this with OpenAPI specifications in some repos, but wanted a handy way to make it visible that they're up-to-date.

Until I get around to [implementing this into Renovate](https://github.com/renovatebot/renovate/issues/4759) I thought I'd add a GitHub Action that at least makes it known that the OpenAPI files are out-of-sync.

We can create i.e. `.github/workflows/sync-foo-service-openapi.yaml`:

```yaml
name: "Validate Petstore's OpenAPI spec is in sync"
permissions:
  contents: read
  pull-requests: write
on:
  push: {}
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Fetch Petstore's latest OpenAPI
        run: |
          set -o pipefail
          gh api /repos/deepmap/oapi-codegen/contents/examples/petstore-expanded/petstore-expanded.yaml --template '{{ .content }}' | base64 -d > head.yaml
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: "Is Petstore's OpenAPI up-to-date?"
        run: |
          git diff --color --no-index petstore.yaml head.yaml || \
            echo "::warning file=petstore.yaml::File is out-of-sync with upstream repo"
```

Note that the `GH_TOKEN` needs to be a personal access token (classic or fine-grained) that can read it, or if the repo we're retrieving from is public, we can use the default `GITHUB_TOKEN`.

We can see this in action [in this PR](https://github.com/jamietanna/example-github-actions-sync-files/pull/1), where we can see the annotation to show that the file is out-of-sync.

This also highlights on a PR where there isn't a change to the OpenAPI file, [for example in this PR](https://github.com/jamietanna/example-github-actions-sync-files/pull/2/files).
