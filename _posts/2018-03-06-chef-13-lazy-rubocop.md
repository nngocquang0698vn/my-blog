---
title: 'Chef 13 Upgrade: Rubocop Changes for `lazy` Parameters'
description: 'How to resolve the `Parenthesize the param lazy` Rubocop error when upgrading your cookbook to Chef 13.'
categories: findings chef-13-upgrade
tags: findings chef-13-upgrade chef-13-upgrade-rubocop chef rubocop chef-13 rubocop-0-49
no_toc: true
---
{% include posts/chef-13/intro.html %}

When running Rubocop from ChefDK 2 against the following code, we receive the error `Parenthesize the param lazy { ... } to make sure that the block will be associated with the lazy method call` twice:

```ruby
template 'Chef deploy user\'s authorized_keys' do
  source 'authorized_keys.erb'
  path lazy { "#{node['etc']['passwd']['chef']['dir']}/.ssh/authorized_keys" }
  user 'chef'
  group 'chef'
  mode '0600'
  variables lazy {
    {
      public_keys: node['authorized_keys'] + [node.run_state['public_key/deploy']]
    }
  }
end
```

This error can be resolved by adding a parentheses around the whole `lazy { }` blocks:

```diff
 template 'Chef deploy user\'s authorized_keys' do
   source 'authorized_keys.erb'
-  path lazy { "#{node['etc']['passwd']['chef']['dir']}/.ssh/authorized_keys" }
+  path(lazy { "#{node['etc']['passwd']['chef']['dir']}/.ssh/authorized_keys" })
   user 'chef'
   group 'chef'
   mode '0600'
-  variables lazy {
+  variables(lazy do
     {
       public_keys: node['authorized_keys'] + [node.run_state['public_key/deploy']]
     }
-  }
+  end)
 end
```

Note that I've also converted the multi-line block to a `do` / `end` block, as that was another complaint of Rubocop.
