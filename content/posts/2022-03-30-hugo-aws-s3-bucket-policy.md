---
title: "Creating a minimal AWS S3 Bucket Policy for deploying with Hugo via `hugo\
  \ deploy`."
description: "How to configure an AWS S3 Bucket for `hugo deploy` with the minimal\
  \ access required for a role to write objects to."
date: "2022-03-30T17:17:58.907886854Z"
syndication:
- "https://twitter.com/JamieTanna/status/1509220124116590600"
tags:
- "blogumentation"
- "aws"
- "hugo"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/445ff8a8fc.png"
slug: "hugo-aws-s3-bucket-policy"
---
Similar to my post about [automating deployments to AWS using the Architect Framework and GitLab CI](https://www.jvt.me/posts/2022/03/30/architect-aws-gitlab-ci/), I've been looking at migrating the deployment for this site to a more granular role.

Although I could use something like [IAM Access Analyser](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html), I decided that I would try and hand-crank the policy, as a nice AWS refresher.

I've come up with the following S3 Bucket Policy, for the bucket `www-jvt-me`, so the role `WwwJvtMeServiceRole` can deploy:

```json
{
	"Version": "2012-10-17",
	"Id": "Policy1611348323526",
	"Statement": [
		{
			"Sid": "PublicReadAccess",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::www-jvt-me/*"
		},
		{
			"Sid": "ListBucket",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::<redacted>:role/WwwJvtMeServiceRole"
			},
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::www-jvt-me"
		},
		{
			"Sid": "ListBucketObjects",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::<redacted>:role/WwwJvtMeServiceRole"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::www-jvt-me/*"
		},
		{
			"Sid": "ModifyObjectsInBucket",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::<redacted>:role/WwwJvtMeServiceRole"
			},
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::www-jvt-me/*"
		}
	]
}
```

Notice that this requires both `PutObject` and `DeleteObject`, as we need to be able to add and delete files from the bucket.

This can be used by an IAM role that has no permissions policies configured, and could i.e. use OpenID Connect to allow assumption of the role, or be used by something like an EC2/Lambda role.
