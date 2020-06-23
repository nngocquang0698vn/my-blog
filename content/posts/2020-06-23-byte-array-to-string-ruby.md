---
title: "Converting a Byte Array to a String in Ruby"
description: "How to convert an array of bytes to a String with Ruby."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-23T13:24:21+0100
slug: "byte-array-to-string-ruby"
---
In [_Converting a Byte Array to String with `Buffer` in Node.JS_]({{< ref 2020-04-20-buffer-array-to-string >}}) I mentioned about Node.JS `Buffer`s, and how they're a way to serialise an array of bytes into a JSON format.

As Ruby is my preferred scripting language, I wanted to document how to convert this back to a String with Ruby, too.

Let us assume that we have the following data:

```json
[
  104, 116, 116, 112, 115,
  58, 47, 47, 119, 119,
  119, 46, 106, 118, 116,
  46, 109, 101
]
```

We can follow [grosser's solution](https://stackoverflow.com/a/4701955/2257038) (bearing in mind [David J's comment](https://stackoverflow.com/questions/960728/ruby-create-a-string-from-bytes#comment15716059_4701955)):

```ruby
bytes = [
  104, 116, 116, 112, 115,
  58, 47, 47, 119, 119,
  119, 46, 106, 118, 116,
  46, 109, 101
]
puts bytes.pack('C*').force_encoding('UTF-8')
# 'https://www.jvt.me'
```
