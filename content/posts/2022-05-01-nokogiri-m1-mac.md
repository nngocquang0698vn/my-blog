---
title: "Installing Nokogiri on an M1 Mac"
description: "How to get Nokogiri building on an M1 Mac, when using `Bundler`."
date: "2022-05-01T14:39:42+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1520761755676385283"
tags:
- "blogumentation"
- "mac"
- "ruby"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/bd953e5578.png"
slug: "nokogiri-m1-mac"
---
If you're working with Ruby projects, it's likely you'll have encountered [Nokogiri](https://nokogiri.org/).

Nokogiri, as a very powerful library for XML/HTML parsing, is used by many dependencies, but for Ruby devs is consistently an awkward thing to install, as it requires native extensions.

If you've got an M1 Mac, you may be hitting issues such as:

```
dlopen(.../nokogiri/.../nokogiri.bundle, ...): could not use '.../nokogiri-.../lib/nokogiri/.../nokogiri.bundle' because it is not a compatible arch - .../nokogiri-.../lib/nokogiri/.../nokogiri.bundle (LoadError)```
```

This is due to Bundler not picking up the platform's architecture correctly.

If you're on the default Ruby installation, which has a `bundle --version` below v2.1, you'll need to run, thanks to [this comment on StackOverflow](https://github.com/alshedivat/al-folio/issues/240#issuecomment-965837699):

```sh
bundle config set force_ruby_platform true
bundle install
```

Or when using a Bundler version above `v2.1`:

```sh
bundle config force_ruby_platform true
bundle install
```
