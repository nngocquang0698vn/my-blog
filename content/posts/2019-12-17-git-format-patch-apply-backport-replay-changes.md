---
title: "Backporting/Replaying Changes using `git format-patch` and `git apply`"
description: "Using `git format-patch` and `git apply` to apply a patch, if `git cherry-pick` isn't available."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-17T21:33:54+0000
slug: "git-format-patch-apply-backport-replay-changes"
image: /img/vendor/git.png
---
Today I was working on a number of different Git repos that needed exactly the same changes applied to them, including their commit message.

Because it was using a completely different Git repo, I couldn't use [`git cherry-pick`]({{< ref "2018-10-28-git-cherry-pick-backport-replay-changes" >}}) to do this, so needed some way to apply the patch some way.

Luckily this works quite nicely with Git because one of the largest workflows within Git is sending patches via email.

We can utilise this approach to generate a patch:

```
$ git format-patch -1 --stdout HEAD > patch
```

Which generates the following file:

```
From 22cbe446a91ff0d63f7a7df9e794d878d7a5c340 Mon Sep 17 00:00:00 2001
From: Jamie Tanna <gitlab@jamietanna.co.uk>
Date: Tue, 17 Dec 2019 19:53:29 +0000
Subject: [PATCH] MP: Add notes 2019/12/ninpe

---
 content/mf2/2019/12/ninpe.md | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 content/mf2/2019/12/ninpe.md

diff --git a/content/mf2/2019/12/ninpe.md b/content/mf2/2019/12/ninpe.md
new file mode 100644
index 00000000..74b851a3
--- /dev/null
+++ b/content/mf2/2019/12/ninpe.md
@@ -0,0 +1,15 @@
+{
+  "kind" : "notes",
+  "slug" : "2019/12/ninpe",
+  "client_id" : "https://indigenous.realize.be",
+  "date" : "2019-12-17T19:53:00Z",
+  "h" : "h-entry",
+  "properties" : {
+    "published" : [ "2019-12-17T19:53:00Z" ],
+    "content" : [ {
+      "html" : "",
+      "value" : "For anyone having issues not seeing #MrRobot Season 4 Episode 11 in their Fire TV / Prime video account, try skipping through Ep 10 until it autoplays 11"
+    } ],
+    "syndication" : [ "https://brid.gy/publish/twitter" ]
+  }
+}
--
2.24.0
```

And then we can then feed this file into `git apply`:

```sh
$ git apply < patch
```

This _may_ have issues if the patch doesn't apply cleanly, but once resolved, you'll have the commit applied with patch and commit message!
