---
title: "Using systemd-tmpfiles to manage temporary files and directories"
description: "How I'm using systemd-tmpfiles to manage a temporary working directory and automagically clean it out."
tags:
- blogumentation
- systemd
- linux
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-08T18:15:28+0000
slug: "systemd-temporary-directory"
---
Over the last few years I've found that I needed to have a more structured directory hierarchy for my personal and professional projects, under the `~/workspaces` directory.

This, in conjunction with a `wksp` shell function to easily move around, has been beneficial and allows me to structure things in terms of:

```
adventofcode
cv
cucumber
        /common
        /cucumber-jvm
hacktoberfest
jvt.me
tmp
```

However, there are cases where I don't want to create a persistent workspace in this hierarchy, for instance a drive-by Open Source contribution. Because it was for temporary usage, I'd call it `tmp` and every so often clean it out.

[In 2016](https://gitlab.com/jamietanna/dotfiles-arch/-/commit/fc72beebd0aab38172b2b3bf29a9140762c5e193), I discovered [`systemd-tmpfiles(8)`](https://www.man7.org/linux/man-pages/man8/systemd-tmpfiles.8.html) which can manage this automated clean up for us, as well as doing a lot of other powerful stuff like creating temporary files, BTRFS volumes, pipes, symlinks, or copy files around, which can be found documented in [`tmpfiles.d(5)`](https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html).

The configuration I've got makes sure that it creates the directory, sets permissions to just my user, and clear files out after a week of existing:

```
D	/home/jamie/workspaces/tmp	0700	jamie	jamie	1w	-
```

Something I have noticed is that this gets cleared every time I boot - which is fine, because I'm happy treating it as a scratch space - but it's likely that I need to turn the `D` to a `d`.

Update 2021-12-13: I've since changed it to a `d` and the files persist across reboots, and are deleted after a week of being present - awesome!

Having a "scratch" space to work is really useful, and it's even better when it's truly ephemeral and you don't need to worry about cleaning it out, or that others may be able to see what you're doing, as is possible if using `/tmp` on a shared system.
