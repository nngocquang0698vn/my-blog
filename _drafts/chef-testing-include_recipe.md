---
layout: post
title: 'Testing `include_recipe`s with Chef and Chefspec'
description: TODO
categories: finding
tags: finding chef tdd chefspec
---
While writing cookbooks, I practice heavy use of TDD.

I'll often have a test, such as:

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

## Ensuring dependent recipes don't get run

**Firstly, this will _actually_ run the other recipe, meaning that you will need to set given attributes so the recipe works (TODO - check)**

When you're running chefspec, you're effectively running the recipes as they would.

This means that any `include_recipe`s will also run that recipe, meaning that you will need to set any given attributes, and have anything else in place for the recipe to run.

Therefore, we need to **mock** out as much as possible, to **??**.

This can be done by adding a `before :each` block:

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


## Defensive `include_recipe`s

However, if we have this running, it won't flag up `include_recipe` being called on any other recipes that we've not predicted in our tests. Yes, this should be more obvious when practicing TDD, but it **???**.

**Secondly, it won't help us stop any future recipes being included (and therefore hitting this) or not being covered by tests**
