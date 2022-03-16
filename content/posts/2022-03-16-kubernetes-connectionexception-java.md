---
title: "Solving `ConnectException`s with the Kubernetes Java `ApiClient`"
description: "How I solved `ConnectException`s in my Kubernetes Java client usage, by moving to cluster mode."
tags:
- blogumentation
- kubernetes
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-16T17:51:38+0000
slug: "kubernetes-connectionexception-java"
image: https://media.jvt.me/735ffcb6bd.png
syndication:
- "https://brid.gy/publish/twitter"
---
As mentioned in [_Things I Learned Migrating My Personal APIs To Kubernetes_](https://www.jvt.me/posts/2021/10/25/kubernetes-migration/#kubernetes-api-client-configuration-issues), I had an issue plaguing my Kubernetes configuration which was causing any interactions with the API to fail.

The most frustrating thing about it was that it was inconsistent, meaning that between cluster patching there were some periods of time it worked and some it failed.

The error I was seeing was a `ConnectException`:

```json
{
  "@timestamp": "2021-09-28T08:00:00.482+00:00",
  "@version": 1,
  "exception": {
    "exception_class": "java.lang.IllegalStateException",
    "exception_message": "io.kubernetes.client.openapi.ApiException: java.net.ConnectException: Failed to connect to localhost/[0:0:0:0:0:0:0:1]:80",
    "stacktrace": "java.lang.IllegalStateException: io.kubernetes.client.openapi.ApiException: java.net.ConnectException: Failed to connect to localhost/[0:0:0:0:0:0:0:1]:80\n\tat me.jvt.www.indieauthcontroller.store.kubernetes.KubernetesSecretTokenStore.get(KubernetesSecretTokenStore.java:53)"
  },
  "level": "ERROR",
  "logger_name": "org.springframework.scheduling.support.TaskUtils$LoggingErrorHandler",
  "message": "Unexpected error occurred in scheduled task",
  "source_host": "google-fit-7bbcb4ddc7-n26qn",
  "thread_name": "scheduling-1"
}
```

I couldn't see what was causing this for quite some time, but today I managed to track it down to me using the default `ApiClient`:

```java
Config.defaultClient();
```

It appears that the way the default client was being built was picking up the wrong configuration, and authentication, and that I could instead force it to cluster-based configuration:

```java
Config.fromCluster();
```

This solved these issues, and now configures the API endpoint and authentication correctly!
