---
title: 'Testing `include_recipe`s with Chef and ChefSpec'
description: How to best test `include_recipe`s within your Chef recipes, as well as how to ensure that you aren't running any dependent recipes in your tests.
tags:
- blogumentation
- chef
- tdd
- chefspec
image: /img/vendor/chef-logo.png
date: 2017-07-16T16:35:10+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-testing-include_recipe
---
While writing cookbooks, both personally and professionally, I practice a heavy use of TDD to ensure that the recipes are doing what I expect them to. As part of this, I will want to test both standard resources, as well as `include_recipe`s:

```ruby
describe 'cookbook::default' do
  let(:chef_run) do
    # ...
  end

  it 'includes the ::user recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('cookbook::user')
    chef_run
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
```

# Ensuring dependent recipes don't get run

When you're performing a `runner.converge` with ChefSpec, it is performing a converge by going through each of the recipes and running them in-memory. Because it actually runs the recipe, it means that if a given recipe requires any attributes to be set, then you will also need to put your attributes into the calling recipe. As I'm sure you can guess, having recipes including each other will then start to have quite a large set of attributes and configuration required in order to test what looks like a single recipe, but is instead the full chain of recipes required. This breaks the idea of "unit testing", as it doesn't give us a single unit to test against.

Therefore, the best way to get around this, is to simply not let the other recipes be run. Taking advantage of [RSpec Mocks][rspec-mocks], we effectively let `include_recipe` be called, but it doesn't do anything:

```ruby
describe 'cookbook::default' do
  let(:chef_run) do
    # ...
  end

  before :each do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
      .with('cookbook::user')
  end

  it 'includes the ::user recipe' do
    # ...
end
```


# Defensive `include_recipe`s

However, if we have this running, it won't flag up `include_recipe` being called on any other recipes that we've not predicted in our tests. Yes, this should be more obvious when practicing TDD, but it **???**. This would mean that recipes could be silently executing in the background, slowing down tests, which may not be as noticeable in the case that they don't require any extra attributes set.

To do this, we can utilise RSpec Mocks again, but this time, we can `raise` if there's a non-whitelisted recipe called.

```ruby
describe 'cookbook::default' do
  let(:chef_run) do
    # ...
  end

  before :each do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
      .with('cookbook::user')
  end

  it 'includes the ::user recipe' do
    # ...
  end
end
```

Note the order of precedence - this is the catch-all, and then each recipe we want to whitelist is overriding the mock.

[rspec-mocks]: https://github.com/rspec/rspec-mocks
