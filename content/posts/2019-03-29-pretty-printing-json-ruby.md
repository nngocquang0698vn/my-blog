---
title: Pretty Printing JSON with Ruby
description: Using `Kernel.jj` to pretty print Ruby objects as JSON objects.
categories:
- blogumentation
tags:
- blogumentation
- ruby
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-29T18:04:00
slug: "pretty-printing-json-ruby"
---
If you're debugging your Ruby code, you may be used to printing out variables to the console to see what they contain, such as:

```ruby
hash = {
  abc: [
    1
  ]
}
# print the variable
puts hash
# print the internal representation of the variable
p hash
# pretty-print using the `pp` gem
require 'pp'
pp hash
#
puts JSON.pretty_generate(hash)
```

Which would give you the following representations:

```
{:abc=>[1]}
{:abc=>[1]}
{:abc=>[1]}
{
  "abc": [
    1
  ]
}
```

However, you may not be aware of [`Kernel.jj`](https://apidock.com/ruby/Kernel/jj) which is a nice wrapper around the latter option:

```ruby
hash = {
  abc: [
    1
  ]
}
jj hash
```

And generates a nicely pretty-printed JSON representation of our i.e. Hash:

```json
{
  "abc": [
    1
  ]
}
```

This makes debugging nicer, as then we can see nice JSON representations.
