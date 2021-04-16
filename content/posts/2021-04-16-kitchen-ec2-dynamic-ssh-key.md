---
title: "Using Dynamically Generated Non-AWS Owned SSH Keys with Test Kitchen on EC2"
description: "How to set up kitchen-ec2 to use an SSH key that isn't available in AWS by amending the `user-data` of the created EC2 instance."
date: 2021-04-16T17:21:18+0100
tags:
- "blogumentation"
- "chef"
- "test-kitchen"
- "aws"
- "ssh"
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "kitchen-ec2-dynamic-ssh-key"
image: /img/vendor/chef-logo.png
---
As I've mentioned recently, I'm working on rebuilding our Chef pipelines at work.

Although I'm a huge fan of [unit testing cookbooks using ChefSpec]({{< ref 2018-09-04-tdd-chef-cookbooks-chefspec-inspec >}}), there's also a really important place for integration tests. As AWS is the target for our cookbooks, we need to validate against an EC2 to confirm that our cookbook actually works for real-world solutions.

When interacting with AWS from Test Kitchen using [kitchen-ec2](https://github.com/test-kitchen/kitchen-ec2/), we need to be able to SSH into the instance so we can set up the instance, and then execute the cookbook.

kitchen-ec2 has the ability to create on-demand SSH keys for this purpose, but it's not always possible as it requires the user/role you're executing under to be able to create these keys, which may not be possible in your environment.

The solution I've found that works best for this is to generate them dynamically, inserting them into the `user_data` of the instance, as alluded to by the [README of kitchen-ec2](https://github.com/test-kitchen/kitchen-ec2/blob/master/README.md):

> This will not directly associate the EC2 instance with an AWS-managed key pair (pre-existing or auto-generated). This may be useful in environments that have disabled AWS-managed keys. Getting SSH keys onto the instance then becomes an exercise for the reader, though it can be done, for example, with scripting in `user_data` or if the credentials are already baked into the AMI.

Doing it this way makes sure that we don't need to bake a key into the AMI, as well as not juggling a shared key, and even though it's likely a development account, this reduces the attack surface by having one time usage keys.

This solution was also aimed at making it easiest for local development and code review, so I wanted to make sure that the user data wasn't embedded in the `kitchen.yml` because I didn't want it duplicated across each of the platforms used, and I also wanted syntax highlighting.

I'd tried using `kitchen.yml`'s ERB templating to try and read a file during parsing, but found it a bit awkward, and hard to read, so instead settled on a script to prepare a `user_data.sh` which would then be used as such:

```yaml
platforms:
- name: amzl2
  driver:
    name: ec2
    user_data: ./user_data.sh
```

The `user_data.sh` would be generated from the following ERB template:

```sh
#!/usr/bin/env sh
echo 'Defaults:ec2-user !requiretty' > /etc/sudoers.d/ec2-user
mkdir -m 0700 -p ~ec2-user/.ssh
echo '<%= public_key %>' >> ~ec2-user/.ssh/authorized_keys
chmod 0600 ~ec2-user/.ssh/authorized_keys
```

To actually render this, we have a simple wrapper script, `prepare.rb`:

```ruby
#!/usr/bin/env ruby
require 'erb'

user_data = File.read(ARGV[0])
public_key = File.read(ARGV[1])
erb = ERB.new(user_data)
result = erb.result(binding)

File.open(ARGV[2], 'w') { |f| f.write result }
```

This then leads to the following set of commands to actually execute Test Kitchen:

```sh
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''
prepare.rb user_data.sh.erb ~/.ssh/id_rsa.pub user_data.sh
kitchen test # ...
```

And there we have it - one-use SSH keys!
