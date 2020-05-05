---
title: "Determining What Motherboard You're Using, On Linux"
description: "How to determine what motherboard the machine you're using is reporting, on the command-line with Linux."
tags:
- blogumentation
- command-line
- linux
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-05T08:38:01+0100
slug: "determine-motherboard-linux"
---
It's been a couple of years since I rebuilt my desktop, and since then, I've largely forgotten what hardware is in my machine.

So about a month ago, when I was adding some new hardware, I realised I couldn't remember what I was using. I thought "surely there's a better way than trawling through emails", and lo and behold, [_How do I find out my motherboard model?_ on AskUbuntu](https://askubuntu.com/a/578374), which has a handy root and non-root variant.

However, as a caveat, this likely will not be accurate depending on if you are running in a Virtual Machine, i.e. on shared hosting.

# Without Root Access

By running the following command:

```sh
$ cat /sys/devices/virtual/dmi/id/board_{vendor,name,version}
ASUSTeK COMPUTER INC.
X99-A II
Rev 1.xx
```

Which should be good enough for what you need!

# With Root Access

If you have root access, there is the `dmidecode` command that can provide much better information, such as:

```sh
$ sudo dmidecode -t 1
# dmidecode 3.2
Getting SMBIOS data from sysfs.
SMBIOS 3.0.0 present.

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: ASUS
	Product Name: All Series
	Version: System Version
	Serial Number: System Serial Number
	UUID: bdcbd580-c021-11d3-9c5b-3497f6dc8eb8
	Wake-up Type: PCI PME#
	SKU Number: All
	Family: ASUS MB
```
