---
title: "Resolving black screen display with SDDM and NVIDIA GPUs"
description: "How I resolved an issue with a black screen displaying when SDDM is used with an NVIDIA driver."
tags:
- blogumentation
- linux
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-08-14T15:41:22+0100
slug: sddm-nouveau
---
Today I'm setting up [SDDM](https://wiki.archlinux.org/title/SDDM) on my new work laptop, and I was encountering an issue where SDDM was presenting a black screen when starting up, which then couldn't be interacted with.

(I've [since realised](https://www.jvt.me/mf2/2023/08/qbtty/) that this wasn't necessary)

After coming across [this thread on the Arch forums](https://bbs.archlinux.org/viewtopic.php?id=270564) this highlighted that it may be an issue with the display drivers.

Although the thread 👆 indicated that this may be an issue with the NVIDIA proprietary drivers, I knew I wasn't using them as I'd not specifically set them up.

It turns out this _was_ still an issue with the NVIDIA GPU, just using the Open Source `nouveau` drivers, of which we needed to [enable early Kernel Mode Setting](https://wiki.archlinux.org/title/nouveau#Enable_early_KMS) by adding the following to my `/etc/mkinitcpio.conf`:

```sh
MODULES=(nouveau)
```
