---
title: "Automagically determining which AWS Lambda runtimes are deprecated or end-of-life"
description: "Introducing a tool that can list AWS Lambda functions and whether their runtimes are approaching or past deprecation/end-of-life dates."
date: 2023-01-13T11:59:30+0000
tags:
- blogumentation
- aws-lambda
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/770ef46545.png
slug: lambda-end-of-life-checker
syndication:
- https://brid.gy/publish/twitter
---
One of the great things about AWS Lambda is that code you wrote several years ago can run, receiving security updates to the underlying runtime, at some point AWS removes support for the runtime.

This is done in two stages, and once hitting the "end of life" phase, you can no longer perform updates to the Lambda, meaning you'll generally need to do some underlying code changes as well as updating the runtime version.

I noticed that a couple of things in my personal infrastructure needed an update, as they were running rather outdated versions of the runtimes, which were visible in a Trusted Advisor report.

Because I wanted an alternative that I could use for my own reporting needs as well, I've put together a Go command-line tool that can do this, found [on GitLab](https://gitlab.com/tanna.dev/endoflife-checker).


```sh
go install gitlab.com/tanna.dev/endoflife-checker/cmd/aws-lambda-endoflife@HEAD
```

Then, to produce the report, run:

```sh
aws-lambda-endoflife -report
```

This will auto-detect AWS configuration, and can be tweaked using the usual environment variables such as:

```sh
env AWS_DEFAULT_REGION=mars-east-1 aws-lambda-endoflife -report
```

This then produces a tab-separated value (TSV) formatted output that can be put into a spreadsheet tool like Google Sheets for easier filtering.

The deprecation data is currently hardcoded, because [as far as I could tell](https://www.jvt.me/mf2/2023/01/plyqd/) there's no way to get a machine-parseable form of the deprecation information. If you're aware of a way, let me know!
