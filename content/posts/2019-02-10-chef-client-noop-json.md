---
title: "Performing a No-Op with `chef-client` using JSON"
description: "How to perform a `chef-client` run without executing anything."
categories:
- blogumentation
- chef
tags:
- blogumentation
- chef
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-02-10T22:33:40+00:00
slug: "chef-client-noop-json"
image: /img/vendor/chef-logo.png
---
There could be a case where you _may_ want to perform a `chef-client` run so it doesn't actually change any resources.

I previously wanted to do this, but encountered a bit of a funny gotcha, so decided to document it.

Let us assume that our regular cookbook JSON configuration is:

```json
{
  "java": {
    "jdk_version": 7
  },
  "run_list": [
    "java"
  ]
}
```

Which performs the following `chef-client` run:

```sh
$ chef-client -j full-run.json
Starting Chef Client, version 13.6.4
resolving cookbooks for run list: ["java"]
Synchronizing Cookbooks:
  - java (3.2.0)
  - windows (5.2.3)
  - homebrew (5.0.8)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 7 resources
Recipe: java::notify
  * log[jdk-version-changed] action nothing (skipped due to action :nothing)
Recipe: java::openjdk
  * apt_repository[openjdk-r-ppa] action add
    ...
Running handlers:
Running handlers complete
Chef Client finished, 5/12 resources updated in 04 minutes 04 seconds
```

# Expected Solution

The no-op configuration I tried at first was, as simple as I could think, an empty JSON object:

```json
{}
```

But unfortunately that doesn't quite work:

```sh
$ chef-client -j noop.json
Starting Chef Client, version 13.6.4
resolving cookbooks for run list: ["java"]
Synchronizing Cookbooks:
  - java (3.2.0)
  - windows (5.2.3)
  - homebrew (5.0.8)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 7 resources
Recipe: java::notify
  * log[jdk-version-changed] action nothing (skipped due to action :nothing)
Recipe: java::openjdk
  * apt_repository[openjdk-r-ppa] action add
    ...
Recipe: java::set_java_home
  * directory[/etc/profile.d] action create (up to date)
  * template[/etc/profile.d/jdk.sh] action create (up to date)

Running handlers:
Running handlers complete
Chef Client finished, 0/11 resources updated in 06 seconds
```

# Actual Solution

Instead, we need to have an empty JSON object with a zero-length `run_list`:

```json
{
  "run_list": []
}
```

This then gives us a true no-op:

```sh
$ chef-client -j real-noop.json
Starting Chef Client, version 13.6.4
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 0 resources

Running handlers:
Running handlers complete
Chef Client finished, 0/0 resources updated in 01 seconds
```
