---
title: "Chef 14 Upgrade: Change in `ValidationFailed` error messages when setting `required` properties"
description: The updated error message returned by a Chef `ValidationFailed` error, when you're specifying which properties are `required` on a custom resource.
categories:
- blogumentation
- chef-14-upgrade
tags:
- blogumentation
- chef-14-upgrade
- chef
- chefspec
- chef-14
image: /img/vendor/chef-logo.png
date: 2018-11-12T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-14-required-property-validation-errors
---
While upgrading one of my cookbooks to Chef 14.5.33 (ChefDK 3.3.23), I noticed some test failures around the title of exceptions raised by Chef's validation on `required` properties within custom resources.

I had this issue where I had a `caddy` resource:

```ruby
resource_name :caddy
provides :caddy

property :site_type, String, required: true
```

And the following spec:

```ruby
describe '...' do
  context 'When site type is an empty string' do
    # ...

    it 'throws an error' do
      expect { chef_run.converge(described_recipe) }.to\
        raise_error(Chef::Exceptions::ValidationFailed, %r{site_type is required})
    end
  end
end
```

This would unfortunately fail the ChefSpec run, with the following error:

```
1) cookbook-spectat::_caddy_resource When no site type is set throws an error
   Failure/Error:
     expect { chef_run.converge(described_recipe) }.to\
       raise_error(Chef::Exceptions::ValidationFailed, %r{site_type is required})

     expected Chef::Exceptions::ValidationFailed with message matching /site_type is required/, got #<Chef::Exceptions::ValidationFailed: site_type is a required property>
       # /tmp/d20181112-30712-qz3b7a/cookbooks/cookbook-spectat/recipes/_caddy_resource.rb:39:in `block in from_file'
       # /tmp/d20181112-30712-qz3b7a/cookbooks/cookbook-spectat/recipes/_caddy_resource.rb:37:in `from_file'
       # ./spec/unit/resources/caddy_spec.rb:402:in `block (4 levels) in <top (required)>'
       # ./spec/unit/resources/caddy_spec.rb:402:in `block (3 levels) in <top (required)>'
   # ./spec/unit/resources/caddy_spec.rb:402:in `block (3 levels) in <top (required)>'
```

This was odd, as running in Chef 13.6.4 (ChefDK 2.4.17) worked successfully.

As the error suggests, it's due to a change in the error's message, which is resolved with the very straightforward change:

```diff
 describe 'cookbook-spectat::_caddy_resource' do
   context 'When site type is an empty string' do
     # ...

     it 'throws an error' do
       expect { chef_run.converge(described_recipe) }.to\
-         raise_error(Chef::Exceptions::ValidationFailed, %r{site_type is required})
+         raise_error(Chef::Exceptions::ValidationFailed, %r{site_type is a required property})
     end
   end
 end
```
