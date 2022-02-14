---
title: "Sorting a Hash Recursively with Ruby"
description: "How to sort a `Hash` in Ruby recursively, when nested `Array` exist."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-24T20:56:20+0100
slug: "sort-recursive-hash-ruby"
image: https://media.jvt.me/00fdea0d32.png
---
As part of [_Diffing Pretty-Printed JSON Files_](/posts/2020/08/24/pretty-print-json-diff/), I wanted to have a method of making JSON documents easier to diff by sorting their keys.

I wanted to use [this solution](http://bdunagan.com/2011/10/23/ruby-tip-sort-a-hash-recursively/) by <span class="h-card"><a class="u-url" href="http://bdunagan.com/">Brian Dunagan</a></span>, but it didn't seem to quite work when, in my example, I had an `Array`s which may have `Hash`es but may also not.

My amended solution is:

```ruby
def recursive_sort(v, &block)
  if v.class == Hash
    v.sorted_hash(&block)
  elsif v.class == Array
    v.collect {|a| recursive_sort(a, &block)}
  else
    v
  end
end

class Hash
  def sorted_hash(&block)
    self.class[
      self.each do |k,v|
        self[k] = recursive_sort(v, &block)
      end.sort(&block)]
  end
end
```
