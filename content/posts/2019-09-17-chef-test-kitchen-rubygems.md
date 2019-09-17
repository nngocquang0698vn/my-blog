---
title: "Setting up a custom RubyGems Repository for Chef in Test Kitchen"
description: "How to use a private RubyGems repository for your Chef gem dependencies in Test Kitchen."
tags:
- chef
- blogumentation
- test-kitchen
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-17T13:33:14+01:00
slug: "chef-test-kitchen-rubygems"
---
If you work in an Enterprise, you likely have guidelines around where your dependencies can be stored. Alternatively, you may have proprietary dependencies that you want to store privately.

Although you may have set up your Chef Client to use your private RubyGems repo, that will not work when you're running through Test Kitchen because it sets up its own Chef configuration.

To resolve this, update your `$HOME/.kitchen/config.yml` or your `.kitchen.yml` with the following addition to the `provisioner` block:

```diff
 provisioner:
   name: chef_zero
+  client_rb:
+    rubygems_url 'https://private.rubygems-repo.com/something/gems'
```
