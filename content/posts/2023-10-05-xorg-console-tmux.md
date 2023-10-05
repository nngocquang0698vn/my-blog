---
title: "Solving `/usr/lib/Xorg.wrap: Only console users are allowed to run the X server` errors with tmux over SSH"
description: "How to avoid Xorg errors when connecting to a Linux machine over SSH that tries to spawn `startx`."
date: 2023-10-05T14:08:39+0100
tags:
- "blogumentation"
- "linux"
- "tmux"
- "ssh"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: xorg-console-tmux
---
On my Linux machines, I use [BSPWM](https://github.com/baskerville/bspwm) as my window manager, and instead of using a login greeter, I used to log into the TTY on startup and run:

```sh
startx
```

That got annoying, then I added the following to `~/.zlogin`:

```sh
[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 ]] && exec startx
```

This allowed me to log into TTY1 and auto-start Xorg, but any other TTY would give me a regular shell.

However, when I SSH onto the machine - usually from my laptop - and connect to a running `tmux` session, I've fairly often received the following error:

```
/usr/lib/Xorg.wrap: Only console users are allowed to run the X server
```

This stops me opening any new windows, and can be super frustrating.

Today, I finally solved it with:

```diff
-[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 ]] && exec startx
+[[ -z "$DISPLAY" && $XDG_VTNR -eq 1 && -z "$SSH_CONNECTION" ]] && exec startx
```

Which makes sure that this only affects non-SSH shells, and now no longer triggers the error 👏
