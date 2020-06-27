---
title: "Generating Random Bytes On the Command Line with OpenSSL"
description: "How to generate random bytes as binary, base64 or hex, using `openssl` on the command-line."
tags:
- blogumentation
- openssl
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-27T14:50:35+0100
slug: "generating-random-bytes-openssl-cli"
---
I've recently needed to generate an AES encryption key for a new project I've been working on.

I needed to generate a specific number of bytes, and fortunately the OpenSSL CLI came to the rescue with [`openssl rand`](https://www.openssl.org/docs/man1.0.2/man1/rand.html):

```sh
# raw bytes
openssl rand 32
# as base64
openssl rand -base64 32
# as a hex representation
openssl rand -hex 32
```
