---
title: "GitLab CI Shell Executor Failing Builds With `No Such Directory`"
description: "How to work around `No Such Directory` errors with GitLab CI's shell executor."
tags:
- blogumentation
- gitlab-ci
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-03T21:13:41+0100
slug: "gitlab-ci-shell-no-such-directory"
image: /img/vendor/gitlab-wordmark.png
---
Tonight I've been playing around with GitLab CI's `shell` executor, and my builds have been failing with this error:

```
Running with gitlab-runner 13.0.1 (21cb397c)
  on gitlab-runner 9vpTPhFS
Preparing the "shell" executor
00:00
Using Shell executor...
Preparing environment
00:00
Running on gitlab-runner...
Uploading artifacts for failed job
00:00
bash: line 92: cd: /home/gitlab-runner/builds/9vpTPhFS/0/jamietanna/jvt.me: No such file or directory
ERROR: Job failed: exit status 1
```

This is odd, because the path `/home/gitlab-runner/builds/9vpTPhFS/0/jamietanna/jvt.me.tmp` existed, just not without the `.tmp` suffix.

After some searching online, [this comment](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/1379#note_343017515) noted that it's an issue with SKEL - the solution was to delete `.bash_logout` from the `gitlab-runner` user's home, but I also removed `.bashrc` and `.profile`.
