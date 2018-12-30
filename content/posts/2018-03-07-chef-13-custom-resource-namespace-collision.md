---
title: 'Chef 13 Upgrade: Deprecation of Namespace Collisions in Custom Resources'
description: 'Preparing for breaking changes in Chef 14 by renaming `property_name` to `new_resource.property_name` in Custom Resources.'
categories:
- blogumentation
- chef-13-upgrade
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-deprecation
- chef
- chef-13
- chef-14
image: /img/vendor/chef-logo.png
date: 2018-03-07
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-custom-resource-namespace-collision
---

In Chef 12 and Chef 13, the following code would work, allowing the `file` resource to access the `my_content` property:

```ruby
property :my_content, String

action :doit do
  file "/tmp/file.xy" do
    content my_content
  end
end
```

However, this is now [deprecated, and will be removed in Cher 14][chef-ns-collisions] in lieu of referring to properties by i.e. `new_resource.my_content`:

```diff
 property :my_content, String

 action :doit do
   file "/tmp/file.xy" do
-    content my_content
+    content new_resource.my_content
   end
 end
```

[chef-ns-collisions]: https://docs.chef.io/deprecations_namespace_collisions.html
