---
title: "Safely Force Pushing with Git using `--force-with-lease=ref`"
description: "How `git push --force-with-lease=ref` can save you from overriding others' changes on shared Git branches."
tags:
- git
- blogumentation
- cli
image: /img/vendor/git.png
date: 2018-09-18T17:08:32+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: safely-force-git-push
---
There are times where you just _have_ to `git push --force`, such as, but not limited to, cleaning up your Git history on a branch ahead of a merge. But `git push --force` is super dangerous because it will wipe out whatever is on the branch _at the point you push_, so one solution is to just tell people not to push to the branch.

This isn't great UX, so Git added a lesser-known flag to `git push` which makes it slightly safer to force push to a shared branch.

# Setup

Let us assume we have one shared repository called `upstream`, onto which we have a shared feature branch `update` which we are committing to:

```
workspace $ cd upstream
upstream $ git log -p
commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

We also have two other repositories, which have made separate commits on top of their shared initial commit. The first copy of the repo, `copy-0`:

```
workspace $ cd copy-0
copy-0 $ git log -p
commit a628fd25faa8762dccd65833ba774ebbd0db7b8a
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:31:43 2018 +0100

    Update

diff --git a/file b/file
index ce01362..83cdac0 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-hello
+hello new

commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

And the second repo, `copy-1`:

```
workspace $ cd copy-1
copy-1 $ git log -p
commit bbfdc06bdc94e0773766adaf9ac95a6a7c9063d2
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:31:59 2018 +0100

    Don't overwrite!

diff --git a/file b/file
index ce01362..4b2ecd5 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-hello
+important hello to new client

commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

We want to have our `copy-1` push first to our `upstream`, resulting in:

```
workspace $ cd copy-1
copy-1 $ git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 278 bytes | 278.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To ../workspace/upstream
   02de8c9..bbfdc06  update -> update
workspace $ cd upstream
commit bbfdc06bdc94e0773766adaf9ac95a6a7c9063d2
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:31:59 2018 +0100

    Don't overwrite!

diff --git a/file b/file
index ce01362..4b2ecd5 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-hello
+important hello to new client

commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

Great, this has set up the case where there has been some divergence between `copy-0` and the `upstream`.

# Without `--force-with-lease`

If we push with `--force`, but _not_ `--force-with-lease`:

```
workspace $ cd copy-0
copy-0 $ git push --force
To ../workspace/upstream
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 4 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (6/6), 429 bytes | 429.00 KiB/s, done.
Total 6 (delta 0), reused 0 (delta 0)
To ../workspace/upstream
 + bbfdc06...a628fd2 update -> update (forced update)
```

We will see that by the `forced update` message, our local changes in copy-0 have overriden the important changes that `copy-1` had pushed, oops!

```
workspace $ cd upstream
upstream $ git log -p
commit a628fd25faa8762dccd65833ba774ebbd0db7b8a
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:31:43 2018 +0100

    Update

diff --git a/file b/file
index ce01362..83cdac0 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-hello
+hello new

commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

# With `--force-with-lease`

However, if we now push with `--force` _and_ `--force-with-lease`:

```
workspace $ cd copy-0
copy-0 $ git push --force-with-lease
To ../workspace/upstream
 ! [rejected]        update -> update (stale info)
error: failed to push some refs to '../workspace/upstream'
copy-0 $ git push --force --force-with-lease
```

We can see that the changes haven't been pushed to the remote, saving us some very angry people.

```
workspace $ cd upstream
upstream $ git log -p
commit bbfdc06bdc94e0773766adaf9ac95a6a7c9063d2
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:31:59 2018 +0100

    Don't overwrite!

diff --git a/file b/file
index ce01362..4b2ecd5 100644
--- a/file
+++ b/file
@@ -1 +1 @@
-hello
+important hello to new client

commit 02de8c9af0eaf0328ab327b5f01fbbb73f76fd0c
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 17 20:30:49 2018 +0100

    Initial commit

diff --git a/file b/file
new file mode 100644
index 0000000..ce01362
--- /dev/null
+++ b/file
@@ -0,0 +1 @@
+hello
```

# Caveats

Unfortunately, this is a little too good to be true. As called out by the [Stack Overflow question] around it, it seems that if at any point you've refreshed your Git references with a `git fetch` or a `git pull`, you'll won't be safe:

```
copy-0 $ git fetch
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From ../workspace/upstream
 + a628fd2...bbfdc06 master     -> origin/master  (forced update)
copy-0 $ gp --force-with-lease
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 245 bytes | 245.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To ../workspace/upstream
 + bbfdc06...a628fd2 master -> master (forced update)
```

This must be avoided by specifying the Git ref that we want to specify as our most recent. This ensures the push wouldn't overwrite the remote changes as they wouldn't be contained in the history of the branch that `HEAD` currently points to:

```
copy-0 $ git push --force-with-lease=HEAD
To ../workspace/upstream
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to '../workspace/upstream'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Note that the ref could be one of many Git refs, such as the branch name.

# How does it all work?

So how does this work? When using the 'lease', Git negotiates with the remote to determine whether its local set of refs are aligned with the refs of the branch the local client is pushing to - if these are different, we're told we have "stale info", otherwise we'll be able to push normally.

[Stack Overflow question]: https://stackoverflow.com/a/43726130
