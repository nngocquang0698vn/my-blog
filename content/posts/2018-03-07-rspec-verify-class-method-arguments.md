---
title: Verify a Ruby Class Method is Called with Arguments in Rspec, Without Doubles or Mocks
description: Rspec code to verify that a Ruby Class Method is called from another method, without needing to mock anything.
categories:
- blogumentation
- ruby
tags:
- blogumentation
- ruby
- testing
- rspec
date: 2018-03-07T15:28:26+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: rspec-verify-class-method-arguments
---
While working on [Testing Chef's `ruby_block`s with ChefSpec][testing-ruby_block-chefspec], I found that I was struggling to find any resources explaining my seemingly niche request:

- testing a ruby block calls a class (static) method
- verifying that the correct arguments are passed to it
- while preserving original implementation - therefore ruling out using doubles or mocks

As this didn't seem to dig up much (perhaps due to using the wrong words for names) I ended up being able to bruteforce a solution using Rspec's `expected` syntax:

```ruby
# impl
def function(arg)
  ...
  val = Chef::Recipe::RubyBlockHelper.run_state_public_key(arg1, arg2, arg3)
  ...
end

# spec
it '...' do
  # given
  expect(Chef::Recipe::RubyBlockHelper).to receive(:run_state_public_key)
    .with('hello', 'www-spectatdesigns-co-uk', 'blah_blah_key')
    .and_call_original

  # when
  out = other_object.function('arg')

  # then
  expect(out).to ...
end
```

A couple of points to note:

- by using an `expect` here, instead of an `allow`, Rspec will raise an error if `run_state_public_key` isn't received
- `.and_call_original` ensures we will preserve original functionality of `run_state_public_key`

[testing-ruby_block-chefspec]: {{< ref 2018-03-07-testing-ruby_block-chefspec >}}
