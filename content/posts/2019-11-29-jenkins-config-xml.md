---
title: "Viewing Jenkins Jobs' Configuration as XML"
description: "How to view the XML configuration for a given Jenkins job."
tags:
- blogumentation
- jenkins
- job-dsl
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-29T23:18:37+0000
slug: "jenkins-config-xml"
image: /img/vendor/jenkins.png
series: nablopomo-2019
---
Today I've been working with the [Jenkins Job DSL plugin](https://plugins.jenkins.io/job-dsl), which although great, doesn't provide native bindings for all the properties you'd want.

So I found myself needing to get the raw XML to then apply that using the `configure` block. I fortunately had the [Job Configuration History](https://plugins.jenkins.io/jobConfigHistory) plugin to provide the XML handily for me, but I wondered if there was something better.

It turns out that if you have the `Job/ExtendedRead` permission, you can simply browse to `/config.xml` on a given job. For instance

```
Job URL:   http://localhost:8080/job/production-deploy/
Conig URL: http://localhost:8080/job/production-deploy/config.xml
```

For some strange reason, it is not possible to set the permission in the Global Security Configuration UI, so you need the [Extended Read Permission plugin](https://plugins.jenkins.io/extended-read-permission) to expose it in the UI. An alternative is to have the `Confiure` permission, but this can be a bit more risky if you want to lock down the ability to change your jobs, especially if you want to be moving to purely Job configuration as code.

But do note that this has the potential to expose configuration or secrets that aren't stored in Jenkins' credentials management, or in a proper secrets management solution, as well job configuration details you do not wish to share.
