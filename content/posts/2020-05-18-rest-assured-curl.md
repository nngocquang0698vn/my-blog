---
title: "Converting Output from Rest Assured to Curl Requests"
description: "How to convert the log output from Rest Assured to a `curl` request."
tags:
- blogumentation
- rest-assured
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-18T13:11:15+0100
slug: "rest-assured-curl"
syndication:
- https://lobste.rs/s/fntzsp/converting_output_from_rest_assured_curl
- https://news.ycombinator.com/item?id=23221656
---
I work with [Rest Assured](http://rest-assured.io/) a fair bit for automated testing against RESTful API services.

These test suites usually log Rest Assured's request/response output, which allows us to see the full request/response of the tests. Not only is it good for debugging, but I find it super useful as this then gives us evidence of the service's contract for the future.

In the cases that these tests do fail, I can then take the given request, and retry it to see if I can spot any fresh errors in logs.

However, this process of taking the output of Rest Assured and making it work with curl is a manual process, so can be a bit painful.

I discovered there is [the curl-logger project](https://github.com/dzieciou/curl-logger) but that unfortunately requires you to be already using the project to provide logging, and this isn't always possible.

As it's bugged me for long enough, I've written a script that converts a log output such as:

```
Request method:	POST
Request URI:	https://url?q=config
Proxy:			<none>
Request params:	<none>
Query params:	q=config
Form params:	<none>
Path params:	<none>
Headers:		Accept=application/jwt
				Content-Type=application/json; charset=UTF-8
Cookies:		auth=eyJ...=null
Multiparts:		<none>
Body:
{
    "key": [
        1,
        2,
        3
    ],
    "another": null
}
```

To the below curl representation:

```sh
curl -X POST 'https://url?q=config' -H 'Accept:application/jwt' -H 'Content-Type:application/json; charset=UTF-8' --cookie 'auth=eyJ...=null' -d '{"key": [1,2,3],"another": null}'
```

This should make it easier to work with these log outputs, and make interacting with the service easier.

# The Script

This isn't necessarily the best code I've written, but it does the job!

```ruby
require 'json'

def parse(lines)
  request = {}
  multiline = nil

  lines.each do |line|
    # we're no longer in a multi-line parameter list if the line starts with i.e.
    # `Body`, as multilines are preceded by whitespace
    multiline = nil if line.match?(/^[A-Z]/)

    # ignore unset options
    next if line.match?(/<none>/)

    if line.start_with? 'Request URI'
      request['uri'] = line.sub(/^Request URI:\s+/, '')
    elsif line.start_with? 'Request method'
      request['method'] = line.sub(/^Request method:\s+/, '')
    elsif line.start_with? 'Proxy'
      request['proxy'] = line.sub(/^Proxy:\s+/, '')
    elsif line.start_with? 'Query params'
      # these are ignored, as the URI provides them, but are matched just to hide
      # the warnings
      multiline = 'query'
      request[multiline] = []
      request[multiline] << line.sub(/^Query params:\s+/, '')
    elsif line.start_with? 'Form params'
      multiline = 'form'
      request[multiline] = []
      request[multiline] << line.sub(/^Form params:\s+/, '')
    elsif line.start_with? 'Cookies'
      multiline = 'cookies'
      request[multiline] = []
      request[multiline] << line.sub(/^Cookies:\s+/, '')
    elsif line.start_with? 'Headers'
      multiline = 'headers'
      request[multiline] = []
      request[multiline] << line.sub(/^Headers:\s+/, '')
    elsif line.start_with? 'Body'
      multiline = 'body'
      request[multiline] = []
      request[multiline] << line.sub(/^Body:\s+/, '')
    elsif multiline
      request[multiline] << line.sub(/^\s+/, '')
    else
      $stderr.puts "Not supported: #{line}"
    end
  end

  request
end

def to_curl(request)
  curl = %w(curl)
  curl << "-X #{request['method']}"
  curl << "'#{request['uri']}'"

  if request['headers']
    request['headers'].each do |header|
      curl << "-H '#{header.sub(/=/, ':')}'"
    end
  end

  if request['cookies']
    request['cookies'].each do |cookie|
      curl << "--cookie '#{cookie}'"
    end
  end

  if request['form']
    request['form'].each do |form|
      curl << "-d '#{form}'"
    end
  end

  if request['proxy']
    curl << "--proxy '#{request['proxy']}'"
  end

  if request['body']
    body = request['body'].join ''
    curl << "-d '#{body}'"
  end

  curl.join(' ').gsub(/\n/, '')
end

request = parse(File.readlines(ARGV[0]))
puts to_curl(request)
```

You can interact with it by running:

```sh
ruby rest-assured-to-curl.rb log.txt
```

Where `log.txt` is the output from Rest Assured, starting with `Reqest method`.

## Caveats

This has been tested with Rest Assured v3.3.0, v4.0.0 and v4.3.0, using the below Rest Assured code:


```java
given()
  .cookie("auth=eyJ...")
  .header("Accept", "application/jwt")
  .contentType(ContentType.JSON)
  .queryParam("q", "config")
  .body("{\"key\": [1,2,3], \"another\": null}")
  .log().all()
  .post("https://url");
```

**NOTE**: If you are using Rest Assured's `auth` functionality, this will not display unless you use `preemptive()`.

**NOTE**: This does not currently support multipart requests.
