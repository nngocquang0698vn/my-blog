---
title: "Don't Just String Append to a Querystring"
description: "Why you shouldn't use concatenate strings together to append to a querystring."
tags:
- web
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-20T21:40:25+0000
slug: "dont-append-querystring"
---
Something I've been guilty of doing in the past, but am trying to make up for, is using string concatenation with URLs to append parameters to a querystring.

For instance, let's take the following Go code:

```go
package main

import (
	"fmt"
)

func main() {
  u := "https://www.jvt.me/posts/2022/01/20/dont-append-querystring/"
  fmt.Println(u + "?utm_medium=code_example");
}

```

In this case, the URL will be correctly output as:

```
https://www.jvt.me/posts/2022/01/20/dont-append-querystring/?utm_medium=code_example
```

It's something that is _generally_ safe, but you're going to hit "edge cases" more often than not, such as a URL already having a querystring on it:

```
http://example.com/page?p=132
# when concatenated, it is *not* a valid URL:
http://example.com/page?p=132?utm_medium=code_example
```

Or we may have an empty querystring:

```
http://example.com/page?
# when concatenated, it is *not* a valid URL:
http://example.com/page??utm_medium=code_example
```

Or we may have a fragment on the URL:

```
http://example.com/redirect#code=foo
# when concatenated, it is *not* a valid querystring, as it's part of the fragment:
http://example.com/redirect#code=foo?utm_medium=code_example
```

Or even if the URL already has a query parameter of that name, and we don't specify what we want the behaviour to be, which can cause confusion between URL parsing libraries:

```
http://example.com/page?utm_medium=existing
# when concatenated
http://example.com/page?utm_medium=existing&utm_medium=code_example
```

So what should we do instead?

We should treat the URL as a URL, not an arbitrary string, and then append/replace the parameter according to what we want to do.
