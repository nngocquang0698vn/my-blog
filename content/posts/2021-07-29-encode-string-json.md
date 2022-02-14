---
title: "Encoding Strings for Embedding in JSON with Ruby on the Command-Line"
description: "How to easily convert a string to a format that can be used as a value for JSON strings."
tags:
- blogumentation
- json
- ruby
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-07-29T22:36:17+0100
slug: "encode-string-json"
image: https://media.jvt.me/00fdea0d32.png
---
One of the difficult things about working with JSON, especially when it is used as a format for storing content, such as when working with the [Microformats2 standard](https://microformats.io/).

Because I was finding it quite difficult to hand-craft a string that correctly escaped quotes, newlines, etc, I crafted the following one-liner with Ruby:

```sh
echo "A string" | ruby -e 'p ARGF.read'
ruby -e 'p ARGF.read' < file.txt
```
