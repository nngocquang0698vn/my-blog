---
title: "Pretty Printing YAML with the Ruby Command-Line"
description: "Using Ruby's `YAML` library to pretty-print YAML files from the command-line."
tags:
- nablopomo
- blogumentation
- ruby
- yaml
- pretty-print
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-27T18:15:42+0000
slug: "pretty-print-yaml-ruby"
series: pretty-print-yaml
---
Today I had a pretty fun little thing to do - validate that a YAML file was well formed (because it turns out, it wasn't).

I wanted a handy one-liner to confirm it, similar to my [Pretty Print JSON series](/series/pretty-print-json/).

As I use Ruby for my primarily scripting language of choice, this example will be done with Ruby.

To parse the YAML file, and then pretty-print it, we can simply run:

```sh
ruby -ryaml -e 'puts YAML.load(ARGF.read).to_yaml' file.yaml
ruby -ryaml -e 'puts YAML.load(ARGF.read).to_yaml' < file.yaml
```

And because YAML is a valid superset of JSON, we can also use the same for JSON files!

```sh
ruby -ryaml -e 'puts YAML.load(ARGF.read).to_yaml' file.json
ruby -ryaml -e 'puts YAML.load(ARGF.read).to_yaml' < file.json
```
