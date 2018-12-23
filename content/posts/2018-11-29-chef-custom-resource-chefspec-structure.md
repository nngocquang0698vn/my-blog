---
title: Using Fake Cookbooks for Writing ChefSpec Tests for your Custom Chef Resources
description: A directory structure I've found quite useful for writing ChefSpec tests for custom resources, by creating a fake cookbook within the cookbook you're testing.
categories:
- blogumentation
- chef
tags:
- blogumentation
- chef
- custom-resource
- chefspec
image: /img/vendor/chef-logo.png
date: 2018-11-29
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
In line with my article [_Test-Driven Chef Cookbook Development Using ChefSpec (and a sprinkling of InSpec)_][tdd-chef], I heavily unit test the [Custom Resources] I write with my Chef code.

Until recently, the way that I've done this is creating a new recipe within the cookbook I'm testing, purely for the purpose of unit testing the resource.

For instance, let's assume I'm in a cookbook `spectat` which has a resource called `spectat_site`. In this case, I would create a recipe `_spectat_site` whose purpose is purely to be used for unit testing the `spectat_site` resource.

However, even when I adopted the pattern, I didn't like it - it means having numerous extra recipes within the cookbook that are _technically_ available for external consumers to use, but shouldn't be, as they're just for driving tests. Additionally, that single recipe gets quite complicated so we can pass in all combinations of parameters and actions to ensure it's thoroughly tested.

I've since moved to the approach, stolen from the [line cookbook], where I can have a "fake" cookbook purely for the sake of tests. This would mean I'd have an associated fake test cookbook called `spectat_site` which has recipes for different aspects of testing the resource. This simplifies the logic within the resource-testing recipes, and makes intentions clearer to the reader.

This fake cookbook sits in the `spec/fixtures/cookbooks` folder, with the same name as the resource it's testing:

```ruby
# spec/fixtures/cookbooks/spectat_site/metadata.rb
cookbook 'spectat_site'
depends 'spectat'
```

It also needs a `depends` on the cookbook we're testing, so it can then use the resources we want to test!

We can create the test within our top-level cookbook:

```ruby
# spec/unit/resources/spectat_site/all_properties_spec.rb
describe 'spectat_site::all_properties' do
  let(:chef_run) do
    chef_run = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04', step_into: ['spectat_site'])
    chef_run.converge(described_recipe)
  end

  it 'converges successfully' do
    expect(chef_run).to_not raise_error
  end

  it 'creates the user' do
    expect(chef_run).to create_user('create the user for www.jvt.me')
      .with(username: 'www_jvt_me')
      # ...
  end

  it 'creates the folder structure' do
    expect(chef_run).to create_directory('create the directory for www.jvt.me')
      .with(path: '/srv/www/www.jvt.me')
      .with(owner: 'www_jvt_me')
      .with(recursive: true)
      # ...
  end

  # ...
end
```

Which has the following `all_properties` recipe within our `spectat_site` fake cookbook:

```ruby
# spec/fixtures/cookbooks/spectat_site/recipes/all_properties.rb
spectat_site 'create a site for www.jvt.me' do
  site_fqdn 'www.jvt.me'
  site_type :static
end
```

Finally, to actually be able to find the new cookbook, we need to add to our `Berksfile`:

```diff
 source 'https://supermarket.chef.io'

 metadata
+
+group :integration do
+  # TODO: add each new test cookbook here as needed
+  cookbook 'spectat_site', path: 'spec/fixtures/cookbooks/spectat_site'
+end
```

This then makes sure that _just when testing_, ChefSpec will know how to use that cookbook - awesome stuff!

As mentioned, this can be a really nice pattern for reducing complexity in resource-testing recipes, as well as remove the fake recipes from being used accidentally by our cookbook consumers.

[Custom Resources]: https://docs.chef.io/custom_resources.html
[tdd-chef]: {{< ref 2018-09-04-tdd-chef-cookbooks-chefspec-inspec >}}
[line cookbook]: https://github.com/sous-chefs/line
