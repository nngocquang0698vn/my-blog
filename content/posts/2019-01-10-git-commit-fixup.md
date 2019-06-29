---
title: "Using `git commit --fixup=` to track changes that need to be applied on top of another commit"
description: "Using `git commit --fixup=` and `git rebase --autosquash` to easily track and squash fix commits."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-10T17:07:19+00:00
slug: "git-commit-fixup"
---
When working on a non-shared feature branch or when creating an article under [the editorial workflow I use for blog posts]({{< ref 2018-09-11-blog-post-editorial-workflow >}}), I'll often make quick commits that need to be squashed into a previous commit to ensure a nice Git history.

These commits will often have a commit message such as `sq!` to denote that I need to squash into the last commit, or `sq! 3e9f73`, to denote that I need to squash into the commit that has a SHA of `3e9f73`.

Once I've finalised my cleanup, I'll then perform a `git rebase --interactive` to squash the commits in where they need to be.

However, today I found an even better way of doing this - using a mix of `git commit --fixup=` and `git rebase --autosquash`.

We can see this example below:

```
/git-commit-fixup % ls -al
total 4
drwxr-xr-x 1 jamie jamie  26 Jan 10 16:51 .
drwxr-xr-x 1 jamie jamie  40 Jan 10 16:51 ..
drwxr-xr-x 1 jamie jamie 162 Jan 10 16:51 .git
-rw-r--r-- 1 jamie jamie 463 Jan 10 16:51 README.md
/git-commit-fixup % git log
commit 5552fc0e523108bb8e6d7358b51c08a85ca10edc (HEAD -> master)
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:46 2019 +0000

    Add Lorem Ipsum

commit 47d1a2ad0e490c1dd67ed5bf5a539bb6024d706d
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:26 2019 +0000

    Initial commit
/git-commit-fixup % cat README.md
# Hello world!

LOREM ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
/git-commit-fixup % vim README.md
# downcase the initial `LOREM`
/git-commit-fixup % git add -p
diff --git a/README.md b/README.md
index 1772adb..561f6f5 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1,3 @@
 # Hello world!

-LOREM ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
 nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
 sunt in culpa qui officia deserunt mollit anim id est laborum.
+Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
 nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,
 sunt in culpa qui officia deserunt mollit anim id est laborum.
Stage this hunk [y,n,q,a,d,e,?]? y

/git-commit-fixup % git commit --fixup=5552f
[master fe46908] fixup! Add Lorem Ipsum
 1 file changed, 1 insertion(+), 1 deletion(-)
/git-commit-fixup % git log
commit fe46908af9bf319202cfad0246a0d4d76d930d8b (HEAD -> master)
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:52:09 2019 +0000

    fixup! Add Lorem Ipsum

commit 5552fc0e523108bb8e6d7358b51c08a85ca10edc
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:46 2019 +0000

    Add Lorem Ipsum

commit 47d1a2ad0e490c1dd67ed5bf5a539bb6024d706d
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:26 2019 +0000

    Initial commit
/git-commit-fixup % git rebase -i 47d1a2ad0e490c1dd67ed5bf5a539bb6024d706d --autosquash
Successfully rebased and updated refs/heads/master.
/git-commit-fixup % git log
commit e4e79389bc0761a111d9f9475b68f20fdeba0313 (HEAD -> master)
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:46 2019 +0000

    Add Lorem Ipsum

commit 47d1a2ad0e490c1dd67ed5bf5a539bb6024d706d
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Thu Jan 10 16:45:26 2019 +0000

    Initial commit

```

Or in an Asciicast:

<asciinema-player src="/casts/git-commit-fixup.json"></asciinema-player>

This is a really awesome new workflow, and makes it much, much nicer to save me having to manipulate the rebase ordering myself.

I can also see this being a useful workflow for being in the code review phase, adding `fixup!` commits to the reviewed code, slowly getting to the point where the reviewer(s) are happy, and then `autosquash`ing it all when it is ready for the final merge.
