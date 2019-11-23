---
title: "Minifying JSON with Python"
description: "How to take a pretty-printed JSON string and replace it with a minifed JSON string using Python."
tags:
- python
- command-line
- blogumentation
- nablopomo
- json
- minify-json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-23T19:58:07+0000
slug: "minify-json-python"
series: nablopomo-2019
---
Yesterday I wrote about [_Minifying JSON Ruby_]({{< ref "2019-11-22-minify-json-ruby" >}}), but today let's talk about using Python instead.

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

If we want to minify the JSON, we can use the following one-liner:

```bash
python -c $'import json\nimport sys\nwith open(sys.argv[1], "r") as f: print(json.dumps(json.load(f)))' file.json
```

This then outputs it as the minified JSON string representation of the object above!

```json
{"key": [124, 456], "key2": "value"}
```
