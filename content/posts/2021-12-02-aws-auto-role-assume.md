---
title: Automagically Assuming AWS Roles for EC2/ECS
description: How to set up your AWS infrastructure to automagically assume IAM roles.
tags:
- blogumentation
- aws
image: /img/vendor/AmazonWebservices_Logo.png
date: 2021-12-02T17:20:42+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: aws-auto-role-assume
---
If you're managing AWS infrastructure, it's very likely you're deploying services onto AWS EC2/ECS and using IAM roles to restrict the amount of access each instance has.

You may find that you're always assuming the same roles, and that to save time, you want to auto-assume the role.

Fortunately, you can set this up using the `role_arn` and `credential_source` parameters:

```sh
aws configure set role_arn ${DEPLOYER_ROLE_ARN}
# either of the below
aws configure set credential_source Ec2InstanceMetadata
aws configure set credential_source EcsContainer
```

Note that isn't always a good idea, as you may have lots of other roles to assume, so can't have a specific role as the primary one, or you may want to protect your infrastructure in the case of a breach, so don't want to fill in the gaps by providing a pre-filled role that an attacker could utilise.
