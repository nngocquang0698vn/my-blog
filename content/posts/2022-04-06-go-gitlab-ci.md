---
title: "Setting up GitLab CI for Go projects"
description: "How to set up a basic set of automated builds for Go projects on GitLab\
  \ CI, for modern Go projects."
date: "2022-04-06T09:36:32+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1511625662683131909"
tags:
- "blogumentation"
- "go"
- "gitlab-ci"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-gitlab-ci"
---
As a heavy user of GitLab, I naturally want my Go projects to have an automated build/test process.

While looking to set this up, I've found that a lot of the articles online are pre-Go modules, and back when you needed to install things into `~/go/src`, which is no longer necessary.

A commonly followed practice in Go projects is to use `make` as a task runner, but in this case I've not yet found it necessary for the small personal projects.

This gives us the following CI configuration:

```yaml
image: golang:1.17

stages:
  - build

format:
  stage: build
  script:
    - test -z "$(gofmt -l ./)"

vet:
  stage: build
  script:
    - go vet -json ./... | tee vet-report.json
  artifacts:
    when: always
    paths:
      - vet-report.json
    expire_in: 1 hour

test:
  stage: build
  script:
    - go test -coverprofile=coverage.out -json ./... | tee test-report.json
  artifacts:
    when: always
    paths:
      - test-report.json
      - coverage.out
    expire_in: 1 hour

staticcheck:
  stage: build
  script:
    - go install honnef.co/go/tools/cmd/staticcheck@latest # ideally we should version pin
    - staticcheck ./...

golint:
  stage: build
  script:
    - go install golang.org/x/lint/golint@latest # ideally we should version pin
    - golint -set_exit_status

build:
  stage: build
  script:
    - go build ./...
  artifacts:
    # instead of manually adding i.e. the built binaries, we can instead just
    # grab anything not tracked in Git
    untracked: true
    expire_in: 1 hour

sonarcloud-check:
  stage: build
  needs:
    - job: test
      artifacts: true
    - job: vet
      artifacts: true
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
```
