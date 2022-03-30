---
title: "Automagically deploying Architect Framework applications to AWS uisng GitLab\
  \ CI"
description: "How to use GitLab's OpenID Connect support with AWS, to allow deployment\
  \ using the Architect Framework automagically on GitLab CI."
date: "2022-03-30T15:17:18.082250086Z"
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "oidc"
- "architect-framework"
- "aws"
- "gitlab"
- "gitlab-ci"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/4bea95efe8.png"
slug: "architect-aws-gitlab-ci"
---
I have a number of services that I use the [Architect Framework](https://arc.codes), as it's _really_ handy for creating an event-based, multi-Lambda (HTTP) application.

Up until today, I've been manually deploying these from my local machine, which isn't ideal, as it means contributions from external contributors, or when I'm only able to access my phone, I can't get deployments released.

I'm a heavy user of GitLab and GitLab CI, and so I wanted to set up deployments as part of this.

One option is to add long-lived AWS access keys to GitLab CI, and regularly rotate them, but that's a bit of a pain.

With GitLab's recent support for [OpenID Connect Authentication](https://docs.gitlab.com/ee/ci/cloud_services/) for cloud services, we can avoid the need for long-lived credentials, and instead use the OpenID Connect support in AWS to allow us to grant limited access to jobs using an ID Token for a specific job.

This ID Token is stored in the `CI_JOB_JWT_V2` environment variable, and unpacks to the following sample payload:

```json
{
  "alg": "RS256",
  "kid": "4i3sFE7sxqNPOT7FdvcGA1ZVGGI_r-tsDXnEuYT4ZqE",
  "typ": "JWT"
}
{
  "namespace_id": "305304",
  "namespace_path": "jamietanna",
  "project_id": "34472568",
  "project_path": "jamietanna/opengraph-mf2",
  "user_id": "259647",
  "user_login": "jamietanna",
  "user_email": "gitlab@jamietanna.co.uk",
  "pipeline_id": "504771836",
  "pipeline_source": "push",
  "job_id": "2269345391",
  "ref": "feature/deploy",
  "ref_type": "branch",
  "ref_protected": "false",
  "jti": "e4e29fdd-0dee-4c9b-86c7-31eadcc28f72",
  "iss": "https://gitlab.com",
  "iat": 1648637774,
  "nbf": 1648637769,
  "exp": 1648641374,
  "sub": "project_path:jamietanna/opengraph-mf2:ref_type:branch:ref:feature/deploy",
  "aud": "https://gitlab.com"
}
```

Alongside [GitLab's documentation for AWS setup](https://docs.gitlab.com/ee/ci/cloud_services/aws/) as well as [the section on conditional role setup](https://docs.gitlab.com/ee/ci/cloud_services/index.html#configure-a-conditional-role-with-oidc-claims), we can produce the following IAM role Trust Policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<redacted>:oidc-provider/gitlab.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "gitlab.com:aud": "https://gitlab.com",
          "gitlab.com:sub": "project_path:jamietanna/opengraph-mf2:ref_type:branch:ref:main"
        }
      }
    }
  ]
}
```

As [noted in the Architect docs](https://arc.codes/docs/en/get-started/detailed-aws-setup#credentials), the role needs the `AdministratorAccess` managed policy associated with it.

This then allows the role to be assumed using the following GitLab CI snippet:

```yaml
- >
  STS=($(aws sts assume-role-with-web-identity
  --role-arn ${ARC_ROLE_ARN}
  --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
  --web-identity-token $CI_JOB_JWT_V2
  --duration-seconds 3600
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
  --output text))
- export AWS_ACCESS_KEY_ID="${STS[0]}"
- export AWS_SECRET_ACCESS_KEY="${STS[1]}"
- export AWS_SESSION_TOKEN="${STS[2]}"
# then, for example
- aws sts get-caller-identity
```

Note that `ARC_ROLE_ARN` is a protected and masked Variable in GitLab CI, for the role that has the Trust Policy noted above.

This allows us to then have the following GitLab CI setup:

```yaml
image: node:16

stages:
  - deploy

deploy:
  stage: deploy
  only:
    refs:
    - main
  before_script:
    # as it's not available in the Node image
    - apt update && apt install -y awscli
    # prepare for future steps
    - >
      STS=($(aws sts assume-role-with-web-identity
      --role-arn ${ARC_ROLE_ARN}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token $CI_JOB_JWT_V2
      --duration-seconds 3600
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text))
    - export AWS_ACCESS_KEY_ID="${STS[0]}"
    - export AWS_SECRET_ACCESS_KEY="${STS[1]}"
    - export AWS_SESSION_TOKEN="${STS[2]}"
  script:
    - npm install
    - npm exec arc deploy production
```
