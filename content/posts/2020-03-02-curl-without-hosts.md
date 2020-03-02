---
title: "How to Use `curl` to Send Requests to Domains Without Editing Your `/etc/hosts` File"
description: "Using `curl`'s `--resolve` flag to perform custom lookup for hosts."
tags:
- blogumentation
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-02T21:49:40+0000
slug: "curl-without-hosts"
---
Sometimes you need to make requests to sites, but don't want to allow regular DNS lookups for the host. For instance, you may have a passive/side stack you need to test against, but can't get it working without the official DNS working.

Usually, the solution would be to update `/etc/hosts`, and hardcode the IP address. But that requires `root` privileges, and there's always the risk that you forget you made the change, resulting in pain in the future!

What we can do from curl v7.21.3 is use the `--resolve` flag, which allows forcing curl to not perform lookups, and instead use the IP address provided.

```
$ curl -i https://www.jvt.me --resolve www.jvt.me:443:167.99.129.42
```

Note that you need the port number in there!
