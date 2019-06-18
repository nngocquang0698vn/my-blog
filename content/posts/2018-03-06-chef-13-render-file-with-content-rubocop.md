---
title: 'Chef 13 Upgrade: Rubocop Changes for Testing `render_file` with ChefSpec and a `with_content` Block'
description: 'How to resolve the `Parenthesize the param render_file` Rubocop error when upgrading your cookbook to Chef 13.'
categories:
- blogumentation
- chef-13-upgrade
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-chefspec
- chef
- chefspec
image: /img/vendor/chef-logo.png
date: 2018-03-06T20:34:46+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-render-file-with-content-rubocop
---
{{< partialCached "posts/chef-13/intro.html" >}}

When testing that Chef's `template`s are being rendered correctly, the easiest way to do this is via `render_file(...).with_content(&block)`.

However, when running the below code against Chef 13's Rubocop, this gives the error `Parenthesize the param render_file`:

```ruby
expect(chef_run).to render_file('/chef/.ssh/authorized_keys')
  .with_content do |content|
    expect(content).to match(%r{^ssh-rsa this is long key$})
    expect(content).to match(%r{^ssh-another key$})
    expect(content).to match(%r{^wibble deploy$})
  end
```

The fix is to have the whole `render_file` method call wrapped in parentheses, such as:

```diff
-expect(chef_run).to render_file('/chef/.ssh/authorized_keys')
-  .with_content { |content|
+expect(chef_run).to(render_file('/chef/.ssh/authorized_keys')
+  .with_content do |content|
     expect(content).to match(%r{^ssh-rsa this is long key$})
     expect(content).to match(%r{^ssh-another key$})
     expect(content).to match(%r{^wibble deploy$})
-  }
+  end)
```

Additionally, I've converted the multi-line block to a `do` / `end` block, as that was another complaint of Rubocop.
