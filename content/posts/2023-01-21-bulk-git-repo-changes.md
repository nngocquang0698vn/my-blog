---
title: "Performing bulk changes across Git(Hub) Repos with Turbolift and Microplane"
description: "Using Turbolift and Microplane to enact changes across many Git(Hub) repositories."
date: 2023-01-21T15:14:10+0000
tags:
- blogumentation
- git
- github
- turbolift
- microplane
- automation
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: bulk-git-repo-changes
syndication:
- https://brid.gy/publish/twitter
---
Over the years, there have been many times I've needed to roll out changes across dozens of repositories. Sometimes it's been to do a bulk find-and-replace to avoid deprecation warnings, to introduce shared configuration for Renovate, or to tweak what commands are used to build the project.

I've mostly written one-off scripts for this, but recently one of my colleagues pointed me towards [Microplane](https://github.com/clever/microplane) which she's been using for automation. As I had some changes to make over a few dozen repos this week, I gave it some real-world usage, and found it made the changes much eaiser.

As I was preparing to write this post about using it, I thought I'd look at some of the other options out there for this functionality and found [Turbolift](https://github.com/skyscanner/turbolift), which also looks quite nice, and this gives me a good chance to play with it too.

Below we'll look at how Microplane and Turbolift make the following change to a GitHub Actions Workflow:

```diff
 name: Build project
 on: [push, pull_request]
 jobs:
   build:
     name: Build
     runs-on: ubuntu-latest
     steps:
       - name: Check out source code
         uses: actions/checkout@v3

       - name: Set up Go
         uses: actions/setup-go@v3
         with:
           go-version-file: 'go.mod'

       - name: Test
-        run: go test ./...
+        run: make test
```

# Microplane

Using Microplane, we would run:

```sh
echo jamietanna/bulk-changes-repo > repos.txt
mp init -f repos.txt
mp clone
# alternatively add a `-d` flag to see a diff of the changes proposed
mp plan --branch microplane/makefile --message 'Use make tasks for consistency' -- sed -i 's|go test ./...|make test|' .github/workflows/build.yml
mp push --assignee jamietanna
```

This produces [this PR](https://github.com/jamietanna/bulk-changes-repo/pull/1).

Microplane then has a handy way of allowing you to check the status of the open PRs by `sync`ing, and then running `status`:

```sh
mp sync
2023/01/21 14:46:16 syncing: jamietanna/bulk-changes-repo
2023/01/21 14:46:17 synced: jamietanna/bulk-changes-repo
mp status
REPO                    STATUS          DETAILS
bulk-changes-repo       pushed          status:🕐  assignee:jamietanna https://github.com/jamietanna/bulk-changes-repo/pull/1
```

This can then be auto-merged, with the ability to prevent merging broken builds:

```sh
mp merge
2023/01/21 14:48:30 jamietanna/bulk-changes-repo - merging...
2023/01/21 14:48:32 jamietanna/bulk-changes-repo - merge error: Build status was not 'success', instead was 'pending'. Use --ignore-build-status to override this check.
2023/01/21 14:48:32 Build status was not 'success', instead was 'pending'. Use --ignore-build-status to override this check.
```

I have noticed that being an organisation admin means that you can sometimes merge without status checks or reviews being required - beware!

# Turbolift

With Turbolift, we would run:

```sh
turbolift init --name use-makefile
cd use-makefile
echo jamietanna/bulk-changes-repo > repos.txt
# --no-fork in this case because the repo is owned by me
turbolift clone --no-fork
# note the quotes around the script
turbolift foreach "sed -i 's|go test ./...|make test|' .github/workflows/build.yml"
# alternatively, `cd` into the repo under the work directory and modify as needed
turbolift foreach git add .github/workflows/build.yml
turbolift commit --message 'Use make tasks for consistency'
# edit the PR description through the contents of README.md
vim README.md
turbolift create-prs
```

This produces [this PR](https://github.com/jamietanna/bulk-changes-repo/pull/2).

Turbolift doesn't yet have the ability [to list the status](https://github.com/Skyscanner/turbolift/issues/18) of PRs raised by it, or to merge them automagically.

# Comparing

Having used Turbolift for even this trivial example, I have to say there are a few things that make it nicer to work with compared to Microplane:

- the ability to edit the repositories directly, if you'd like
- not neding to have a single script / step to complete the repository's work
- being able to provide a more meaningful PR message
- having a single workspace per set of bulk changes (called a campaign in Turbolift nomenclature), whereas multiple uses of Microplane lose the context for existing sets of PRs open

Turbolift also appears to be more recently maintained, which is positive. It's a shame that GitLab support isn't available in Turbolift, but I'll definitely look at whether it's something I can contribute to work across my various repositories.

I'm looking forward to the next time I need to reach for Turbolift, as it feels like it's going to be a good "go to" tool to reach for.
