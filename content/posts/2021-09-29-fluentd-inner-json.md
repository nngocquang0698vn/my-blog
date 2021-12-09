---
title: "Setting up fluentd to Parse Nested JSON from Docker"
description: "How to configure fluentd to parse the inner JSON from a log message as JSON, for use with structured logging."
date: 2021-09-29T18:29:21+0100
tags:
- blogumentation
- fluentd
- logs
- docker
- kubernetes
- logz.io
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "fluentd-inner-json"
---
As I wrote about in [Migrating Your Spring Boot Application to use Structured Logging](/posts/2021/05/31/spring-boot-structured-logging/), structured logging is pretty great.

I've recently set up fluentd for Logz.io on Kubernetes, via their [super handy configuration](https://github.com/logzio/logzio-k8s), but wanted to make it work for the services I've got that produce JSON logs.

As these are running on Docker, the default fluentd configuration worked to pick up the logs themselves, it doesn't auto-parse the logs themselves as JSON.

Fortunately [okkez's answer on StackOverflow](https://stackoverflow.com/a/56388980) managed to solve this for me, with the following addition to the configuration.

```diff
     # diff is based from https://github.com/logzio/logzio-k8s/blob/c9fbf432e5aeeee333717b0c414487c55043a28b/configmap.yaml

     # This adds type to the log && change key log to message
     <filter **>
       @type record_modifier
       <record>
         type  k8s
         message ${record["log"]}
       </record>
       remove_keys log
     </filter>

+   # https://stackoverflow.com/a/56388980
+   <filter **>
+     @type parser
+     key_name message
+     reserve_data true
+     remove_key_name_field true
+     <parse>
+       @type multi_format
+       <pattern>
+         format json
+       </pattern>
+       <pattern>
+         format none
+       </pattern>
+     </parse>
+   </filter>
```

This now allows Logz.io to show a full log message, with top-level keys parsed into the log message itself.

And because we're using the [Multi format parser plugin](https://github.com/repeatedly/fluent-plugin-multi-format-parser), we're able to handle both plain-formatted logs and JSON ones, which is useful for cases that we've got a mix of log formats across our services being monitored.
