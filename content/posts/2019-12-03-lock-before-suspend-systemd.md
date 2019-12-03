---
title: "Locking Your Machine Before Suspending Using systemd"
description: "How to get systemd to automagically lock your machine before it suspends."
tags:
- blogumentation
- linux
- systemd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-03T23:02:39+0000
slug: "lock-before-suspend-systemd"
---
If you're running Linux with a Desktop Environment such as KDE or Gnome, you'll get things like automagic screen locking / screensavers out-of-the-box.

But as someone who runs a more lightweight Window Manger, I have to manage this myself.

In the past I've made sure that when triggering a suspend I first trigger my lockscreen, but that was a bit cumbersome, especially when I found that systemd could do this for me.

For instance, I have the file `/etc/systemd/system/i3lock.service`:

```ini
[Unit]
Description=Lock the screen with i3lock
# Ensure that we run this service before the machine can actually go to sleep
Before=sleep.target

[Service]
User=jamie
# Because the i3lock process blocks while it's running, this needs to be
# `forking`, otherwise systemd would never supsend while `i3lock` is running
Type=forking
# There's usually only one interactive Xorg session running, so it's almost
# certainly going to be the 0th display
Environment=DISPLAY=:0
# /home/jamie/.currbg is the location of whatever my current background photo
# is, as I like having an image background for i3lock
ExecStart=/usr/bin/i3lock -i /home/jamie/.currbg

[Install]
# Ensure that this is called when we're trying to suspend the machine
WantedBy=suspend.target
```

Once I've told systemd to enable this service by default (by running `sudo systemctl enable i3lock.service` as a one-time thing), systemd then knows that it needs to run this command before the machine can go to sleep.

This makes things super easy, as now I can suspend by simply running `systemctl suspend`, or using a handy key combination to do the same, and it automagically locks my machine.
