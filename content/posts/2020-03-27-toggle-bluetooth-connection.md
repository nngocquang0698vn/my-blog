---
title: "Toggling Your Bluetooth Connection using `bluetoothctl` on the Command-Line"
description: "How to script `bluetoothctl` to toggle your connection to a Bluetooth device."
tags:
- blogumentation
- command-line
- bluetoothctl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-27T09:11:29+0000
slug: "toggle-bluetooth-connection"
---
Since getting a pair of Bluetooth headphones, I've been thoroughly enjoying being able to be hands-free.

However, one thing that's annoyed me is that to switch between my desktop (where I play my music on) and my work laptop (for Zoom calls), which requires either clicking around in UIs, or running a couple of invocations of command-line, none of which is useful if I need to quickly switch between them.

Unfortunately within `bluetoothctl`, there's no way to determine if the controller is connected to _any_ device, but given we know the MAC address for the device, we can use the `info` subcommand and determine if it's connected:

```sh
#!/usr/bin/env bash
device="38:18:4C:BF:46:FE"

if bluetoothctl info "$device" | grep 'Connected: yes' -q; then
  bluetoothctl disconnect "$device"
else
  bluetoothctl connect "$device"
fi
```

This will now toggle the connection of the device.
