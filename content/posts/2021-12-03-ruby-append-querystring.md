---
title: "Appending Values to a Querystring with Ruby"
description: "How to append a query parameter to a URL's querystring in Ruby."
tags:
- blogumentation
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-03T14:15:44+0000
slug: "ruby-append-querystring"
---
Let's say that you have a URL and you want to append on query parameters, for instance to add tracking data to a URL.

For example, let's say we want to add on `utm_medium=example&utm_source=my_blog` to a given URL.

You _could_ do this by simply appending `?utm_medium=example&utm_source=my_blog` to a URL we've been given, but that doesn't work in the case that a URL already has a querystring, because a number of URL parsers will reject that as a invalid URL, or it will not parse as you're expecting to.

The solution I've found that works best is to parse the URI, then use `URI.encode_www_form` on the parsed querystring once we've appended our parameters:

```ruby
def add_tracking(url)
  parsed = URI.parse(url)
  query = if parsed.query
           CGI.parse(parsed.query)
         else
           {}
         end

  query['utm_medium'] = %w(example)
  query['utm_source'] = %w(my_blog)

  parsed.query = URI.encode_www_form(query)
  parsed.to_s
end
```

This works for the following cases:

```
add_tracking 'https://foo.com'
=> "https://foo.com?utm_medium=example&utm_source=my_blog"
add_tracking 'https://foo.com/'
=> "https://foo.com/?utm_medium=example&utm_source=my_blog"
add_tracking 'https://foo.com/?page=1'
=> "https://foo.com/?page=1&utm_medium=example&utm_source=my_blog"
add_tracking 'https://foo.com/?page=1&page=2'
=> "https://foo.com/?page=1&page=2&utm_medium=example&utm_source=my_blog"
```
