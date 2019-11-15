---
title: "Creating a Global `.gitignore`"
description: "How to have Git have a list of files to globally ignore, without configuring anything in your `~/.gitconfig`."
tags:
- blogumentation
- git
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-15T00:31:22+0000
slug: "global-gitignore"
image: /img/vendor/git.png
---
For quite some time, my Git config has had the following entry:

```ini
[core]
	excludesfile = /home/jamie/.gitignore_global
```

This allows me to globally set patterns that I don't want to see anywhere, ever, such as [my git worktrees]({{< ref "2019-01-29-git-worktree-multiple-branches" >}}).

But it turns out that Git actually has a default location for your `gitignore`s, located in `~/.config/git/ignore`, which means you don't even need that configuration to be set!

Thanks to [/u/toupeira](https://www.reddit.com/user/toupeira/) for [sharing the tip on reddit]( https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/f0y4xgr/).
