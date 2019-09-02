---
title: "Adding Newlines to all Files in Git"
description: "Adding newlines at the end of all Git-tracked files."
tags:
- git
- shell
- cli
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-02T22:35:40+01:00
slug: "newlines-all-git-files"
image: /img/vendor/git.png
---
One of my pet peeves in code review is seeing a file added which does not end with a newline.

Why is this so annoying? Because as soon as that file is tracked without a newline, it then risks the diff being a bit noise in the future. Extra noise makes code review harder to action and adds unnecessary burden on a reviewer.

The issue is that if someone were to edit that file in the future, and their editor added a newline at the end of the file, we'd have a larger diff to read than is necessary.

For instance, let's say we have this initial commit:

```diff
commit e5e8b631c19958abfbcf1f96ae8fdcc18e3e2c54
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 2 22:23:52 2019 +0100

    Add file

diff --git a/file b/file
new file mode 100644
index 0000000..f28cd49
--- /dev/null
+++ b/file
@@ -0,0 +1,5 @@
+Lorem ipsum dolor sit amet
+ consectetur adipisicing elit
+ sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam
+ quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
+ sunt in culpa qui officia deserunt mollit anim id est laborum.
\ No newline at end of file
```

If another developer comes along and updates the file, then we see the following change in the diff:

```diff
commit d9a5bdf1b37e714692146e90ab03c44fb236741e
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Mon Sep 2 22:28:22 2019 +0100

    Make a change to a line

diff --git a/file b/file
index f28cd49..0d32142 100644
--- a/file
+++ b/file
@@ -1,5 +1,5 @@
 Lorem ipsum dolor sit amet
- consectetur adipisicing elit
+ consectetur adipisicing elit something Latin
  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam
  quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
- sunt in culpa qui officia deserunt mollit anim id est laborum.
\ No newline at end of file
+ sunt in culpa qui officia deserunt mollit anim id est laborum.
```

We can see that there are two lines "changed" here, but really only one is of any value.

So how do we get around this? I'd recommend following the [handy one-liner that Pactrick Oscity on Stack Overflow](https://unix.stackexchange.com/a/161853), we can clear them out:

```sh
git ls-files -z | while IFS= read -rd '' f; do tail -c1 < "$f" | read -r _ || echo >> "$f"; done
```

I'd recommend doing this once, cleaning them all up in a single commit, and then making sure that there's something automated in your project's linting to pick up on this, so folks can't accidentally commit them as it'll break the build.
