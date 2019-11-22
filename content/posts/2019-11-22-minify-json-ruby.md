---
title: "Minifying JSON Ruby"
description: "How to take a pretty-printed JSON string and replace it with a minifed JSON string using Ruby."
tags:
- ruby
- command-line
- blogumentation
- nablopomo
- json
- minify-json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-22T19:33:20+0000
slug: "minify-json-ruby"
series: nablopomo-2019
---
I've written about [pretty-printing JSON](/series/pretty-print-json) in the past, but not about minifying it. Sometimes you don't want an overly verbose format, i.e. when entering logs, or where you're restrained on file-sizes.

Let's say that we have a nicely pretty-printed JSON file, such as:

```json
{
    "key": [
        123,
        456
    ],
    "key2": "value"
}
```

If we want to minify the JSON, we can use the following:

```sh
$ ruby -rjson -e 'puts JSON.parse(ARGF.read).to_json' file.json
$ ruby -rjson -e 'puts JSON.parse(ARGF.read).to_json' < file.json
```

This then outputs it as the minified JSON string representation of the object above!

```json
{"key":[123,456],"key2":"value"}
```
