---
title: "Removing 'smart' quotes from a file, on the command-line"
description: "A one-liner with `sed` to replace 'smart' quotes with regular quotes."
date: 2022-04-28T13:57:44+0100
syndication:
- "https://brid.gy/publish/twitter"
tags:
- blogumentation
- command-line
- mac
- linux
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "cli-remove-smartquotes"
---
I dislike smart quotes. They are harder to write, personally don't provide me any value, and can ruin someone's day when interacting with technical documentation.

Let's say we take the code snippet:

```sh
git commit -m "Publish blog post"
```

If you convert this to smart quotes, you get the following change:

```diff
-git commit -m "Publish blog post"
+git commit -m “Publish blog post“
```

This is done in a few places - I've had it happen to me in Slack, but it also persists across things like Google Docs, and other platforms, as well as on folks' blog posts.

The problem here is that if you copy-paste this command, you'll end up with:

```
$ git commit -m “Publish blog post“
error: pathspec 'blog' did not match any file(s) known to git
error: pathspec 'post“' did not match any file(s) known to git
```

Notice how the quotes are not interpreted as quotes, but a raw character?

It can also result in partially executed commands which _could_ be destructive.

So how do we remove them? A straightforward solution that works for Linux, or for Mac, is the following shell script:

```sh
# Linux
sed -i -E "s/‘|’/'/g;s/“|”/\"/g" /path/to/file
# Mac
sed -I '' -E "s/‘|’/'/g;s/“|”/\"/g" /path/to/file
```

I've not yet written a POSIX-compliant solution, but will do at some point.
