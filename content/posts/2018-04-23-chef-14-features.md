---
title: "Morsels of Goodness: What's Cooking in Chef 14?"
description: A look at the new features coming in the new Chef 14 release, as well as what to watch out for when upgrading.
categories: chef-14
tags: chef-14 chef foodcritic cookstyle rubocop ruby test-kitchen
image: /img/vendor/chef-logo.png
---
Update: I've also started to document [any interesting changes required for Chef 14](/posts/tags/chef-14-upgrade).

Last Wednesday, I was able to attend the [Chef Users UK] meetup where Chef Community Engineer [Thom May] came to talk about Chef 14 (and beyond):

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Tonight I’m talking about chef from the future… <a href="https://twitter.com/hashtag/chef?src=hash&amp;ref_src=twsrc%5Etfw">#chef</a> <a href="https://twitter.com/hashtag/cheffriends?src=hash&amp;ref_src=twsrc%5Etfw">#cheffriends</a> <a href="https://t.co/u8BBbIH7id">pic.twitter.com/u8BBbIH7id</a></p>&mdash; Thom May (@thommay) <a href="https://twitter.com/thommay/status/986665948991107082?ref_src=twsrc%5Etfw">18 April 2018</a></blockquote>

Although I've only recently gone through [Chef 13 upgrades], I hadn't yet had a chance to look at what was coming in Chef 14. This made it a great talk, as there was a great mix of what's coming, and the reasoning behind why.

## Notable News

Notable news (according to me):

- Chef 14 looks to be slightly more user friendly in terms of the errors it reports
- Ohai has better Azure support, and can now detect Scaleway
- Logging is low less verbose at the `:debug` level with the introduction of the `:trace` level
- Ruby 2.5 brings a 10% performance boost
- `yum_package` resource has been rewritten for increased speed and half the memory usage
- InSpec 2.0 brings a number of features, such as being able to audit your AWS and Azure resources
- Chef will now work to an annual release cadence

## New Resources in Chef Client

A tonne of new resources have been merged from the community cookbooks into the Chef core:

- `build_essential`
- Red Hat Subscription Management
- `sudo`
- Various Windows, Homebrew and Mac OSX-related resources

This means it's even easier to get up and running without needing (as many) community cookbooks.

## Fleet and Workstation Management

Chef has recently been doing some great work to make it a great platform for managing the machines in your fleet as well as the servers you deploy to, with big names like Facebook and Slack using it for managing their fleet.

As mentioned, Chef 14 pulls a lot of Windows and OSX-specific functionality from community cookbooks, which makes it even easier to get started without needing any additional cookbooks for standard configuration.

This will definitely help reduce the number of tools required to get managing your fleet, as well as building the same quality into your workstations as that of your servers.

## Making Deprecations Easier in Custom Resources

There are a few new ways to announce deprecations to users with Chef 14. Code snippets via [Chef 14 Release Notes][14-release-notes].

### Deprecating a Resource

```ruby
deprecated "The foo_bar resource has been deprecated and will be removed in the next major release of this cookbook scheduled for 12/25/2018!"

property :thing, String, name_property: true

action :create do
  # you'd probably have some actual chef code here
end
```

### Deprecating a Property without Migration Path

```ruby
property :thing2, String, deprecated: 'The thing2 property has been deprecated and will be removed in the next major release of this cookbook scheduled for 12/25/2018!'
```

### Deprecating a Property with a Migration Path

```ruby
deprecated_property_alias 'thing2', 'the_second_thing', 'The thing2 property was renamed the_second_thing in the 2.0 release of this cookbook. Please update your cookbooks to use the new property name.'
```

## Documenting Resources

As I've blogged about a number of times before, I use [`knife-cookbook-doc` gem][knife-cookbook-doc] to document my resources. However, it looks like Chef 14 may be making this easier, by allowing inline description for properties:

```ruby
description 'The apparmor_policy resource is used to add or remove policy files from a cookbook file'
introduced '14.1'

property :source_cookbook, String,
         description: 'The cookbook to source the policy file from'
property :source_filename, String,
         description: 'The name of the source file if it differs from the apparmor.d file being created'

action :add do
  description 'Adds an apparmor policy'

  # you'd probably have some actual chef code here
end
```

## Breaking Changes

It is worth reading through the full release notes on [Chef Docs website][14-release-notes], as they have a full list, however notable changes (according to me):

- `node['cloud']` has been replaced with details from `cloud_v2` Ohai plugin
- `node['filesystem']` has been replaced with details from `filesystem_v2` Ohai plugin
- Property names (i.e. `property :foo`)  in Custom Resources must be referenced with `new_resource.foo`:

```diff
 property :source_cookbook, String,
          description: 'The cookbook to source the policy file from'

 action :add do
   description 'Adds an apparmor policy'
-  puts source_cookbook
+  puts new_resource.source_cookbook
 end
```



## "Soon"

Thom mentioned we'll soon have semantic logging which will make it easier to both log, and filter, messages more easily.

ChefDK 3 will soon be out which includes many bugfixes and feature bumps for Chef development tools such as FoodCritic, Cookstyle/Rubocop, Test Kitchen, InSpec, and ChefSpec.

## Preparing for Chef 14

Thom mentioned that the best way to pre-warn upgrade issues is to configure the `provisioner` in Test Kitchen to raise an error if any deprecations are found (via [Chef Deprecation Warnings][testing-for-deprecations]):

```yaml
provisioner:
  deprecations_as_errors: true
```

This ensures that whenever running through Test Kitchen, new deprecations will be noticed as test suites will fail, while still running ChefDK 2.

Additionally, by regularly upgrading to new minor/patch versions, you'll be able to find new deprecation warnings as they are announced.

FoodCritic 13, included in ChefDK 3, will also start complaining about deprecation warnings to help reduce feedback time for determining breaking future breaking changes. Because this gem can be used on its own, you don't need to fully upgrade your ChefDK or Chef Client version to pick up new deprecations!

## Full Release Notes

The full release notes are documented on the [Chef Docs website][14-release-notes].

Additionally, Chef has released a [webinar on their YouTube channel][14-youtube] to help explain about the upgrade.

[Chef 13 upgrades]: /posts/tags/chef-13-upgrade/
[Thom May]: https://twitter.com/thommay
[Chef Users UK]: https://www.meetup.com/Chef-Users-London/events/249461424/
[14-release-notes]: https://docs.chef.io/release_notes.html#what-s-new-in-14-0
[testing-for-deprecations]: https://docs.chef.io/chef_deprecations_client.html#testing-for-deprecations
[14-youtube]: https://www.youtube.com/watch?v=nR90HNFc00Y&feature=youtu.be
