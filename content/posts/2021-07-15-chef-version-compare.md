---
title: "Programatically Comparing Versions Using Chef's Versioning Schemes"
description: "How to use Chef's versioning classes to determine whether a version constraint is matched."
tags:
- blogumentation
- chef
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-07-15T20:48:37+0100
slug: "chef-version-compare"
image: /img/vendor/chef-logo.png
---
Chef's got some pretty great ways of definining version constraints of its dependencies, which can be used across cookbook dependencies, gem dependencies and supported platforms.

Today, I wanted to write some code that checked whether a cookbook supports RHEL7, but not RHEL8.

To do this, we would have our `metadata.rb`:

```ruby
# not great
supports 'redhat', '< 8'
# better
supports 'redhat', '~> 7.0'
```

But how do we then determine this programatically? We can use `Chef::VersionConstraint::Platform` to parse the supported value, like so, and then compare it against a specific version:

```ruby
require 'chef'

m = Chef::Cookbook::Metadata.new
m.from_file 'metadata.rb'
constraint = Chef::VersionConstraint::Platform.new m.platforms['redhat']
puts constraint.include? '6'
# => true
puts constraint.include? '7'
# => true
puts constraint.include? '7.5'
# => true
puts constraint.include? '7.5.0'
# => true
puts constraint.include? '8'
# => false
```

If you're comparing cookbook versions, you can just use `Chef::VersionConstraint.new`.
