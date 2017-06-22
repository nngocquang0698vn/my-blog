---
layout: post
title: Converting YAML to JSON and vice versa (Part 1 - Ruby)
description: Coerce YAML to JSON and vice versa, from the comfort of your Gem-studded command line.
categories: findings
tags: findings ruby cli
---
I've recently been finding myself trying to coerce YAML to JSON and vice versa quite a bit, partly to convert attributes from a [Test Kitchen][test-kitchen] YAML file to a nice JSON object that can be consumed by [Vagrant][vagrant]'s [Chef provisioner][vagrant-chef].

As such, I've been wanting to make it possible to have this scripted, so it's a much more efficient process for me.

Another requirement of scripting this is that it follows the [UNIX Philosophy][unix-philosophy] - more specifically the second point, `Expect the output of every program to become the input to another, as yet unknown, program.`.

## Converting from YAML to JSON

To convert from YAML to JSON, we can use the following:

```ruby
{% include src/yaml-json/ytoj.rb %}
```

This takes advantage of [`ARGF`][so-stdin], which is a file descriptor that points to `stdin`.

Using inspiration from [otobrglez's gist][otobrglez-gist], we can shorten this down to the following oneliner:

```ruby
ruby -ryaml -rjson -e 'puts(YAML.load(ARGF.read).to_json)'
```

## Converting from JSON to YAML

To convert from JSON to YAML, we can use the following:

```ruby
{% include src/yaml-json/jtoy.rb %}
```

Again, we can shorten this down to the following oneliner:

```ruby
ruby -ryaml -rjson -e 'puts(JSON.load(ARGF.read).to_yaml)'
```

[test-kitchen]: https://kitchen.ci
[vagrant]: https://vagrantup.com
[vagrant-chef]: https://www.vagrantup.com/docs/provisioning/chef_solo.html
[so-stdin]: https://stackoverflow.com/questions/273262/best-practices-with-stdin-in-ruby
[otobrglez-gist]: https://gist.github.com/otobrglez/66274639697f377de8ec8047a248b8f0
[unix-philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
