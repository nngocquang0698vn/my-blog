---
title: 'Chef 13 Upgrade: Testing `ruby_block`s with ChefSpec'
description: 'Replace your `block.old_run_action` with `block.block.call` to trigger `ruby_block`s within ChefSpec 7 and Chef 13.'
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-chefspec
- chef
- chefspec
- chef-13
- chefspec-7
image: /img/vendor/chef-logo.png
date: 2018-03-06T20:34:46+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-ruby_block-chefspec
---
{{< partialCached "posts/chef-13/intro.html" >}}

ChefSpec doesn't execute `ruby_block`s by default, and instead requires you to manually trigger it within your test. In Chef 12, we would be able to do this by calling `block.old_run_action(:run)`:

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
  block = chef_run.find_resource('ruby_block', 'get the \'blah blah key\' key')
  block.old_run_action(:run)
  expect(chef_run.node.run_state['public_key/blah_blah_key']).to eq 'ssh-rsa blah'
end
```

This was removed in Chef 13, so instead we must use `block.block.call`:

```diff
 # spec
 it ' ... ' do
   block = chef_run.find_resource('ruby_block', 'get the \'blah blah key\' key')
-  block.old_run_action(:run)
+  block.block.call
   expect(chef_run.node.run_state['public_key/blah_blah_key']).to eq 'ssh-rsa blah'
 end
```

This works on both Chef 12 and Chef 13, due to the fact that `ruby_block`'s `block` property is of type `Proc` ([`Proc#call`][proc-call]).

[proc-call]: https://ruby-doc.org/core-2.4.2/Proc.html#method-i-call
