---
title: URL Decoding with Ruby on the Command Line
description: How to use Ruby's standard library to decode URLs with a handy one-liner.
categories:
- blogumentation
tags:
- blogumentation
- ruby
- cli
date: 2019-05-31T21:58:11+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: url-decode-ruby-cli
---
When working with URLs that contain other URLs (such as a `redirect_uri` in an OAuth2 authorization request), you may get annoyed when you can't decode the encoded URL, **??**.

Following the advice from [this Stack Overflow answer](https://stackoverflow.com/a/7146153/2257038), we can use `CGI.unescape`, and create a nice command-line one-liner:

```sh
ruby -rcgi -e 'puts CGI.unescape(ARGF.read)'
```

This lets us i.e. run:

```sh
$ echo 'https%3A%2F%2Fwww.jvt.me' | ruby -rcgi -e 'puts CGI.unescape(ARGF.read)'
https://www.jvt.me
```
