---
title: "Getting the Battery Status of a Bluetooth Device on Linux"
description: "How to use `dbus-send` to retrieve the percentage of battery left on a Bluetooth device on Linux."
tags:
- blogumentation
- command-line
- bluetooth
- linux
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-10T21:58:48+0000
slug: "bluetooth-percent-linux"
image: https://media.jvt.me/cb4ea1ac04.jpeg
---
Today while gaming - on Windows - I was alerted that my bluetooth mouse was low on battery. I realised that I didn't have any way of keeping on top of top of it on (Arch) Linux.

It's possible using the `dbus-send` interface to ask for the battery percentage, following [this StackOverflow answer](https://stackoverflow.com/a/55008142):

```sh
mac="DA:DE:0B:1C:2B:0A"
mac="${mac//:/_}"
dbus-send --print-reply=literal --system --dest=org.bluez /org/bluez/hci0/dev_${mac} org.freedesktop.DBus.Properties.Get string:"org.bluez.Battery1" string:"Percentage"
```

Unfortunately, this doesn't work out of the box as we receive the following error:

```
Error org.freedesktop.DBus.Error.UnknownObject: Method "Get" with signature "ss" on interface "org.freedesktop.DBus.Properties" doesn't exist
```

As [noted on the Arch Wiki](https://wiki.archlinux.org/title/bluetooth_headset#Battery_level_reporting), we need to enable the experimental mode by tweaking the `bluetooth.service` configuration to:

```diff
-ExecStart=/usr/lib/bluetooth/bluetoothd
+ExecStart=/usr/lib/bluetooth/bluetoothd -E
```

After a `systemctl daemon-reload && systemctl restart bluetooth`, we can now correctly get the status of the battery, showing it's at 90%:

```
   variant       byte 90
```
