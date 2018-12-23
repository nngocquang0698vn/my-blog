---
title: TYKJS Middleware Gotcha When Base 64 Decoding Data
description: "How to workaround the `Failed to base64 decode: illegal base64 data at input byte` error when trying to use `b64dec` in TYKJS middleware"
categories: blogumentation tyk tykjs
tags: blogumentation tyk tykjs unit-testing testing javascript nodejs
licenses:
  code: Apache-2.0
no_toc: true
image: /img/vendor/tyk.io.jpg
---
As mentioned in [_Unit Testing Your TYK (TYKJS) Middleware_][unit-test-tykjs], I've recently been playing around with the [TYK API Gateway] and in this example I had been introspecting JSON Web Tokens (JWTs).

As seen in my post [_Pretty Printing JSON Web Tokens (JWTs) on the Command Line using Ruby_][decode-jwt], JWTs are actually just base64 encoded JSON objects. So I was doing something like:

```js
var payload_str = b64dec(payload_encoded);
var payload = JSON.parse(payload_str);
if ('openid' == payload.scopes) {
  // ...
}
```

This was working in my [unit tests for the middleware][unit-test-tykjs], but not when I was actually running it on an instance (running in [Docker]).

_In some cases_ of the JWTs I was introspecting, I would receive an error similar to:

```
[Nov 28 22:17:18] ERROR jsvm: Failed to base64 decode: illegal base64 data at input byte 0
```

What was weird was how certain JWTs weren't being parsed, but others were.

As TYK provides the `b64dec` function to the JSVM on run, I had to fake it in my unit tests, using the below snippet from [this StackOverflow question][stackoverflow-b64-encode]:

```js
/*
 * Licensed under the Attribution-ShareAlike 3.0 Unported
 * https://stackoverflow.com/a/23097961/2257038
 */
function b64dec(str){
  return Buffer.from(str).toString('base64');
}
```

When googling for the error message, I found [a StackOverflow post with a similar error][stackoverflow], calling out the error coming from a Go program. This led to the realisation that instead of using the JavaScript implementation, would use the Go equivalent for (presumably) speed.

This meant that we were actually seeing a Go issue, not a Node one.

Looking in the [`mw_js_plugin.go` file in the Tyk v2.7.4 source code][tykjs-go], we can see that it does not ignore padding:

```go
/*
 * NOTE: This file is licensed under the Mozilla Public License 2.0 (MPL-2.0)
 * which can be read in full at
 * https://github.com/TykTechnologies/tyk/blob/v2.7.4/LICENSE.md and the source
 * of this file can be seen at
 * https://github.com/TykTechnologies/tyk/blob/v2.7.4/mw_js_plugin.go#L421-L438
 */
j.VM.Set("b64dec", func(call otto.FunctionCall) otto.Value {
  in := call.Argument(0).String()
  out, err := base64.StdEncoding.DecodeString(in)
  if err != nil {
    log.WithFields(logrus.Fields{
      "prefix": "jsvm",
    }).Error("Failed to base64 decode: ", err)
    return otto.Value{}
  }
  returnVal, err := j.VM.ToValue(string(out))
  if err != nil {
    log.WithFields(logrus.Fields{
      "prefix": "jsvm",
    }).Error("Failed to base64 decode: ", err)
    return otto.Value{}
  }
  return returnVal
})
```

Because Tyk doesn't handle padding, we instead need to make sure that our middleware does this for us.

This fix was fairly straightforward - we would make sure to pad the base64 encoded payload to appease the Go code.

By padding the base64 string correctly, we now have the following:

```diff
+function pad(str) {
+  while(0 !== (str.length % 4)) {
+    str = str + '=';
+  }
+  return str;
+}
+
+var payload_encoded_padded = pad(payload_encoded);
-var payload_str = b64dec(payload_encoded);
+var payload_str = b64dec(payload_encoded_padded);
 var payload = JSON.parse(payload_str);
 if ('openid'' == payload.scopes) {
   // ...
 }
```

Finally, as a way to future-proof my testing, I also made sure that my `b64dec` fake in my tests would also throw an error to catch invalid padding, so in the future I'd be able to catch it at the test level:

```diff
 /*
  * Licensed under the Attribution-ShareAlike 3.0 Unported
  * Modified from https://stackoverflow.com/a/23097961/2257038
  */
 function b64dec(str){
+  if (0 !== (str.length % 4)) {
+    throw "Base64 string not padded"
+  }
   return Buffer.from(str).toString('base64');
 }
```

It appears that [issue &#35;1808][tyk-issue-pad] covers this, and although a fix was made, this has not yet been resolved. I've reached out about looking to see if I can raise a PR to fix it.

[stackoverflow]: https://stackoverflow.com/a/50857394/2257038
[unit-test-tykjs]: {% post_url 2018-12-10-testing-tykjs-middleware %}
[TYK API Gateway]: https://tyk.io/
[decode-jwt]: {% post_url 2018-08-31-pretty-printing-jwt-ruby %}
[Docker]: https://@github.com/lonelycode/tyk-gateway-docker
[tykjs-go]: https://github.com/TykTechnologies/tyk/blob/v2.7.4/mw_js_plugin.go#L421-L438
[stackoverflow-b64-encode]: https://stackoverflow.com/a/23097961/2257038
[tyk-issue-pad]: https://github.com/TykTechnologies/tyk/issues/1808
