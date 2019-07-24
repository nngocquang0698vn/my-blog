---
title: "Pretty Printing JSON Files Inline on the Command Line"
description: "How to rewrite multiple JSON files inline on the Command Line."
tags:
- blogumentation
- pretty-print
- command-line
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-07-24T14:26:05+0100
slug: "pretty-print-json-files-inline"
---
Today I've found myself needing to compare a number of JSON files to see whether certain configuration has been pulled in correctly.

Usually this would be a fairly routine task (as I find myself doing this quite often), but some of the JSON files seemed to be structured differently, so I wanted to pretty-print them in the same way so it was more easily to diff them.

To do this, I reused steps from [_Pretty Printing JSON on the Command Line with Ruby_]({{< ref "2019-03-29-pretty-printing-json-ruby" >}}) to perform the pretty-printing, and added a little bit of extra code to perform the inline editing.

Let us say that we're wanting to change all JSON files in the directory `config/`, as well as any and all nested subdirectories it has. This would give us the following Ruby code:

```ruby
require 'json'

Dir.glob('config/**/*.json').each do |file|
  json = JSON.parse(File.read file)
  File.open(file, 'w') do |out|
    out.write(JSON.pretty_generate json)
  end
end
```

However, this is a pain if we want to have an easy-to-copy/reuse method, so we can trim it to a fun one-liner:

```bash
ruby -rjson -e 'Dir.glob("config/**/*.json").each { |f| j = JSON.parse(File.read(f)); File.open(f, "w") { |o| o.write(JSON.pretty_generate(j)) } }'
```

Alternatively, to more easily make it an alias/function, you can extract the glob into an argument:

```bash
ruby -rjson -e 'Dir.glob(ARGV[0]).each { |f| j = JSON.parse(File.read(f)); File.open(f, "w") { |o| o.write(JSON.pretty_generate(j)) } }' 'config/**/*.json'
```

Which allows aliasing as such:

```bash
alias ppj="ruby -rjson -e 'Dir.glob(ARGV[0]).each { |f| j = JSON.parse(File.read(f)); File.open(f, \"w\") { |o| o.write(JSON.pretty_generate(j)) } }'"
ppj 'config/**/*.json'
```
