---
title: "Parsing Encoded JSON Strings on the Command-Line with Ruby"
description: "How to decode an encoded JSON string."
tags:
- blogumentation
- command-line
- json
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-28T19:12:42+0100
slug: "parse-encoded-json-string-ruby"
image: https://media.jvt.me/00fdea0d32.png
---
JSON is a pretty common format for serialising of data, and can either be transmitted as the object itself, or as a string that's encoded the JSON structure.

Although I like to work with APIs or data that just produces the object itself, there are times that you work with things that produce i.e.:

```json
{
  "internalResponse": "{\"response\": {\"value\": \"the-thing\"}}"
}
```

To parse this, you could do something funky with replacing the quotes that are within the body of that field, but then you may have to deal with escaped quotes, and we really should avoid funky code like that.

Fortunately, we can create a small script, which needs to [_safely_ parse the string that's provided](https://nts.strzibny.name/safe-code-evaluation-in-ruby-with-safe/), as we need Ruby to parse the string and remove the escaped quotes itself:

```ruby
#!/usr/bin/env ruby
require 'json'

input = ARGF.read
# https://nts.strzibny.name/safe-code-evaluation-in-ruby-with-safe/
$SAFE = 4
input = eval input

jj JSON.parse(input)
```

This allows us to run the following, based on a file, or stdin:

```
$ cat file.json
"{\"response\": {\"value\": \"the-thing\"}}"
$ ruby j.rb file.json
$ echo "{\"response\": {\"value\": \"the-thing\"}}" | ruby j.rb
```
