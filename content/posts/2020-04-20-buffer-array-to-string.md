---
title: "Converting a Byte Array to String with `Buffer` in Node.JS"
description: "How to convert an array of bytes to a String using Node.JS's `Buffer` class."
tags:
- blogumentation
- nodejs
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-20T16:51:10+0100
slug: "buffer-array-to-string"
image: /img/vendor/nodejs.png
---
If you're working with Node.JS, you may have encountered [`Buffer`s](https://nodejs.org/api/buffer.html) which are a way to store binary data as a sequence of its bytes.

But what happens when you have serialised it, and you want to convert it back to a String?

Let us assume that we have the following data:

```json
[
  104, 116, 116, 112, 115,
  58, 47, 47, 119, 119,
  119, 46, 106, 118, 116,
  46, 109, 101
]
```

We can use [`Buffer.from`](https://nodejs.org/api/buffer.html#buffer_class_method_buffer_from_array) to read in the bytes, and then return it as a String:

```js
const bytes = [
  104, 116, 116, 112, 115,
  58, 47, 47, 119, 119,
  119, 46, 106, 118, 116,
  46, 109, 101
];
console.log(new Buffer.from(bytes).toString());
// 'https://www.jvt.me'
```
