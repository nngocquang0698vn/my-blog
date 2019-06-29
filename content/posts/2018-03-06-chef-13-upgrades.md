---
title: 'Chef 13 Upgrade: Lessons Learnt and Documented for Posterity'
description: 'Notes on the main problems encountered when upgrading from Chef 12 to Chef 13, both with ChefSpec and Rubocop.'
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-rubocop
- chef-13-upgrade-chefspec
- chef
- rubocop
- chefspec
- chef-13
- chefspec-7
- rubocop-0-49
image: /img/vendor/chef-logo.png
date: 2018-03-06T20:34:46+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-upgrades
---
I've recently been working through upgrading my Chef 12 cookbooks to Chef 13, as Chef 12 is to be [End of Life'd in April 2018][chef-12-eol].

As part of this, there have been a few snags I've hit with respect to [Chef 13 + Rubocop][chef-13-upgrade-rubocop] and [Chef 13 + ChefSpec][chef-13-upgrade-chefspec] within my existing cookbooks.

For reasons I won't go into, I'm still using Rubocop over the Chef-recommended [CookStyle][cookstyle], which it seems would have resolved a few of these issues.

Note that some, but not all, of the Rubocop fixes can be automagically resolved using `rubocop --auto-correct`.

[chef-12-eol]: https://www.chef.io/eol-chef12-and-chefdk1/
[chef-13-upgrade-rubocop]: /tags/chef-13-upgrade-rubocop/
[chef-13-upgrade-chefspec]: /tags/chef-13-upgrade-chefspec/
[cookstyle]: https://docs.chef.io/cookstyle.html
