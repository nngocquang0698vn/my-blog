---
title: "Converting Ruby Hash keys to Strings/Symbols"
description: "How to recursively convert a Ruby Hash's keys to a String / Symbol."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-07T22:36:36+0100
slug: "ruby-hash-keys-string-symbol"
---
When working with Ruby Hashes, you may find that there are two ways to interact with them, using the String notation commonly seen with JSON, but also using Ruby's Symbol concept.

In case you're not intimately familiar with them, you can see below an example of how to interact with either a String or Symbol key:

```ruby
hash_str = {
  'key' => true
}
hash_str = {
  key: true
}

p hash_str
# {"key"=>true}
p hash_str[:key]
# nil
p hash_str['key']
# true

p hash_sym
# {:key=>true}
p hash_sym[:key]
# true
p hash_sym['key']
# nil
```

If you don't know which way a Hash is formatted, it can be worth re-writing the keys to a format you want to deal with.

We can adapt [the steps from StackOverflow](https://stackoverflow.com/a/25835016/2257038), and provide a helper method on `Hash` itself, which will recursively convert the keys to either strings or symbols:

```ruby
class ::Hash
  # via https://stackoverflow.com/a/25835016/2257038
  def stringify_keys
    h = self.map do |k,v|
      v_str = if v.instance_of? Hash
                v.stringify_keys
              else
                v
              end

      [k.to_s, v_str]
    end
    Hash[h]
  end

  # via https://stackoverflow.com/a/25835016/2257038
  def symbol_keys
    h = self.map do |k,v|
      v_sym = if v.instance_of? Hash
                v.symbol_keys
              else
                v
              end

      [k.to_sym, v_sym]
    end
    Hash[h]
  end
end
```

This allows us to perform the following:

```ruby
hash_str = {
  'key' => true
}
hash_str = {
  key: true
}

p hash_sym.stringify_keys
# {"key"=>true}
p hash_str.symbol_keys
# {:key=>true}
```
