---
title: 'Chef 13 Upgrade: `knife-cookbook-doc` Rubocop Updates'
description: 'Disabling the `Missing space after #` and `Do not use block comments` errors for your `knife-cookbook-doc` formatted comments.'
categories:
- blogumentation
- chef-13-upgrade
tags:
- blogumentation
- chef-13-upgrade
- chef
- knife-cookbook-doc
- chef-13
- documentation
- chef-13-upgrade-rubocop
image: /img/vendor/chef-logo.png
date: 2018-03-09T17:30:42+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-13-knife-cookbook-doc-rubocop
---
{{< partialCached "posts/chef-13/intro.html" >}}

As mentioned in ['Chef 13 Upgrade: `knife-cookbook-doc` gem upgrade'][chef-13-knife-cookbook-doc] I use the [`knife-cookbook-doc`][knife-cookbook-doc] gem to autogenerate my cookbook documentation, with formatting of the formats:

```ruby
# attributes.rb
#<> Caddy base download URL: Required to override until https://github.com/dzabel/chef-caddy/pull/1 is merged
default['caddy']['url'] = 'https://caddyserver.com/download/linux/amd64?'

# resources/site.rb
=begin
#<
@property fqdn to configure a site for. When Chef Envrionment is `staging`, the FQDN that is configured will be `staging.{fqdn}`
#>
=end
property :fqdn
```

However, with the upgrade to Chef 13, Rubocop has been throwing a number of errors, `Do not use block comments`.

This was an easy fix to add to my `.rubocop.yml`, allowing me to simply ignore them in the source files I was using them:

```yaml
Style/BlockComments:
  Exclude:
    - 'attributes/default.rb'
    - 'recipes/*.rb'
    - 'resources/*.rb'
```

And although not technically part of the Chef 13 upgrade, I also wanted to note that I have the following exception for my `attributes` files, as they use the first format, which Rubocop isn't happy about, either.

```yaml
Layout/LeadingCommentSpace:
  Exclude:
    - 'attributes/default.rb'
```

[chef-13-knife-cookbook-doc]: {{< ref 2018-03-07-chef-13-knife-cookbook-doc >}}
[knife-cookbook-doc]: https://github.com/realityforge/knife-cookbook-doc
