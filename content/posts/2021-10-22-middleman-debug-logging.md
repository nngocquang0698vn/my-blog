---
title: "Debugging Middleman Code With Middleman's Logger"
description: "How to diagnose issues in Middleman, using logging output."
date: 2021-10-22T08:55:57+0100
tags:
- "blogumentation"
- "middleman"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "middleman-debug-logging"
image: https://media.jvt.me/5a4be89ccd.png
---
I've recently been working with the [Middleman static site generator](https://middlemanapp.com/), which I'm finding a nice experience because it's written in Ruby.

I've been enjoying the fact that you can [write your own helper methods](https://middlemanapp.com/basics/helper-methods/#custom-defined-helpers) that can perform custom processing as part of outputting things in the page.

Because some of this can be somewhat complex processing, we would likely want to add test coverage of the functionality through unit tests.

However, if the helpers you're writing are heavily dependent on the data in the site, and the page you're trying to render, it can be a little cumbersome to replicate it correctly for a unit test ahead of time, so you may need to add some debug logging.

To do this, I'd hoped to use the very basic approach of printing to stdout using `puts`, which I found works pretty nicely.

Another way we can do this, is to use Middleman's underlying logging infrastructure, and call the logger, via its [singleton](https://refactoring.guru/design-patterns/singleton):

```ruby
::Middleman::Logger.singleton.error("Call someone out of bed - we've got a problem!")
::Middleman::Logger.singleton.info("Something normal is happening")
::Middleman::Logger.singleton.warn("This doesn't look right...")
::Middleman::Logger.singleton.debug("Won't be shown without `--verbose`")
```
