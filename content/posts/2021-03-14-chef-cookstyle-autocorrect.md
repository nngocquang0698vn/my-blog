---
title: "How to Use Cookstyle to Autocorrect Style Issues"
description: "How to use the `cookstyle` tool with Chef cookbooks to autocorrect style issues."
tags:
- blogumentation
- chef
- ruby
- chefdk
- chef-workstation
- cookstyle
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-14T12:41:45+0000
slug: "chef-cookstyle-autocorrect"
image: /img/vendor/chef-logo.png
---
[Cookstyle](https://docs.chef.io/workstation/cookstyle/) is the primary linting tool for Chef cookbooks, and is a great way of picking up on common issues - be they style, or more substantial like antipatterns that were previously tracked using (the now deprecated) [Foodcritic](https://docs.chef.io/workstation/foodcritic/).

I spotted earlier that someone was searching on my site to find out how to fix things automagically, so I thought I'd write a quick post for it. It also turns out that I've been [meaning to write about this for over two years!](https://gitlab.com/jamietanna/jvt.me/-/issues/308).

Cookstyle is based on Rubocop, which provides the super handy `-a` flag to autocorrect any cops it can do:

```sh
cookstyle -a .
# ...
11 files inspected, 36 offenses detected, 34 offenses corrected, 1 more offense can be corrected with `rubocop -A`
```

And it'll fix as much as it can do!

You may see that it may not be able to fix everything, as there are some unsafe changes it won't perform by default. I'd recommend doing these manually, but if you've reviewed them and seem happy, you can resolve them with:

```sh
cookstyle -A .
```
