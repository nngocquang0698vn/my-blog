---
title: 'Getting around `Permission Denied` when running ChefSpec'
description: How to handle getting an `EACCES` when trying to run ChefSpec on a recipe.
categories:
- blogumentation
tags:
- blogumentation
- chef
- chefspec
- chefdk
image: /img/vendor/chef-logo.png
date: 2017-08-12T14:23:03+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: permission-denied-chefspec
---

You may find that when running ChefSpec on your Chef cookbook, you may hit an error such as the following, spouting `Permission denied`:

```
5) cookbook-spectat::piwik When attributes are set downloads the piwik zip from attribute
Failure/Error:
runner = ChefSpec::ServerRunner.new(platform: 'debian', version: '8.7') do |node|
	node.automatic['piwik']['artefact_url'] = 'https://piwik/1.2.3.zip'
end

Errno::EACCES:
Permission denied @ rb_sysopen - /opt/chefdk/embedded/lib/ruby/gems/2.3.0/gems/fauxhai-3.10.0/lib/fauxhai/platforms/debian/8.7.json
# ./spec/unit/recipes/piwik_spec.rb:12:in `new'
# ./spec/unit/recipes/piwik_spec.rb:12:in `block (3 levels) in <top (required)>'
# ./spec/unit/recipes/piwik_spec.rb:51:in `block (3 levels) in <top (required)>'
```

I've previously hit the issue when using the following Chef-DK version:

```
$ chef -v
Chef Development Kit Version: 1.2.22
chef-client version: 12.18.31
delivery version: master (0b746cafed65a9ea1a79de3cc546e7922de9187c)
berks version: 5.6.0
kitchen version: 1.15.0
```

However, this issue could occur at any point in time, with any Chef-DK version, and is due to how the Fauxhai gem works.

After investigating, I found that there actually wasn't a platform with that version on my machine:

```
$ ls -al /opt/chefdk/embedded/lib/ruby/gems/2.3.0/gems/fauxhai-3.10.0/lib/fauxhai/platforms/debian/
total 376
drwxr-xr-x 1 root root   322 Aug  5 21:10 .
drwxr-xr-x 1 root root   326 Aug  5 21:10 ..
-rw-r--r-- 1 root root  7128 Feb  2  2017 6.0.5.json
-rw-r--r-- 1 root root 14769 Feb  2  2017 7.0.json
-rw-r--r-- 1 root root 15855 Feb  2  2017 7.10.json
-rw-r--r-- 1 root root 16254 Feb  2  2017 7.11.json
-rw-r--r-- 1 root root 14769 Feb  2  2017 7.1.json
-rw-r--r-- 1 root root  9082 Feb  2  2017 7.2.json
-rw-r--r-- 1 root root  9539 Feb  2  2017 7.4.json
-rw-r--r-- 1 root root 91931 Feb  2  2017 7.5.json
-rw-r--r-- 1 root root 14691 Feb  2  2017 7.6.json
-rw-r--r-- 1 root root 15812 Feb  2  2017 7.7.json
-rw-r--r-- 1 root root 15824 Feb  2  2017 7.8.json
-rw-r--r-- 1 root root 16541 Feb  2  2017 7.9.json
-rw-r--r-- 1 root root 16576 Feb  2  2017 8.0.json
-rw-r--r-- 1 root root 16575 Feb  2  2017 8.1.json
-rw-r--r-- 1 root root 18542 Feb  2  2017 8.2.json
-rw-r--r-- 1 root root 18477 Feb  2  2017 8.4.json
-rw-r--r-- 1 root root 17951 Feb  2  2017 8.5.json
-rw-r--r-- 1 root root 17944 Feb  2  2017 8.6.json
drwxr-xr-x 1 root root    16 Aug  5 21:10 jessie
drwxr-xr-x 1 root root    16 Aug  5 21:10 stretch
```

As we can see here, there actually isn't an `8.7.json` file there. But that doesn't explain why we'd be getting an `EACCES` instead of a `ENOENT`, as the file doesn't exist.

By delving into the source of Fauxhai, I found that when Fauxhai detects you're trying to converge on a platform it doesn't have, [it'll try and download it][fauxhai-downloader-code]. This means that it'll be trying to save it into the directory mentioned. As it's executing as my user, `jamie`, it won't have write access, as the user and group of that folder is `root`. So that explains why we're now hitting an `EACCES` - it's downloaded the file, but can't actually write it!

In order to fix this, we can perform one of a two sensible options:

1. `sudo chown -R $USER /opt/chefdk/embedded/lib/ruby/gems/2.3.0/gems/fauxhai-3.10.0/lib/fauxhai/platforms/`
	- Make the current user owner of the folder
1. `sudo chgrp -R sudo /opt/chefdk/embedded/lib/ruby/gems/2.3.0/gems/fauxhai-3.10.0/lib/fauxhai/platforms/ && sudo chmod -R g+w /opt/chefdk/embedded/lib/ruby/gems/2.3.0/gems/fauxhai-3.10.0/lib/fauxhai/platforms/`
	- Make the `sudo` group owners of the folder
	- And then give them the access to actually write changes

With this done, next time we need to use a platform we don't have locally, Fauxhai will be able to write to the directory and will be able to spend a moment downloading the file(s) at the start of the test run.

[fauxhai-downloader-code]: https://github.com/chefspec/fauxhai/blob/v3.10.0/lib/fauxhai/mocker.rb#L59
