---
title: Converting YAML to JSON and vice versa (Part 1 - Ruby)
description: Coerce YAML to JSON and vice versa, from the comfort of your Gem-studded command line.
tags:
- blogumentation
- ruby
- cli
date: 2017-06-22T21:16:53+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: yaml-to-json
---
I've recently been finding myself trying to coerce YAML to JSON and vice versa quite a bit, partly to convert attributes from a [Test Kitchen][test-kitchen] YAML file to a nice JSON object that can be consumed by [Vagrant][vagrant]'s [Chef provisioner][vagrant-chef].

As it's been required a number of times, I decided that I needed to script it. The key requirement I have for scripting it is that the script follows the [UNIX Philosophy][unix-philosophy] - more specifically the second point, `Expect the output of every program to become the input to another, as yet unknown, program.`. This means that I can easily create Bash pipelines, i.e. in conjunction with [Python's JSON module][python-mjson]: `ytoj < file.yml | python -m json.tool`.

# Converting from YAML to JSON

To convert from YAML to JSON, we can use the following:

```ruby
#!/usr/bin/env ruby
require 'yaml'
require 'json'

puts(YAML.load(ARGF.read).to_json)
```

This takes advantage of [`ARGF`][so-stdin], which is a file descriptor that points to `stdin`.

Using inspiration from [otobrglez's gist][otobrglez-gist], we can shorten this down to the following oneliner:

```ruby
ruby -ryaml -rjson -e 'puts(YAML.load(ARGF.read).to_json)'
```

# Converting from JSON to YAML

To convert from JSON to YAML, we can use the following:

```ruby
#!/usr/bin/env ruby
require 'yaml'
require 'json'

puts(JSON.load(ARGF.read).to_yaml)
```

Again, we can shorten this down to the following oneliner:

```ruby
ruby -ryaml -e 'puts(YAML.load(ARGF.read).to_yaml)'
```

Thanks to [Jack Gough](https://www.testingsyndicate.com/) for a tip on reducing the above - due to JSON being parseable as YAML, we can reduce dependency on the JSON library.

[test-kitchen]: https://kitchen.ci
[vagrant]: https://vagrantup.com
[vagrant-chef]: https://www.vagrantup.com/docs/provisioning/chef_solo.html
[so-stdin]: https://stackoverflow.com/questions/273262/best-practices-with-stdin-in-ruby
[otobrglez-gist]: https://gist.github.com/otobrglez/66274639697f377de8ec8047a248b8f0
[unix-philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
[python-mjson]: {{< ref 2017-06-05-pretty-printing-json-cli >}}
