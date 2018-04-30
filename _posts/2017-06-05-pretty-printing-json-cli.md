---
layout: post
title: Pretty Printing JSON on the Command Line with Python
description: Using Python's JSON module to pretty print JSON objects from the command line.
categories: blogumentation
tags: blogumentation python json
no_toc: true
---
You may often find yourself on a command-line, for instance when SSH'd into a server, and need to read some JSON. This could be a JSON configuration file, or indeed it could be simply a response from an API endpoint.

Either way, the JSON you're getting back isn't quite as nicely formatted as you'd hoped. You think about manually going through and editing it to clean it up, but want to know if there's a better way.

On modern GNU/Linux systems, there will usually be a minimal install of Python, as a number of system tools have a dependency on it. Within this minimal install, there should be the `json` python.

This library has a module (a file within a library, in Python speak) called `tool`, which has the ability to take a JSON file (or input from `stdin`) and output the corresponding pretty-printed JSON.

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
# ^ useless use of cat, use recommended pipeline below instead:
$ python -m json.tool < file.json
{
    "key": [
        123,
        456
    ],
    "key2": "value"
}
```

To see this article in action, check out the asciicast:

[![asciicast](https://asciinema.org/a/akbug6abp2mi6mpxypuc9ilzn.png)](https://asciinema.org/a/akbug6abp2mi6mpxypuc9ilzn)
