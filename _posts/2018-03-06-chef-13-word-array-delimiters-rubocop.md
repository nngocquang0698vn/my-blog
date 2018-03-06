---
title: 'Chef 13 Upgrade: Rubocop Changes for Word Array Literals (`%w`)'
description: 'A one-liner shell command to fix Rubocop errors `%w-literals should be delimited by [ and ].`'
categories: findings chef-13-upgrade
tags: findings chef-13-upgrade chef-13-upgrade-rubocop chef rubocop chef-13 rubocop-0-49
no_toc: true
---
{% include posts/chef-13/intro.html %}

One recommended change with the new version of Rubocop is the error `%w-literals should be delimited by [ and ]`.

For instance:

```diff
-arr = %w(this is an array)
+arr = %w[this is an array]
```

For most cases, you will be able to perform one of the following commands:

```sh
# use Rubocop's automagic autocorrect, if possible
rubocop --auto-correct
# or fall back to a search and replace
find . -iname "*.rb" -exec sed 's/%w(\([^)]*\))/%w[\1]/g' {} \;
```
