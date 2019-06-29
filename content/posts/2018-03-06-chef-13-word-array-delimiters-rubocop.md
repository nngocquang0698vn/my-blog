---
title: 'Chef 13 Upgrade: Rubocop Changes for Word Array Literals (`%w`)'
description: 'A one-liner shell command to fix Rubocop errors `%w-literals should be delimited by [ and ]`.'
tags:
- blogumentation
- chef-13-upgrade
- chef-13-upgrade-rubocop
- chef
- rubocop
- chef-13
- rubocop-0-49
image: /img/vendor/chef-logo.png
date: 2018-03-06T20:34:46+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-word-array-delimiters-rubocop
---
{{< partialCached "posts/chef-13/intro.html" >}}

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
find . -iname "*.rb" -exec sed -i 's/%w(\([^)]*\))/%w[\1]/g' {} \;
```
