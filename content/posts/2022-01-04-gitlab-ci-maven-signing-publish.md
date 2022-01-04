---
title: "Publishing to Maven Repositories with GitLab CI, with Signed Artefacts"
description: "How to publish signed artefacts from a Gradle build to Maven repositories (such as Maven Central) when using GitLab CI."
tags:
- blogumentation
- gradle
- java
- gitlab-ci
- gpg
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-04T13:21:28+0000
slug: gitlab-ci-maven-signing-publish
image: https://media.jvt.me/c25b297eaa.png
---
# Preamble

I maintain a [number of Open Source projects](/open-source/), of which a handful are Java projects which are released to Maven Central for consumption by other users.

I utilise the [Sonatype OSSRH (OSS Repository Hosting)](https://central.sonatype.org/publish/publish-guide/) as the means to deploy to Maven Central more easily, which enforces checks before the artefact is published, such as all arefacts have a corresponding GPG signature.

It's a little awkward to perform a release locally, as even though I'm using the [Gradle Nexus Publish Plugin](https://github.com/gradle-nexus/publish-plugin), I still have to remind myself of the process, and make sure that my local machine is set up with all the right configuration.

I use GitLab and GitLab CI where possible, and couldn't find a lot of folks documenting how they'd managed to get a GitLab CI configuration working, so the artefacts could be signed and uploaded correctly, so in the spirit of [blogumentation](/posts/2017/06/25/blogumentation/), I thought I'd work out how to do it and document it.

# Prerequisites

Although I have a signing key that I'm currently using to release my libraries, I decided that continuing to use this key for CI purposes wasn't a good idea.

I followed [this article to set up a GPG sub-key](https://railslide.io/create-gpg-key-with-subkeys.html) to use this new sub-key for the purpose of automation.

## Current CI setup

Let's say that we've got the following `.gitlab-ci.yml`:

```yaml
image: openjdk:11

stages:
  - test

variables:
  # NOTE this is required to allow for caching, but isn't required for this
  # process to work. If you don't set this variable, you'll need to replace
  # references to `$GRADLE_USER_HOME` with `~/.gradle`
  GRADLE_USER_HOME: '.gradle'
  GIT_DEPTH: "0"  # Tells git to fetch all the branches of the project, required by the analysis task

cache:
  paths:
    - .gradle/wrapper
    - .gradle/caches

test:
  stage: test
  script:
    - ./gradlew clean build
    - ./gradlew sonarqube -Dsonar.qualitygate.wait=true
  only:
    - branches
    - merge_requests
```

## Setting up branch + tag protection

Because we're going to restrict the usage of the CI/CD secret variables to protected branches and tags, we need to make sure that any branches we're expecting to perform releases from are correctly set up in GitLab's UI, as well as setting up tag protection (which is a separate step).

If you don't have this set up, you may receive errors like:

<details>

<summary>Example GPG error when not running on a protected branch</summary>

```
$ gpg --pinentry-mode loopback --passphrase $GPG_PASSPHRASE --import $GPG_USER_KEY
gpg: directory '/root/.gnupg' created
gpg: keybox '/root/.gnupg/pubring.kbx' created
gpg: no valid OpenPGP data found.
gpg: Total number processed: 0
```

</details>

# Gradle Configuration

To use the GPG signing with the Gradle Nexus Publish Plugin, we need to set the following configuration in a `gradle.properties`, as per [the Gradle docs](https://docs.gradle.org/current/userguide/signing_plugin.html):

```ini
signing.gnupg.keyName=6B82211F5E150224CB970404DF7507BC5D21FAD0
signing.gnupg.passphrase=this-would-be-the-actual-passphrase
```

I also found that on the Docker image I was running, the GPG command was `gpg`, not `gpg2` which is the default, so I needed to add the following:

```ini
signing.gnupg.executable=gpg
```

# Finished Product

The solution I've come to is as follows, and allows limiting the secrets to protected branches and tags, and handles fully automated signing and publishing of artefacts.

You can see the final version of the pipeline below:

```yaml
image: openjdk:11

stages:
  - test
  - deploy

variables:
  # NOTE this is required to allow for caching, but isn't required for this
  # process to work. If you don't set this variable, you'll need to replace
  # references to `$GRADLE_USER_HOME` with `~/.gradle`
  GRADLE_USER_HOME: '.gradle'
  GIT_DEPTH: "0"  # Tells git to fetch all the branches of the project, required by the analysis task

cache:
  paths:
    - .gradle/wrapper
    - .gradle/caches

test:
  stage: test
  script:
    - ./gradlew clean build
    - ./gradlew sonarqube -Dsonar.qualitygate.wait=true
  only:
    - branches
    - merge_requests

deploy:
  stage: deploy
  before_script:
    - gpg --pinentry-mode loopback --passphrase $GPG_PASSPHRASE --import $GPG_USER_KEY
    - mkdir -p $GRADLE_USER_HOME
    - cat "$GRADLE_PROPERTIES" > $GRADLE_USER_HOME/gradle.properties
    - echo signing.gnupg.passphrase=$GPG_PASSPHRASE >> $GRADLE_USER_HOME/gradle.properties
  script:
    - ./gradlew publish closeAndReleaseSonatypeStagingRepository
  only:
    - main
    - tags
```

Which requires the following variables set in the GitLab UI:

<table>
  <tr>
    <th>Type</th>
    <th>Key</th>
    <th>Value</th>
    <th>Protected</th>
  </tr>
  <tr>
    <td>Variable</td>
    <td><code>GPG_PASSPHRASE</code></td>
    <td>(passphrase for the key)</td>
    <td><input type="checkbox" checked readonly></td>
  </tr>
  <tr>
    <td>File</td>
    <td><code>GPG_USER_KEY</code></td>
    <td>i.e. <code>gpg2 --armor --export-secret-keys 6B82211F5E150224CB970404DF7507BC5D21FAD0</code></td>
    <td><input type="checkbox" checked readonly></td>
  </tr>
  <tr>
    <td>File</td>
    <td><code>GRADLE_PROPERTIES</code></td>
    <td>the <code>gradle.properties</code> as mentioned above</td>
    <td><input type="checkbox" checked readonly></td>
  </tr>
  <tr>
    <td>Variable</td>
    <td><code>ORG_GRADLE_PROJECT_sonatypeUsername</code></td>
    <td>The password retrieved using your <a href="https://blog.solidsoft.pl/2015/09/08/deploy-to-maven-central-using-api-key-aka-auth-token/">User Token</a></td>
    <td><input type="checkbox" checked readonly></td>
  </tr>
  <tr>
    <td>Variable</td>
    <td><code>ORG_GRADLE_PROJECT_sonatypePassword</code></td>
    <td>The password retrieved using your <a href="https://blog.solidsoft.pl/2015/09/08/deploy-to-maven-central-using-api-key-aka-auth-token/">User Token</a></td>
    <td><input type="checkbox" checked readonly></td>
  </tr>
</table>

This now allows you to handily publish our binaries to Maven Central - [for example](https://gitlab.com/jamietanna/cucumber-reporting-plugin/-/pipelines/441127398).
