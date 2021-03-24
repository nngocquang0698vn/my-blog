---
title: "Managing Your Chef Gem Dependencies More Easily in your `Gemfile`"
description: "How to source your Chef Gem dependencies from your Chef cookbook's `metadata.rb`\
  \ instead of duplicating them between files."
date: "2021-03-24T13:42:37+0000"
tags:
- "blogumentation"
- "chef"
- "ruby"
slug: "chef-cookbook-gem-metadata"
---
When writing Chef cookbooks, it's possible that we're going to want to use a gem as a dependency, for instance to interact with HashiCorp Vault using the [vault gem](https://rubygems.org/gems/vault).

To tell Chef that we want to have this gem installed before we perform a Chef run, we need to add it as a `gem` to our `metadata.rb`:

```ruby
# other cookbook metadata

gem 'vault', '~> 0.16'
```

However, this then causes issues for us, as if we want to do any local testing, such as [unit testing with  ChefSpec]({{< ref 2018-09-04-tdd-chef-cookbooks-chefspec-inspec >}}), we can't rely on Chef to install these gems, as we're not really executing a full Chef run.

The solution, previously mentioned in [my post about Chef's dependency management tools]({{< ref 2019-09-15-chef-dependency-management >}}), is that we need to add this i.e. to our `Gemfile`, so Bundler can install the dependency:

```ruby
source '...'

gem 'vault', '~> 0.16'
```

This then has the problem of our `Gemfile` and `metadata.rb` becoming misaligned, and can be quite annoying, as we may be testing against a different version than is installed by the cookbook. Fortunately, using the knowledge from my article [_Programatically Determining the Version of a Chef Cookbook_]({{< ref 2021-03-23-chef-cookbook-version >}}), we can take advantage of the `Gemfile` being a Ruby file, and replace the `Gemfile` with:

```ruby
source '...'

require 'chef'

m = Chef::Cookbook::Metadata.new
m.from_file 'metadata.rb'
m.gems.each do |name, version|
  gem name, version
end
```

This allows us to manage our Chef Gem dependencies for Chef and local development with Bundler, and remove the need to keep both updated!

An alternative would be to monkey patch [Bundler::Dsl](https://ruby-doc.org/stdlib-2.7.0/libdoc/bundler/rdoc/Bundler/Dsl.html), but this also works as-is, and doesn't require anything else to be globally installed.

I've also [raised this upstream with the Bundler team](https://github.com/rubygems/rubygems/issues/4486) to see their thoughts about this being a first-class citizen.
