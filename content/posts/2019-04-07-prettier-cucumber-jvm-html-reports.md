---
title: "Prettier HTML Reports for Cucumber-JVM"
description: "How to generate prettier HTML reports for Cucumber with `cucumber-reporting` and `cucumber-reporting-plugin`, with and without Jenkins."
tags:
- blogumentation
- java
- cucumber
- testing
- reporting
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-07T21:40:00+01:00
slug: "prettier-cucumber-jvm-html-reports"
image: /img/vendor/cucumber.png
---
I work a fair bit with [Cucumber-JVM](https://docs.cucumber.io/installation/java/) in my professional life, which runs various acceptance / component tests for Java services. When sharing test results with stakeholders such as Product Owners, I need an easier format to share with them, so have used the built-in Cucumber `html` reporting:

![Built-in HTML report](/img/prettier-cucumber-jvm-html-reports/builtin-report.png)

Late last year, <span class="h-card"><a class="u-url p-name" href="https://twitter.com/3lTimbo">Tim Norris</a></span> recommended I try out the Jenkins plugin [`cucumber-reports-plugin`](https://github.com/jenkinsci/cucumber-reports-plugin) for reporting instead of the built-in HTML reporter. He's been using it for some of the services that he owns, and found that the use of the plugin made looking at test results much easier than using the built-in reporting, not least because it was a bit more visual in its usage.

As we can see, it has a much nicer visual breakdown of the steps and features:

![Pretty HTML report](/img/prettier-cucumber-jvm-html-reports/pretty-report.png)

All the plugin needs is to be pointed to your `cucumber-report.json`, after which it'll publish the HTML to the Jenkins UI.

However, the issue with this plugin is that it does this purely through Jenkins, not through the actual Cucumber test run. This means that in your i.e. `target/` directory after a local build you won't get these pretty HTML reports, nor will you be able to easily download them through the Jenkins UI.

As I started to write a feature request on the [`cucumber-reporting`](https://github.com/damianszczepanik/cucumber-reporting) project, which is the core library that `cucumber-reports-plugin` uses, I realised I should be a good Open Source citizen and take a look at the code first.

I couldn't seem to find anything that implemented the Cucumber `Formatter`, which would allow me hook it into the `@CucumberOptions` like so:

```java
@CucumberOptions(plugin = {"pretty", "json:target/report.json", "cucumber-reporting:target/pretty-cucumber"}, features = {"classpath:features"})
```

But searching through the issues on the repo led me to [the issue _Is it possible to use cucumber-reporting plugin through cucumber CLI Runner?_](https://github.com/damianszczepanik/cucumber-reporting/issues/686) in which GitHub user monochromata mentioned that they had written [`cucumber-reporting-plugin`](https://gitlab.com/monochromata-de/cucumber-reporting-plugin) to handle this.

This means it's really easy to run:

```java
@CucumberOptions(plugin = {"pretty", "json:target/report.json", "de.monochromata.cucumber.report.PrettyReports:target/pretty-cucumber"}, features = {"classpath:features"})
```

Now, running Cucumber will generate a pretty report, which we can then view locally or archive within Jenkins, which look pretty great.

This saved me having to write my own wrapper to handle this, so thanks for the work on it! Hopefully it'll make it upstream to `cucumber-reporting` soon.

**Update**: The library now also supports Cucumber v4 as per my Merge Request [_Upgrade plugin to work with Cucumber v4_](https://gitlab.com/monochromata-de/cucumber-reporting-plugin/merge_requests/1).

**Update 2020-01-26**: For a clear example of how to add the reporting plugin to your project, including adding the dependency, please see [this example Merge Request](https://gitlab.com/jamietanna/fat-cucumber-jar/merge_requests/1).
