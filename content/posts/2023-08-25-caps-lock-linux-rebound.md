---
title: "Turning on Caps Lock when the Caps Lock key is bound to a different key"
description: "How to trigger a Caps Lock event when you've rebound the key to a differnet key."
date: 2023-08-25T10:12:37+0100
tags:
- blogumentation
- linux
- command-line
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: caps-lock-linux-rebound
---
As a Vim user, and as someone who doesn't use <kbd>CapsLock</kbd> very often, I've had my <kbd>CapsLock</kbd> key rebound to <kbd>ESC</kbd>  for the last 7(!) years.

In the last week I've had a couple of times where my new work laptop's lost the configuration, and I've accidentally hit <kbd>CapsLock</kbd> which has then actually set Caps Lock instead of triggering <kbd>ESC</kbd>. I've generally then reset my keybindings before noticing that I've got Caps Lock turned, on, which has led to me being unable to turn it off, or even type in my terminal to unset it.

This has been a little bit embarrassing, so when it's just happened to me right now, I was very happy to find, via [this AskUbuntu answer](https://askubuntu.com/a/607915), that we can use `xdotool` to trigger the event:

```sh
# Note the capitals
xdotool key Caps_Lock
```

This is great because it surprisingly doesn't get picked up by any rebinding, and will correctly (un)set Caps Lock.

Another [clever commenter](https://askubuntu.com/questions/80254/how-do-i-turn-off-caps-lock-the-lock-not-the-key-by-command-line#comment1635018_607915) suggested something I'd rarely have considered - use the <kbd>Shift</kbd> key while in Caps Lock to return to normal casing.
