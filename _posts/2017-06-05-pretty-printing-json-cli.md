---
layout: post
title: Pretty Printing JSON on the Command Line with Python
description: Using Python's JSON module to pretty print JSON objects from the command line.
categories: findings
tags: findings python json
---
On modern GNU/Linux systems, there will usually be an install of a minimal Python version, due to a number of system tools requiring it.

Because of this, it means that you will often have the chance to be able to leverage it to use the lesser-known command `python -m json.tool` in ordert

Given the following minified JSON file that we want to be able to inspect:

```json
{"key":[123,456],"key2":"value"}
```

Let's use the following pipeline to output it:

```bash
$ cat file.json | python -m json.tool
#                        ^ invoke a specific library from Python
#                           ^ within the JSON library
#                                ^ call the tool module
# ^ useless use of cat, use recommended pipeline instead
$ python -m json.tool < file.json
```

The `json.tool` module, if given input on `stdin`, returns to `stdout` the pretty output of a given JSON object.

To see this article in action, check out the asciicast:

[![asciicast](https://asciinema.org/a/akbug6abp2mi6mpxypuc9ilzn.png)](https://asciinema.org/a/akbug6abp2mi6mpxypuc9ilzn)
