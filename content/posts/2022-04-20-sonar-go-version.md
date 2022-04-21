---
title: "Automagically setting the project version for Go projects in SonarQube"
description: "How to automagically set `sonar.projectVersion` for Go projects, based\
  \ on Git tags."
date: "2022-04-20T22:17:47+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1516890673995124736"
tags:
- "blogumentation"
- "go"
- "sonarqube"
- "gitlab-ci"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/d077306c09.png"
slug: "sonar-go-version"
---
On one of my recent Go side projects, [micropub-go](https://gitlab.com/jamietanna/micropub-go/), I've been using the wonderful SonarQube for visibility of code quality issues.

As my first real Go project, let alone first with SonarQube, it's been a bit of fun learning how to get it set up correctly with all the Go tools, but I've managed to get it into a good place.

However today, I noticed that my SonarQube quality scans showed ~800 lines of "New Code" since the previous release. This was odd, because the last release was a couple of hours prior, and there definitely wasn't that much code added.

It turns out that this is due to the way that SonarQube [cannot auto-detect](https://docs.sonarcloud.io/improving/new-code-definition/) the version of the project i.e. via Git tags.

This requires we manually set in our `sonar-project.properties`:

```ini
sonar.projectVersion=0.1
```

Unfortunately this means that to make a release, I'd have to bump the version in that file, instead of just doing a `git tag`, and I didn't really want to do that, and as there is no other way of tracking the version, I wanted to look at an alternative.

As I use GitLab CI, I came up with the following tweak, which sets the version dynamically:

```yaml
sonarcloud-check:
  stage: build
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  script:
    - .ci/set-version.sh # this is the new one
    - sonar-scanner
```

Based on the script `.ci/set-version.sh`:

```sh
#!/usr/bin/env bash
if [[ -n "$CI_COMMIT_TAG" ]]; then
  echo -e "\nsonar.projectVersion=$CI_COMMIT_TAG" >> sonar-project.properties
else
  echo -e "\nsonar.projectVersion=latest" >> sonar-project.properties
fi
```

Notice that this uses the `CI_COMMIT_TAG`, which is only set on tags, so we can make sure that the tag builds set quality scans for that specific version, and otherwise the `latest` is used for any other references.

This then correctly registers the "New Code" measurement, and gives visibility on issues introduced since the last Git tag.
