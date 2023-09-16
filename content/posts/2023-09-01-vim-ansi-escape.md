---
title: "Removing ANSI escape codes in Vim"
description: "How to remove ANSI escape codes in (Neo)Vim."
tags:
- blogumentation
- vim
- neovim
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-09-01T14:01:58+0100
slug: vim-ansi-escape
image: https://media.jvt.me/efa7085abe.jpeg
---
Sometimes you'll be working with tools that may end up (accidentally) writing ANSI escape codes to the console, and these can be captured by tools like `tee` and then end up in a file.

```
^[[00;32mSuccessful deployment^[[0m
\033[00;32mhuzzah, the thing has been done!\033[0m
```

I generally hand write this as the below:

```vim
:%s/^[[[0-9]*;[0-9]*m//g
# NOTE that the ^[ here is the _literal_ escape character so you need to actually do
# <C-V><Esc> instead of ^[
:%s/^[[[0-9]*m//g
```

However, as noted above, this is a bit awkward as it requires the escaping of the escape character so can't be saved in a command easily, or copy, pasted.

We can instead take inspiration from [this StackOverflow](https://superuser.com/a/380778) and craft the following, which uses the character set that this belongs to:

```vim
# for the first pattern, with a literal escape
:%s/[\x1B]\[[0-9;]*m//g
# for the second pattern, without an escape
:%s/\\033\[[0-9;]*m//g
```
