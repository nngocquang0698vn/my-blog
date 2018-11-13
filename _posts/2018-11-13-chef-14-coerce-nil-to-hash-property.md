---
layout: post
title: "Chef 14 Upgrade: Custom Resource Properties are Silently Coerced to `Hash` if they are a `nil`"
description: Finding out that a `nil` gets silently coerced to an empty `Hash` if given to a custom resource's property of type `Hash`.
categories: blogumentation chef-14-upgrade
tags: chef-14 chef-14-upgrade chefspec test-coverage
no_toc: true
image: /assets/img/vendor/chef-logo.png
---
While [upgrading to Chef 14](/posts/tags/chef-14-upgrade/), I found that `nil`s are being silently coerced to an empty `Hash`, `{}`.

This can be seen where we have the following resource, ensuring that the provided `tls_options` is a `Hash`:

```ruby
resource_name :caddy
provides :caddy
property :tls_options, Hash, default: {}
```

I originally had two test cases which would expect Chef to throw a `ValidationFailed` error if given a string or a `nil`:

```ruby
describe 'cookbook-spectat::_caddy_resource' do
  context 'When TLS options are specified' do
    context 'as a string, not a Hash' do
      # ...

      it 'throws an error' do
        expect { chef_run.converge(described_recipe) }.to\
          raise_error(Chef::Exceptions::ValidationFailed, %r{Property tls_options must be one of: Hash})
      end
    end

    context 'as a nil, not a Hash' do
      # ...

      it 'throws an error' do
        expect { chef_run.converge(described_recipe) }.to\
          raise_error(Chef::Exceptions::ValidationFailed, %r{Property tls_options must be one of: Hash})
      end
    end
  end
end
```

However, when running it with Chef 14.5.33 (ChefDK 3.3.23), I noticed the test fails when we provide a `nil`:

```
1) cookbook-spectat::_caddy_resource When TLS options are specified as a nil, not a Hash throws an error
   Failure/Error:
     expect { chef_run.converge(described_recipe) }.to\
       raise_error(Chef::Exceptions::ValidationFailed, %r{Property tls_options must be one of: Hash})

     expected Chef::Exceptions::ValidationFailed with message matching /Property tls_options must be one of: Hash/ but nothing was raised
   # ./spec/unit/resources/caddy_spec.rb:1023:in `block (4 levels) in <top (required)>'
```

If we add some debugging in our resource we can see that `tls_options` is actually set to `{}`, rather than the `nil` that's provided to it.

This may not cause you any issues, but it may help you remove some dead logic to handle the `nil` case.
