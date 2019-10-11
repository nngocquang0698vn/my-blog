---
title: "Getting `git diff` Outputs Without a Prefix"
description: "How to remove `a/` and `b/` from `git diff` outputs."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-11T19:39:24+0100
slug: "git-diff-no-prefix"
image: /img/vendor/git.png
---
Something that has been a pain in my side for quite some time, but I've never thought to find out if there's a fix for, is Git adding a prefix to files when running `git diff`:

```diff
diff --git a/permalinks.yml b/permalinks.yml
index 37cbcd46..2fd826be 100644
--- a/permalinks.yml
+++ b/permalinks.yml
@@ -1,5 +1,6 @@
 ---
 posts:
+- https://www.jvt.me/posts/2019/10/11/git-diff-no-prefix/
 - https://www.jvt.me/posts/2019/10/07/new-team/
 - https://www.jvt.me/posts/2019/10/06/netlify-slow-deploy/
 - https://www.jvt.me/posts/2019/10/05/panic-attacks/
```

I fairly often work with this output, then copy-paste the filename to then i.e. edit the file. However, as per the above output, the presence of `a/` and `b/` are always annoying because I have to remove them.

Well, no more, as the following tweet shares:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Git tip I wish I&#39;d discovered ten years ago: if you `git config --global diff.noprefix true` it removes the silly `a/` and `b/` prefixes so that when you double-click select one to copy, you get a usable filename instead of a mangled path. <a href="https://t.co/8COLkcClv6">pic.twitter.com/8COLkcClv6</a></p>&mdash; Brandur (@brandur) <a href="https://twitter.com/brandur/status/1182066723337293828?ref_src=twsrc%5Etfw">October 9, 2019</a></blockquote>

By running `git config --global diff.noprefix true`, or adding the below to `~/.gitconfig`:

```ini
[diff]
	noprefix = true
```

We now have diffs with the following output:

```diff
diff --git permalinks.yml permalinks.yml
index 37cbcd46..2fd826be 100644
--- permalinks.yml
+++ permalinks.yml
@@ -1,5 +1,6 @@
 ---
 posts:
+- https://www.jvt.me/posts/2019/10/11/git-diff-no-prefix/
 - https://www.jvt.me/posts/2019/10/07/new-team/
 - https://www.jvt.me/posts/2019/10/06/netlify-slow-deploy/
 - https://www.jvt.me/posts/2019/10/05/panic-attacks/
```

Which has no prefix - awesome!
