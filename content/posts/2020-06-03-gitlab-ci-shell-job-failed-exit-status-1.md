---
title: "GitLab CI Shell Executor failing builds with `ERROR: Job failed: exit status 1`"
description: "How to work around `ERROR: Job failed: exit status 1` errors with GitLab CI's shell executor."
tags:
- blogumentation
- gitlab-ci
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-03T21:13:41+0100
slug: "gitlab-ci-shell-job-failed-exit-status-1"
image: /img/vendor/gitlab-wordmark.png
---
Tonight I've been playing around with GitLab CI's `shell` executor, and my builds have been failing with this error:

````
Running with gitlab-runner 13.0.1 (21cb397c)
  on gitlab-runner 9vpTPhFS
Preparing the "shell" executor
00:00
Using Shell executor...
Preparing environment
00:01
Running on gitlab-runner...
Uploading artifacts for failed job
00:00
ERROR: Job failed: exit status 1
````

After some searching online, it appeared that similar to [when receiving `No Such Directory`]({{< ref 2020-06-03-gitlab-ci-shell-no-such-directory >}}), [this comment](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/1379#note_343017515) noted that it's an issue with SKEL - the solution was to delete `.bash_logout` from the `gitlab-runner` user's home, but I also removed `.bashrc` and `.profile`.
