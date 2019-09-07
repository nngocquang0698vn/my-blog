---
title: "Merging an 'Override' Ruby Hash into the Original Hash"
description: "How to use Ruby to merge two hashes with nested arrays of hashes, with the second hash overriding values from the first."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-07T22:36:36+0100
slug: "ruby-override-merge-nested-array-hash"
---
I have a very specific use case for this, so feel free to discount this if it doesn't make much sense to you.

I'm using Chef to configure a Java JAR file for a few of my personal backend services. I have a few differences between my local testing environment and production, such as the secrets being used and the path to the JAR to be deployed.

I want to make it possible to configure these differences in the least amount of JSON.

For instance, the current Chef JSON file has a large set of configuration in it (trimmed for brevity):

```json
{
  "jar": {
    "user": "jar",
    "group": "jar",
    "directory": "/var/jar",
    "jar_uri": "https://repo.remote.example.com/jar.jar",
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "vault_path": "jar/gitlabApiKey",
        "type": "String"
      },
      {
        "name": "indieAuth.accessToken",
        "vault_path": "jar/indieAuthAccessToken",
        "type": "String"
      }
    ]
  },
  "run_list": [
    "jar-deploy-cookbook::default"
  ]
}
```

I'd love a way to utilise the pre-built JSON file, but provide an ability to override this config, in such a way:

```json
{
  "jar": {
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "hardcoded_secret": "too-easy-to-guess"
      },
      {
        "name": "indieAuth.accessToken",
        "hardcoded_secret": "fakeyMcFakerson"
      }
    ]
  }
}
```

This is because I'm lazy and don't want to repeat all the JSON config, but I also want to keep it as close to the production config, removing any risk of configuration drift. But there are some difficulties with trying to override these nested bits of configuration, as I don't want to have to repeat all the properties of a given nested Hash i.e. the `type` for each secret.

So my requirements are:

- allow me to override certain fields within a Hash
- support Hashes nested within arrays (all the way down!)
- allow me to completely override an array if possible
- allow me to pass a `null` for a given key

# The code

So how do we do this? We apply [this StackOverflow answer](https://stackoverflow.com/a/30225093), but tweak this quite a bit, so we can work with the above requirements:

```ruby
class ::Hash
  def deep_merge_override(second)
    merger = proc do |key, original, override|
      if original.instance_of?(Hash) && override.instance_of?(Hash)
        original.merge(override, &merger)
      else
        if original.instance_of?(Array) && override.instance_of?(Array)
          # if the lengths are different, prefer the override
          if original.length != override.length
            override
          else
            # if the first element in the override's Array is a Hash, then we assume they all are
            if override[0].instance_of?(Hash)
              original.map.with_index do |v, i|
                # deep merge everything between the two arrays
                original[i].merge(override[i], &merger)
              end
            else
              # if we don't have a Hash in the override,
              # override the whole array with our new one
              override
            end
          end
        else
          override
        end
      end
    end
    self.merge(second.to_h, &merger)
  end
end
```

<details>
<summary>Diff between the two files</summary>

If it's more helpful, here's the diff:

```diff
 class ::Hash
   def deep_merge_override(second)
     merger = proc do |key, original, override|
       if original.instance_of?(Hash) && override.instance_of?(Hash)
         original.merge(override, &merger)
       else
         if original.instance_of?(Array) && override.instance_of?(Array)
-          original | override
-        else
-          if [:undefined, nil, :nil].include?(override)
-            original
-          else
+          # if the lengths are different, prefer the override
+          if original.length != override.length
             override
+          else
+            # if the first element in the override's Array is a Hash, then we assume they all are
+            if override[0].instance_of?(Hash)
+              original.map.with_index do |v, i|
+                # deep merge everything between the two arrays
+                original[i].merge(override[i], &merger)
+              end
+            else
+              # if we don't have a Hash in the override,
+              # override the whole array with our new one
+              override
+            end
           end
+        else
+          override
         end
       end
     end
     self.merge(second.to_h, &merger)
   end
 end
-
```
</details>

# Testing

So how does this actually do? Does this handle the scenarios we want? (Spoiler alert: yes!) Let's go through the scenarios I wanted.

## Overriding certain fields

If I want to override the user, I would have the following `override.json`:

```json
{
  "jar": {
    "user": "foobar"
  }
}
```

Then we can see this overrides just the user property:

```json
{
  "jar": {
    "user": "foobar",
    "group": "jar",
    "directory": "/var/jar",
    "jar_uri": "https://repo.remote.example.com/jar.jar",
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "vault_path": "jar/gitlabApiKey",
        "type": "String"
      },
      {
        "name": "indieAuth.accessToken",
        "vault_path": "jar/indieAuthAccessToken",
        "type": "String"
      }
    ]
  },
  "run_list": [
    "jar-deploy-cookbook::default"
  ]
}
```

## Completely Override an Array

To override the Chef recipes for this run:

```json
{
  "run_list": [
    "spectat::local",
    "jar-deploy-cookbook::default"
  ]
}
```

Which leaves everything else untouched:

```json
{
  "jar": {
    "user": "jar",
    "group": "jar",
    "directory": "/var/jar",
    "jar_uri": "https://repo.remote.example.com/jar.jar",
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "vault_path": "jar/gitlabApiKey",
        "type": "String"
      },
      {
        "name": "indieAuth.accessToken",
        "vault_path": "jar/indieAuthAccessToken",
        "type": "String"
      }
    ]
  },
  "run_list": [
    "spectat::local",
    "jar-deploy-cookbook::default"
  ]
}
```

## Nested Hash Arrays

The most important scenario is being able to override a specific field in a Hash within an Array. For instance, if I want to specify that the secret should be hardcoded, not via Vault:

```json
{
  "jar": {
    "secrets": [
      {
        "vault_path": null,
        "hardcoded_secret": "too-easy-to-guess"
      },
      {
        "vault_path": null,
        "hardcoded_secret": "fakeyMcFakerson"
      }
    ]
  }
}
```

Note that the ordering here is important, and needs to align with the secrets in the existing configuration. We don't need to put all the fields, just the ones we want to override.

In this case, we want to unset the `vault_path` in each (which the cookbook ignores if it is `null`), and add a new field `hardcoded_secret`.

This gives us the result:

```json
{
  "jar": {
    "user": "jar",
    "group": "jar",
    "directory": "/var/jar",
    "jar_uri": "https://repo.remote.example.com/jar.jar",
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "vault_path": "jar/gitlabApiKey",
        "type": "String"
      },
      {
        "name": "indieAuth.accessToken",
        "vault_path": "jar/indieAuthAccessToken",
        "type": "String"
      }
    ]
  },
  "run_list": [
    "jar-deploy-cookbook::default"
  ]
}
```

# Symbols and Strings

However, there was something I didn't expect. I'm not overriding this with a separate JSON file, but am instead overriding this configuration using a Ruby Hash in my `Vagrantfile`. This is loaded in a way similar to:

```ruby
require 'json'

original = JSON.parse(File.read './original2.json')

override = {
  jar: {
    secrets: [
      {
        vault_path: nil,
        hardcoded_secret: 'too-easy-to-guess'
      },
      {
        vault_path: nil,
        hardcoded_secret: 'fakeyMcFakerson'
      }
    ]
  }
}

merged = original.deep_merge_override(override)
```

This gives us the puzzling output below, which has two `jar` hashes:

```json
{
  "jar": {
    "user": "jar",
    "group": "jar",
    "directory": "/var/jar",
    "jar_uri": "https://repo.remote.example.com/jar.jar",
    "secrets": [
      {
        "name": "gitlab.apiKey",
        "vault_path": "jar/gitlabApiKey",
        "type": "String"
      },
      {
        "name": "indieAuth.accessToken",
        "vault_path": "jar/indieAuthAccessToken",
        "type": "String"
      }
    ]
  },
  "run_list": [
    "jar-deploy-cookbook::default"
  ],
  "jar": {
    "secrets": [
      {
        "vault_path": null,
        "hardcoded_secret": "too-easy-to-guess"
      },
      {
        "vault_path": null,
        "hardcoded_secret": "fakeyMcFakerson"
      }
    ]
  }
}
```

This will likely fail the Chef run, or at least confuse it, or even worse it'll silently work until an underlying change in the JSON parser.

The solution here is to follow the instructions in my post [_Converting Ruby Hash keys to Strings/Symbols_]({{< ref "2019-09-07-ruby-hash-keys-string-symbol" >}}), making sure that we stringify all the keys, so they get merged correctly.
