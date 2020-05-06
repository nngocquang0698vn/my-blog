---
title: "Gotcha: AWS SDK Proxy Setup with Test Kitchen"
description: "How to avoid odd proxy issues when using the AWS SDK, when using Test Kitchen."
tags:
- blogumentation
- chef
- test-kitchen
- proxy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-06T14:42:33+0100
slug: "aws-sdk-proxy-test-kitchen"
image: /img/vendor/test-kitchen-logo.png
---
I hit an interesting issue today while testing a cookbook, using Test Kitchen against an EC2, that interacts with the AWS SDK.

The cookbook reached out to the AWS APIs using the AWS SDK Ruby gem, and I was constructing the client as such:

```ruby
client = Aws::EC2::Client.new(
  region: region_name,
)
```

When reaching out to the EC2 APIs, I was receiving an error similar to:

```
Seahorse::Client::NetworkingError (Failed to open TCP connection to localhost:55555)
```

What's interesting here is that I run a proxy on my development machine, on port 55555. This immediately flagged up as something odd, because this is running on an EC2, so it shouldn't be trying to use my local proxy settings, but instead the proxy on the EC2, which has a different configuration.

You'll notice that when configuring the AWS SDK, I'm not specifying any details about the proxy, so how is it picking them up? When Test Kitchen executes, it will pass certain environment variables to the running instance, one of those being the proxy variables.

So that explains why the local proxy is trying to be used, but how do I specify them for the AWS environment it's in? We can use the `http_proxy` parameter:

```ruby
# via Ohai/self-specified attributes
client = Aws::EC2::Client.new(
  region: region_name,
  http_proxy: node['proxy']
)
```

This then resolved the issue, as the proxy was being used correctly, and the AWS didn't need to fall back to using the environment variable.
