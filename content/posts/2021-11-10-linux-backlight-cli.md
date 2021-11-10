---
title: "Controlling the Linux Backlight via the Command-Line"
description: "How to manage your screen backlight on the command-line, without installing any tools."
date: 2021-11-10T19:15:41+0000
tags:
- blogumentation
- command-line
- linux
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "linux-backlight-cli"
---
Let's say that you've just installed your laptop, and you've forgotten to install `xbacklight` to manage your backlight settings, or you do have it, and it's randomly stopped working.

Fortunately on Linux, `sysfs` allows you to interact with the backlight system, just by writing to "files" on disk, nothing else needed!

First, you'll need to check which devices are available. For instance:

```sh
ls -l /sys/class/backlight/
# on my laptop:
total 0
lrwxrwxrwx 1 root root 0 Nov 10 12:08 intel_backlight -> ../../devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight
```

Next, we can check what it's currently set to:

```sh
cat /sys/class/backlight/intel_backlight/brightness
```

And to check the maximum available for the device:

```sh
cat /sys/class/backlight/intel_backlight/max_brightness
```

And then if we want to control the brightness, we can write to the `brightness` file with the brightness value we want to set it to:

```sh
echo 200 | sudo tee /sys/class/backlight/intel_backlight/brightness
```
