---
title: "Splitting an X509 PEM-Encoded Certificate Bundle into Multiple Files"
description: "Splitting a certificate bundle into separate files using `split` or `awk`."
tags:
- blogumentation
- command-line
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-20T23:35:26+0000
slug: "split-pem-bundle"
---
Today I was wanting to break out a large certificate bundle, containing many X509 PEM-encoded certs, into separate files. While I was thinking about scripting it myself, I realised _surely_ someone has done this before? It's a pretty standard thing for sysadmins to have done before, so resorted to searching online.

Lo and behold, I found two great solutions via [_How to split a PEM file_ on Server Fault](https://serverfault.com/questions/391396/how-to-split-a-pem-file):

Using the `split` command, which I've not tried before:

```sh
split -p "-----BEGIN CERTIFICATE-----" collection.pem individual-
```

Or using trusty `awk`:

```sh
awk '
  split_after == 1 {n++;split_after=0}
  /-----END CERTIFICATE-----/ {split_after=1}
  {print > "cert" n ".pem"}' < $file
```
