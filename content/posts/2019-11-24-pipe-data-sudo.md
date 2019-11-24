---
title: "Piping Data When Not Running a Command with `sudo`"
description: "How to (more) safely pipe `stdin` to an elevated command with `sudo tee`."
tags:
- blogumentation
- command-line
- nablopomo
- security
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-24T20:12:25+0000
slug: "pipe-data-sudo"
series: nablopomo-2019
---
From a security standpoint, you should avoid running everything with `sudo`, as it increases the risk of you [accidentally wiping your machine](https://www.theregister.co.uk/2015/01/17/scary_code_of_the_week_steam_cleans_linux_pcs/), or a malicious script compromising your machine.

But this can be a real pain, for instance if you need to write to protected file(s).

The solution here is to use the [`tee`](https://linux.die.net/man/1/tee) command, and make sure that only `tee` is run as `root`. A huge benefit of using `tee`, too, is that it'll render the output both to the file specified, and to `stdout`, so you have a chance to see if there's anything suspicious being output.

For instance, I used to run this setup to set up my Arch Linux package mirrors:

```bash
curl -s 'https://www.archlinux.org/mirrorlist/?country=GB&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' \
       | sed 's/^#//' \
       | sudo tee /etc/pacman.d/mirrorlist
```

This means that only the very end of the command is run as root, so any other remote code executions are less likely to cause massive damage to the system.
