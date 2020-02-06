---
title: "Converting a Ruby Hash to a String"
description: "The ways that we can convert a Hash to a String with Ruby."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-06T19:24:39+0000
slug: "ruby-hash-string"
---
I noticed today a couple of visitors to the site who were searching for "ruby convert hash to string" - this article is for them, but also for me in the future when I forget!

One option, would be to use `.to_s` which converts anything in Ruby to its internal String representation.

This works if you want to have a representation output to a Ruby for use with copy-pasting into source code:

```ruby
hash_str = {'key'=> [1,2,3]}
puts hash_str.to_s
# {"key"=>[1, 2, 3]}

hash_sym = {key: [1,2,3]}
puts hash_sym.to_s
# {:key=>[1, 2, 3]}
```

But this won't quite work for folks that want to have a format that can be used in i.e. other languages or tools. For this, I would recommend [pretty-printing it as JSON]({{< ref 2018-06-18-pretty-printing-json-ruby-cli >}}):

```ruby
require 'json'
hash_str = {'key'=> [1,2,3]}
puts JSON.pretty_generate(hash_str)
# {
#   "key": [
#     1,
#     2,
#     3
#   ]
# }

hash_sym = {key: [1,2,3]}
puts JSON.pretty_generate(hash_sym)
# {
#   "key": [
#     1,
#     2,
#     3
#   ]
# }
```
