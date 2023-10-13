---
title: "Utilising Renovate's `local` platform to make `renovate-graph` more efficient"
description: "How using the `local` platform with `renovate-graph` can increase the performance of dependency extraction."
date: 2023-10-13T18:12:37+0100
tags:
- "blogumentation"
- "renovate"
- dependency-management-data
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-graph-local
---
Last year I built [`renovate-graph`](https://www.jvt.me/posts/2022/11/01/renovate-dependency-graph/), a tool to extract the dependency trees for a given repository, which under the hood uses [Renovate](https://docs.renovatebot.com/). I've been getting tonnes of value from it as part of how it fits into the wider [dependency-management-data](https://dmd.tanna.dev) ecosystem, and providing more actionable data for understanding how you use internal and external dependencies in your projects.

However, I've found that when running this against several larger repositories, the performance starts to suffer, largely due to the way that `renovate-graph` is a rather hacky wrapper around Renovate.

Whereas Renovate is expected to run against a fully cloned repository, so it can create branches with expected package changes, `renovate-graph` just needs to run against (generally) the latest branch of a repository.

One option I'd been investigating to improve performance was to expose the ability to [tune the arguments passed to `git clone` by Renovate](https://github.com/renovatebot/renovate/discussions/24985), so we could perform a shallow clone, but then I stumbled upon Renovate's [`local` platform](https://docs.renovatebot.com/modules/platform/local/).

The `local` platform allows us to run against a local directory (that doesn't even need to have a `.git` folder), which is perfect for `renovate-graph` as it's a read-only operation to purely extract the dependencies for a given repo.

So what performance gains? Note that we're using [`renovate-graph` v0.15.1](https://gitlab.com/tanna.dev/renovate-graph/-/tags/v0.15.1) for these comparisons.

If we take a somewhat unscientific comparison, we'll focus on using [Kibana](https://github.com/elastic/kibana), which is a significant size - the repository checks out at 6.7GB, and the source-only archive at 670MB.

We'll first use `renovate-graph` when executing against GitHub to clone + then process the repo _without_ dependency updates lookup:

```sh
time env LOG_LEVEL=warn RG_DELETE_CLONED_REPOS=true RG_INCLUDE_UPDATES=false npx @jamietanna/renovate-graph@v0.15.1 --token $GITHUB_TOKEN elastic/kibana
# 78.37s user 29.07s system 13% cpu 13:01.17 total
```

Next, if we perform the same process, but by pulling a source-only archive from GitHub + then process the repo _without_ dependency updates lookup:

```sh
time gh api /repos/elastic/kibana/zipball/HEAD > kibana.zip
# 8.38s user 13.89s system 4% cpu 7:27.44 total
unzip kibana.zip
# 5.14s user 1.65s system 97% cpu 6.940 total
cd elastic-kibana-*
# HACK to avoid https://github.com/renovatebot/renovate/discussions/25202
rm renovate.json

time env LOG_LEVEL=warn RG_DELETE_CLONED_REPOS=true RG_INCLUDE_UPDATES=false RG_LOCAL_PLATFORM=github RG_LOCAL_ORGANISATION=elastic RG_LOCAL_REPO=kibana npx @jamietanna/renovate-graph@v0.15.1 --platform local
# 17.66s user 3.08s system 126% cpu 16.433 total
```

To compare these:

<table>
  <tr>
  <th>
  <code>platform=github</code>
  </th>
  <th>
  <code>platform=local</code>
  </th>
  </tr>
  <tr>
  <td>
  781
  </td>
  <td>
  454
  </td>
  </tr>
</table>

So we can see that there's a 72% increase on processing with `local` platform 🎉 (if I've done that maths correctly 😅)
