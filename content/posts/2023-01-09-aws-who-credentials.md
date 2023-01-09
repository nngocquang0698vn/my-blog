---
title: "Who do these AWS credentials belong to?"
description: "How to work out whether arbitrary AWS credentials are valid, and if so, what account/role/user they're bound to."
date: 2023-01-09T11:37:09+0000
tags:
- blogumentation
- aws
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/770ef46545.png
slug: aws-who-credentials
---
Let's say you've found an `AWS_ACCESS_KEY_ID` and an `AWS_SECRET_ACCESS_KEY`, whether that's on your local machine's `~/.aws/credentials`, in your project's environment variables, etc - the important next question is "are these still active, and if so what access do they have?".

Fortunately you can use [`aws sts get-caller-identity`](https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html) to do this, for instance:

```sh
env AWS_ACCESS_KEY_ID='XN...' AWS_SECRET_ACCESS_KEY='fpQ...' aws sts get-caller-identity
```

This then outputs, for instance::

```json
{
    "UserId": "...",
    "Account": "...",
    "Arn": "arn:aws:iam::...:user/..."
}
```

Or if the keys are no longer value, you'll get something along the lines of:

```
An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
```
