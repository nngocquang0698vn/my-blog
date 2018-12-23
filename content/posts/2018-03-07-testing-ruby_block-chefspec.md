---
title: "Testing Chef's `ruby_block`s with ChefSpec"
description: 'Testing implementation of a `ruby_block` in ChefSpec, to ensure that the code executes as expected'
categories:
- blogumentation
- chef
tags:
- blogumentation
- chef
- chefspec
- testing
image: /img/vendor/chef-logo.png
date: 2018-03-07
---
I like to ensure that all my code is as well unit tested as possible, both so I can quickly iterate changes, and to ensure that future changes don't inadvertently break functionality.

However, when I first needed to touch Chef's `ruby_block`s, I found that they were not being executed as part of the ChefSpec run. During a ChefSpec run, I could confirm that the block _would_ be called on a code path, but I wouldn't be able to confirm until an integration test (i.e. converging with Test Kitchen) that the code inside them would actually work.

## Using `ruby_block.block.call`

Investigating this further, I found that it was possible to use `block.old_run_action(:action)` to trigger the block to run as if the block was actually called during a Chef run:

```ruby
  # recipe
  ruby_block "get the '#{key_name}' key" do
    block do
      node.run_state["public_key/#{safe_key_name}"] = ::File.read("#{node['etc']['passwd'][username]['dir']}/.ssh/#{safe_key_name}.pub")
      Chef::Recipe::RubyBlockHelper.run_state_public_key(node, username, safe_key_name)
    end
  end

  # spec
  it ' ... ' do
    expect(chef_run).to run_ruby_block('get the \'blah blah key\' key')

    allow(::File).to receive(:read)
      .and_call_original
    allow(::File).to receive(:read)
      .with('/run/lib/www-spectatdesigns-co-uk/.ssh/blah_blah_key.pub')
      .and_return 'ssh-rsa blah'

    expect(chef_run.node.run_state.key?('public_key/blah_blah_key')).to eq false

    block = chef_run.ruby_block('get the \'blah blah key\' key')
    block.old_run_action(:run)

    expect(chef_run.node.run_state['public_key/blah_blah_key']).to eq 'ssh-rsa blah'
  end
```

However, as mentioned in [Chef 13 Upgrade: Testing `ruby_block`s with ChefSpec][chef-13-ruby_block], the `block.old_run_action` method has been removed in Chef 13. Fortunately the `ruby_block`'s `block` property is of type `Proc` ([`Proc#call`][proc-call]), we which means we can perform the following minor change, and still retain functionality:

```diff
 # spec
 it ' ... ' do
   ...
   block = chef_run.ruby_block('get the \'blah blah key\' key')
-  block.old_run_action(:run)
+  block.block.call

   expect(chef_run.node.run_state['public_key/blah_blah_key']).to eq 'ssh-rsa blah'
 end
```

## Extracting to a Helper Class

With the code now working in Chef 13, I started to think about how ideal it was to have this method only tested within the block itself.

For instance, let's assume this block is duplicated in three different recipes. This means that we'd have three tests in three places, and any changes to the `block` would have to be propagated across recipes, updating tests as we go.

A better way to do this would be to extract the code into its own [library function][chef-libraries] so we can unit test it in isolation:

```ruby
# libraries/ruby_block_helper.rb
class Chef
  class Recipe
    class RubyBlockHelper
      def self.run_state_public_key(node, username, safe_key_name)
        node.run_state["public_key/#{safe_key_name}"] = \
          ::File.read("#{node['etc']['passwd'][username]['dir']}/.ssh/#{safe_key_name}.pub")
        node
      end
    end
  end
end

# spec/unit/libraries/ruby_block_helper_spec.rb
describe Chef::Recipe::RubyBlockHelper do
  context '#run_state_public_key' do
    it 'reads the public key from disk' do
      node = Chef::Node.new
      username = 'testuser'
      safe_key_name = 'fakename'

      node.automatic['etc']['passwd']['testuser']['dir'] = '/srv/wobble'

      allow(::File).to receive(:read)
        .and_call_original
      allow(::File).to receive(:read)
        .with('/srv/wobble/.ssh/fakename.pub')
        .and_return 'ssh-wibble hello'

      node_out = Chef::Recipe::RubyBlockHelper.run_state_public_key(node, username, safe_key_name)
      expect(node_out.run_state['public_key/fakename']).to eq 'ssh-wibble hello'
    end
  end
end
```

This then lets us change our `ruby_block`'s implementation to simply call that method:

```diff
   ruby_block "get the '#{key_name}' key" do
     block do
-      node.run_state["public_key/#{safe_key_name}"] = ::File.read("#{node['etc']['passwd'][username]['dir']}/.ssh/#{safe_key_name}.pub")
+      Chef::Recipe::RubyBlockHelper.run_state_public_key(node, username, safe_key_name)
     end
   end
```


This gives us a much cleaner interface, and we can repeat this method call in many `ruby_block`s and know it's working the same way.

That being said, our test hasn't been updated to check that the method was called - this verification can help us confirm that the implementation in each `ruby_block` remains correct:

```diff
   # spec
   it ' ... ' do
    ...
+   # ensure we're correctly calling the helper
+   allow(Chef::Recipe::RubyBlockHelper).to receive(:run_state_public_key)
+     .with(any_args)
+     .and_raise 'call to run_state_public_key not matched'
+   allow(Chef::Recipe::RubyBlockHelper).to receive(:run_state_public_key)
+     .with(any_args, 'www-spectatdesigns-co-uk', 'blah_blah_key')
+     .and_call_original

    block = chef_run.ruby_block('get the \'blah blah key\' key')
    block.old_run_action(:run)

    expect(chef_run.node.run_state['public_key/blah_blah_key']).to eq 'ssh-rsa blah'
   end
```

This ensures that we'll defer to the expected implementation if we're calling it with the correct arguments, and in the case we're not calling it with expected arguments, we'll break the test by raising an error.

[chef-13-ruby_block]: {% post_url 2018-03-06-chef-13-ruby_block-chefspec %}
[chef-libraries]: https://docs.chef.io/libraries.html
