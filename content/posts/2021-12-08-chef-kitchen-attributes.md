---
title: "Converting a Kitchen YAML to Chef Attributes"
description: "How to convert attributes being set for your Chef Test Kitchen integration tests to an `attributes.rb` format."
tags:
- blogumentation
- chef
- test-kitchen
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-08T21:40:47+0000
slug: "chef-kitchen-attributes"
image: /img/vendor/chef-logo.png
---
_This is an article that's been [on the backlog for four and a half years](https://gitlab.com/jamietanna/jvt.me/-/issues/171), so I thought I should get around to actually writing it. Apologies if the context isn't quite right, as I'm trying to remember what I can for why we needed this._

You're hopefully testing your Chef cookbooks with [Test Kitchen](https://kitchen.ci) as part of [a set of sufficient test coverage](https://www.jvt.me/posts/2018/09/04/tdd-chef-cookbooks-chefspec-inspec/).

You may be finding that you've got your Test Kitchen's suites set up with a nice set of attributes that you want to move into your cookbook's `attributes/` directory, but need some way to programmatically convert it, instead of doing it by hand.

(I won't recommend this (see also [_Chef Attributes and `default.rb` - it's in the name_](https://www.jvt.me/posts/2019/11/07/chef-default-attributes/)), but this is what we were doing, and we needed a straightforward way to convert the two)

Let's take the following `kitchen.yml`:

```yaml
# ...
suites:
  - name: default
    run_list:
      - recipe[cookbook-spectat::default]
    attributes:
      spectat:
        authorized_keys: ['fake-ssh-public-key']
  # ...
  # more suites
  # ...
  - name: web-review-apps
    run_list:
      - recipe[cookbook-spectat::site]
    provisioner:
      client_rb:
        environment: staging
    attributes:
      spectat:
        site_fqdn: 'longfqdnwww.spectatdesigns.co.uk'
        admin_user: 'root'
        web_user: 'root'
        review_apps: true
        site_type: 'static'
        dns:
          api_key: 'fakeAPIkey'
        tls:
          strategy: 'self_signed'
  - name: web-docker
    run_list:
      - recipe[cookbook-spectat::site]
    attributes:
      spectat:
        site_fqdn: 'longfqdnwww.spectatdesigns.co.uk'
        admin_user: 'root'
        web_user: 'root'
        docker: true
        site_type: 'static'
        dns:
          api_key: 'fakeAPIkey'
        tls:
          strategy: 'self_signed'
        not_set: null
```

Then with the following script:

```ruby
require 'yaml'

def keys_to_attributes(keys)
  acc = %w[default]
  acc << keys.map { |k| "['#{k}']" }
  acc.join ''
end

def output_hash(previous_keys, hash)
  hash.each do |k, v|
    keys = previous_keys.dup << k
    if v.is_a? Hash
      output_hash(keys, v)
    else
      puts "#{keys_to_attributes(keys)} = #{v.inspect}"
    end
  end
end

doc = YAML.load_file ARGV[0]
suite_name = ARGV[1] || 'default'

suite = doc['suites'].find { |s| s['name'] == suite_name }

raise "Suite `#{suite_name}` not found" if suite.nil?

output_hash([], suite['attributes'])
```

Which we can then execute like so:

```sh
# to use the `default` suite
$ ruby ktoa.rb kitchen.yml
# to use a specific suite
$ ruby ktoa.rb kitchen.yml web-docker
```

Which outputs the following when executing against `web-docker`:

```ruby
default['spectat']['site_fqdn'] = "longfqdnwww.spectatdesigns.co.uk"
default['spectat']['admin_user'] = "root"
default['spectat']['web_user'] = "root"
default['spectat']['docker'] = true
default['spectat']['site_type'] = "static"
default['spectat']['dns']['api_key'] = "fakeAPIkey"
default['spectat']['tls']['strategy'] = "self_signed"
default['spectat']['not_set'] = nil
```
