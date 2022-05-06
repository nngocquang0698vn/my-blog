---
title: "Parsing AWS ALB/ELB access logs into SQLite"
description: "How to take a set of ALB/ELB logs and convert them to an SQLite database\
  \ for further processing."
date: "2022-05-06T07:49:13+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1522470759704272896"
tags:
- "blogumentation"
- "sqlite"
- "aws"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/770ef46545.png"
slug: "elb-alb-logs-sqlite"
---
When using AWS' Application Load Balancer (ALB)/Elastic Load Balancer (ELB), it's likely that at some point you'll want to perform some queries based on the [raw access logs](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html) that AWS can provide.

It may be you're looking for some requests coming through from a certain `User-Agent`, or you want to find out the distribution of TLS ciphers in use.

I was sitting down to start and write something to convert these, as I didn't fancy [using AWS Athena for the job](https://docs.aws.amazon.com/athena/latest/ug/application-load-balancer-logs.html).

Thinking I'd write a quick Go tool for it, I started by doing a cursory search online to see if anyone had a package that'd make interacting with SQLite easier, but I ended up finding a perfect solution for the problem, a [tool for this, `alblogs`](https://github.com/artyom/alblogs).

Not only does `alblogs` perform the translation of data to an SQLite database, but it also performs all the AWS calls for you, so you don't need to download bulk data, or calculate the path in the bucket you need.

For instance, we can query the `jvt.me` load balancer like so, which then drops us into an SQLite session, using a temporary location for the SQLite database:

```sh
./alblogs jvt.me
...
sqlite>
```

There are lots of handy CLI options, like specifying how many log files to look through.
