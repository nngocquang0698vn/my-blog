---
title: Setting your default AWS profile for the AWS CLI and SDKs
description: Setting the default AWS profile when working with multiple profiles and the AWS CLI / SDKs.
tags:
- blogumentation
- aws
- aws-cli
- aws-sdk
- command-line
image: /img/vendor/AmazonWebservices_Logo.png
date: 2018-11-15T00:12:20
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: aws-profile-cli-sdk
aliases:
- /posts/2018/11/14/aws-profile-cli-sdk/
---
If you're working with multiple AWS accounts, or at least multiple roles within the same account, you may be aware that you will have to have to specify the AWS profile you're working i.e. on the command line. This can be quite a pain if you're having to prefix each command you run with i.e. `aws --profile spectat_prod_read_only`.

Although the `~/.aws/config` file allows you to specify a default region, you cannot specify a default profile.

However, as I found earlier today in the [Stack Overflow post _How do I set the name of the default profile in AWS CLI?_](https://stackoverflow.com/a/48524810), we can see that we are able to specify the environment variable `AWS_PROFILE`, which will then be automagically picked up by the AWS CLI as well as any of the SDKs you use.

# Example

In this example, we'll use the `iam list-account-aliases` subcommand, purely to verify a connection to AWS using a profile set.

Forcing the deletion of `AWS_PROFILE` to show the default behaviour:

```
$ unset AWS_PROFILE && \
  aws iam list-account-aliases
Unable to locate credentials. You can configure credentials by running "aws configure".
$ unset AWS_PROFILE && \
  ruby -raws-sdk -e 'p Aws::IAM::Client.new.list_account_aliases.to_h'
... unable to sign request without credentials set (Aws::Errors::MissingCredentialsError)
# stacktrace
```

And now when we set the variable:

```
$ export AWS_PROFILE=spectat_prod_read_only && \
  aws iam list-account-aliases
{
  "AccountAliases": [
    "spectat_prod"
  ]
}
$ export AWS_PROFILE=spectat_prod_read_only && \
  ruby -raws-sdk -e 'p Aws::IAM::Client.new.list_account_aliases.to_h'
{:account_aliases=>["spectat_prod"], :is_truncated=>false}
```
