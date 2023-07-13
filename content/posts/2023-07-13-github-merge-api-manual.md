---
title: "Merging a branch in GitHub - the hard way"
description: "How to (kinda) merge two branches in GitHub using the underlying Git database API."
date: 2023-07-13T18:58:29+0100
tags:
- blogumentation
- github
- git
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-merge-api-manual
---
Today I've been looking at tweaking some code I'd written a while ago to merge a branch in GitHub, which currently uses the [Merge a branch]( https://docs.github.com/en/rest/branches/branches?apiVersion=2022-11-28#merge-a-branch) API.

This has been serving us well, but we wanted to tweak the [committer details](https://git-scm.com/docs/git-commit#_commit_information) on the created merge commit, which isn't possible in the API's current form.

Fortunately, GitHub has a [low level Git database API](https://docs.github.com/en/rest/git?apiVersion=2022-11-28), and taking inspiration from [this StackOverflow post](https://stackoverflow.com/a/63461333), we can perform the following steps to "do it the hard way", which also gives us a further understanding of how Git works under-the-hood!

We'll use the repo [jamietanna/github-merge-api-manual](https://github.com/jamietanna/github-merge-api-manual), which is set up like so.

On `main`:

```
commit f6aa02df261eadfe5f56e45e95590bb84054baab (origin/main, origin/HEAD, main)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:23:10 2023 +0100

    Initial commit
```

On `feature/something`:

```
commit 0bda88fbc64fe82f8630cd301f78230132d9eccb (HEAD -> feature/something, origin/feature/something)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:25:12 2023 +0100

    Changes

commit f6aa02df261eadfe5f56e45e95590bb84054baab (origin/main, origin/HEAD, main)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:23:10 2023 +0100

    Initial commit
```

And on `shared-branch`:

```
commit cd67b7454723133d33c72e445e943b11c0240a11 (origin/shared-branch, shared-branch)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:23:36 2023 +0100

    Update shared-branch

 README.md | 2 ++
 1 file changed, 2 insertions(+)

commit f6aa02df261eadfe5f56e45e95590bb84054baab (origin/main, origin/HEAD, main)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:23:10 2023 +0100

    Initial commit

 README.md | 3 +++
 1 file changed, 3 insertions(+)
```

In this example we want to merge the commits from `feature/something` into `shared-branch`.

## Retrieve the current Git Tree SHA for `feature/something`

```sh
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/0bda88fbc64fe82f8630cd301f78230132d9eccb
```

This returns:

```json
{
  "sha": "0bda88fbc64fe82f8630cd301f78230132d9eccb",
  "node_id": "C_kwDOJ7Oy4toAKDBiZGE4OGZiYzY0ZmU4MmY4NjMwY2QzMDFmNzgyMzAxMzJkOWVjY2I",
  "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/0bda88fbc64fe82f8630cd301f78230132d9eccb",
  "html_url": "https://github.com/jamietanna/github-merge-api-manual/commit/0bda88fbc64fe82f8630cd301f78230132d9eccb",
  "author": {
    "name": "Jamie Tanna",
    "email": "<...>",
    "date": "2023-07-13T17:25:12Z"
  },
  "committer": {
    "name": "Jamie Tanna",
    "email": "<...>",
    "date": "2023-07-13T17:25:12Z"
  },
  "tree": {
    "sha": "27e7cf23f961cf4c405b72fdc10a12d079e5e045",
    "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/trees/27e7cf23f961cf4c405b72fdc10a12d079e5e045"
  },
  "message": "Changes",
  "parents": [
    {
      "sha": "f6aa02df261eadfe5f56e45e95590bb84054baab",
      "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/f6aa02df261eadfe5f56e45e95590bb84054baab",
      "html_url": "https://github.com/jamietanna/github-merge-api-manual/commit/f6aa02df261eadfe5f56e45e95590bb84054baab"
    }
  ],
  "verification": {
    "verified": false,
    "reason": "unsigned",
    "signature": null,
    "payload": null
  }
}
```

## Create a merge commit

```sh
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits \
  -d '{
  "author": {
    "date": "2023-07-13T18:34:35+01:00",
    "email": "example@example.com",
    "name": "The Merge Bot"
  },
  "message": "Merge branch feature/something into shared-branch",
  "parents": [
    "0bda88fbc64fe82f8630cd301f78230132d9eccb",
    "cd67b7454723133d33c72e445e943b11c0240a11"
  ],
  "signature": "",
  "tree": "27e7cf23f961cf4c405b72fdc10a12d079e5e045"
}'

```

```json
{
  "sha": "b11874650d3b61e02daaf71bd262728fbc1eb956",
  "node_id": "C_kwDOJ7Oy4toAKGIxMTg3NDY1MGQzYjYxZTAyZGFhZjcxYmQyNjI3MjhmYmMxZWI5NTY",
  "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/b11874650d3b61e02daaf71bd262728fbc1eb956",
  "html_url": "https://github.com/jamietanna/github-merge-api-manual/commit/b11874650d3b61e02daaf71bd262728fbc1eb956",
  "author": {
    "name": "The Merge Bot",
    "email": "example@example.com",
    "date": "2023-07-13T17:34:35Z"
  },
  "committer": {
    "name": "The Merge Bot",
    "email": "example@example.com",
    "date": "2023-07-13T17:34:35Z"
  },
  "tree": {
    "sha": "27e7cf23f961cf4c405b72fdc10a12d079e5e045",
    "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/trees/27e7cf23f961cf4c405b72fdc10a12d079e5e045"
  },
  "message": "Merge branch feature/something into shared-branch",
  "parents": [
    {
      "sha": "cd67b7454723133d33c72e445e943b11c0240a11",
      "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/cd67b7454723133d33c72e445e943b11c0240a11",
      "html_url": "https://github.com/jamietanna/github-merge-api-manual/commit/cd67b7454723133d33c72e445e943b11c0240a11"
    },
    {
      "sha": "0bda88fbc64fe82f8630cd301f78230132d9eccb",
      "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/0bda88fbc64fe82f8630cd301f78230132d9eccb",
      "html_url": "https://github.com/jamietanna/github-merge-api-manual/commit/0bda88fbc64fe82f8630cd301f78230132d9eccb"
    }
  ],
  "verification": {
    "verified": false,
    "reason": "unsigned",
    "signature": null,
    "payload": null
  }
}
```

## Pushing that commit to the branch

You'll notice that if you tried to look up the created commit that it doesn't yet exist.

This is because although the commit exists, it doesn't yet belong to a branch or tag.

We will therefore need to update the current state of `shared-branch` to point to this

```sh
# ideally you would check that the SHA currently on `shared-branch` matches the commit we're expecting, in case we inadvertently overwrite any changes (albeit this isn't a "force" push)
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/jamietanna/github-merge-api-manual/git/refs/heads/shared-branch \
  -d '{"sha":"b11874650d3b61e02daaf71bd262728fbc1eb956"}'
```

```json
{
  "ref": "refs/heads/shared-branch",
  "node_id": "REF_kwDOJ7Oy4rhyZWZzL2hlYWRzL3NoYXJlZC1icmFuY2g",
  "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/refs/heads/shared-branch",
  "object": {
    "sha": "b11874650d3b61e02daaf71bd262728fbc1eb956",
    "type": "commit",
    "url": "https://api.github.com/repos/jamietanna/github-merge-api-manual/git/commits/b11874650d3b61e02daaf71bd262728fbc1eb956"
  }
}
```

## Merging schmerging

You'll notice that **no it did not** work. Although the commit looks cleanly applied:

```
commit f07cafa1512dd48d6439cffb0835eaccdebe6ea1 (HEAD -> shared-branch, origin/shared-branch)
Merge: 0bda88f cd67b74
Author: The Merge Bot <example@example.com>
Date:   Thu Jul 13 18:34:35 2023 +0100

    Merge branch feature/something into shared-branch

commit 0bda88fbc64fe82f8630cd301f78230132d9eccb (origin/feature/something, feature/something)
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:25:12 2023 +0100

    Changes

diff --git another-file.md another-file.md
new file mode 100644
index 0000000..d675fa4
--- /dev/null
+++ another-file.md
@@ -0,0 +1 @@
+foo bar

commit cd67b7454723133d33c72e445e943b11c0240a11
Author: Jamie Tanna <<...>>
Date:   Thu Jul 13 18:23:36 2023 +0100

    Update shared-branch

diff --git README.md README.md
index 78da8fc..7b009ca 100644
--- README.md
+++ README.md
@@ -1,3 +1,5 @@
 # Example for Merging a branch in GitHub - the hard way

 [Merging a branch in GitHub - the hard way](https://www.jvt.me/posts/2023/07/13/github-merge-api-manual/)
+
+... work has happened
```

What we see when we compare against the previous state of the branch is that we've **lost some changes**:

```
git diff cd67b7454723133d33c72e445e943b11c0240a11
diff --git README.md README.md
index 7b009ca..78da8fc 100644
--- README.md
+++ README.md
@@ -1,5 +1,3 @@
 # Example for Merging a branch in GitHub - the hard way

 [Merging a branch in GitHub - the hard way](https://www.jvt.me/posts/2023/07/13/github-merge-api-manual/)
-
-... work has happened
diff --git another-file.md another-file.md
new file mode 100644
index 0000000..d675fa4
--- /dev/null
+++ another-file.md
@@ -0,0 +1 @@
+foo bar
```

I'll look to edit this post at the point I've resolved it ([tracking issue](https://gitlab.com/tanna.dev/jvt.me/-/issues/1312)), but I believe the best route is to look through the tree for both `shared-branch` and `feature/something`, comparing differences, and trying to apply both branch's changes.

However, that's fairly complex, which is why we use tools like Git to manage this instead of doing it by hand.
