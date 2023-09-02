---
title: "Setting up your Maven `settings.xml` to release a Jenkins plugin"
description: "How to set up your crdentials to release a Jenkins plugin via Maven."
tags:
- blogumentation
- jenkins
- maven
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-09-02T21:12:43+0100
slug: jenkins-plugin-release
image: https://media.jvt.me/0318664e33.png
---
I'm technically a maintainer for the Jenkins Job DSL Plugin. I say technically because I've not been able to spend as much time on it since picking up maintenance, especially as no longer doing much Jenkins or JVM development. But today I picked up doing a release, and as it's the first time since the excellent <span class="h-card"><a class="u-url" href="https://basilcrow.com/"></a></span> refreshed the plugin, migrating it from Gradle to Maven, I'd ended up needing to do a little setup first.

While trying to release, I saw an error like:

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-deploy-plugin:3.1.1:deploy (default-deploy) on project job-dsl-parent: Failed to deploy artifacts: Could not transfer artifact org.jenkins-ci.plugins:job-dsl-parent:pom:... from/to maven.jenkins-ci.org (https://repo.jenkins-ci.org/snapshots/): authentication failed for https://repo.jenkins-ci.org/snapshots/org/jenkins-ci/plugins/job-dsl-parent/1.86-SNAPSHOT/job-dsl-parent-....pom, status: 401 Unauthorized -> [Help 1]
```

This was because my Maven `settings.xml` wasn't configured to push to the Jenkins Maven repository, which required the following in `~/.m2/settings.xml`:

```xml
<settings>
  <servers>
    <server>
      <id>maven.jenkins-ci.org</id>
      <username>{TODO}</username>
      <password>{TODO}</password>
    </server>
  </servers>
</settings>
```

These are the credentials you use to log into Jenkins' JIRA or Jenkins.
