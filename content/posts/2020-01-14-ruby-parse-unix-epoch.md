---
title: "Parsing a Unix Epoch With Bash/Ruby on the Command-Line"
description: "How to convert a Unix Epoch to a human-readable date format."
tags:
- blogumentation
- command-line
- ruby
- shell
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-01-14T19:50:12+0000
slug: "ruby-parse-unix-epoch"
---
Every so often I have to work with Unix Epochs, and am forever annoyed I can't convert them in my head (a little sarcasm).

I wanted an easy scripted alternative for how to do it myself, and have two options (so far):

Let's say that we have the epoch date `1516239022`.

# With `date`

Using the coreutils, we can use the `date` command-line tool:

```sh
$ date --date='@1516239022'
Thu 18 Jan 01:30:22 GMT 2018
```

Which we can convert to a handy function:

```sh
function epoch() {
  date --date="@$1"
}
```

# With Ruby

Alternatively we can do this with Ruby, my preferred scripting language:

```sh
$ ruby -rtime -e 'puts Time.at(ARGF.read.to_i)' <<< 1516239022
# or by using the clipboard
$ xsel | ruby -rtime -e 'puts Time.at(ARGF.read.to_i)'
# or just as an argument
$ ruby -rtime -e 'puts Time.at(ARGV[0].to_i)' 1516239022
```
