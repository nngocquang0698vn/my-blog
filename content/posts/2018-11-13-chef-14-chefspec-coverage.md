---
title: "Chef 14: ChefSpec Coverage Reporting Deprecation"
description: Noting the deprecation of using `ChefSpec::Coverage.start!` when using Chef 14 and above.
categories:
- blogumentation
- chef-14-upgrade
tags:
- chef-14
- chef-14-upgrade
- chefspec
- test-coverage
image: /img/vendor/chef-logo.png
date: 2018-11-13T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-14-chefspec-coverage
---
Since [ChefSpec 7.1.2](https://github.com/chefspec/chefspec/tree/v7.1.2), the coverage reporting within ChefSpec is deprecated.

If you have coverage reporting enabled, you will see the follwoing warning in your ChefSpec logs:

```
ChefSpec's coverage reporting is deprecated and will be removed in a future version
```

Unfortunately the team don't want to support this as they [recommend focussing test efforts on the logic-heavy portions of the cookbook](https://github.com/chefspec/chefspec/pull/891#issuecomment-398418432) rather than testing everything.

Note that you will not see this message until you have ChefDK 2.5.3 or higher.
