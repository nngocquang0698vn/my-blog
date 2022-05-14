---
title: "Constructing a serialised YAML string in Ruby"
description: "How to convert a YAML document to a string representation, preserving\
  \ escaped newlines, with Ruby."
date: "2022-05-13T18:19:03+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1525264685767053313"
tags:
- "blogumentation"
- "command-line"
- "ruby"
- "yaml"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "yaml-string"
---
Sometimes you want to convert a YAML document to an encoded format that can then i.e. be base64-encoded, or stored in another form.

I fought against this the other day and it took me a bit of work to work out that we can write the following CLI Ruby incantation to give us what we need:

```sh
ruby -ryaml -e 'p YAML.load(ARGF.read).to_yaml' < a.yml
# outputs:
# "---\ninfo:\n  version: 1.2.3\n"
```
