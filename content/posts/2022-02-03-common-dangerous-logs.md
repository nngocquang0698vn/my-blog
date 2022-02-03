---
title: "I don't think you should be logging that? 😳"
description: "Common pitfalls and dangerous things that you should be watching out for in your log messages."
tags:
- blogumentation
- logs
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-03T10:35:38+0000
slug: common-dangerous-logs
---
Over the last few years, I've managed a lot of (non-)production infrastructure in my personal and professional life. As part of maintaining these systems, I've been digging through logs, understanding why certain users are affected by bad problems, or why the error messages I've built in my personal APIs aren't helpful enough.

However, while looking through logs we can find some very interesting things, most notably things that _should not_ be in there.

Although the original intent behind this article was to discuss what shouldn't be in an application/service's logs, it also can be applied to logs from i.e. Jenkins, GitLab CI, GitHub Actions, and that may be produced from EC2 userdata scripts, Chef client runs, etc.

These are examples based on non-production logs, and any relation to existences of data found in production systems is purely coincidental.

Finally, if you do see data of this type, especially a JWT or another form, [do not use online tools to inspect them](/posts/2020/09/01/against-online-tooling/).

# Common dangerous log patterns

Below are a number of common things that could be problematic, and where possible, ways to pick up on them using search strings for i.e. your logging aggregation platform.

## Higher log levels than expected

Something hopefully more straightforward to catch is cases where there is a `DEBUG` / `TRACE` log level turned on in a Production environment.

It's generally accepted practice that this will include more info, such as request bodies, and should be avoided.

Look for:

- `DEBUG`
- `TRACE`

## `Authorization` headers

Something fairly easy to look for is anywhere that uses the term `Authorization` or `Bearer`, as they're very likely to be using the HTTP `Authorization` header, which is commonly used with the `Bearer` authentication scheme.

Look for:

- `Authorization`
- `Bearer`
- Other [authentication schemes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization) you may be using, such as `Basic`

## Java Keystores

With Java applications that interact with other services using public/private keypairs, and optionally certificates, we generally store these in keystores.

To use them, we may need a `storepass` or a `keypass`, which are often provided as command-line arguments or as Java properties.

Look for strings:

- Commonly used property names are `keystorepass`, `storepass` and `keypass`
- The default passwords `changeme` and `changeit`

## Private keys / certificates

Your application may also be handling the raw keys, or for instance logging them when they're retrieved from a Java keystore.

Although the logging of a certificate's body is generally _not_ a leak, as it's the signed public portion, cannot be used without the private key and often will be present in a Certificate Transparency log, it's good to still avoid doing so, as it can worry folks looking through logs, as at first glance it may look like a private key.

However, it may also indicate that if there's the logging of the certificate, we may also be logging private keys, which definitely should _not_ be done.

Look for:

- `-----BEGIN`
- `-----END`
- `KEY-----`
- `KEY-----`
- `PRIVATE KEY`
- `RSA PRIVATE KEY`
- `EC PRIVATE KEY`
- `OPENSSL PRIVATE KEY`

## OAuth 1.0

If you're interacting with legacy OAuth 1 APIs, such as the Twitter API, you may have a key and a secret.

Look for strings:

- `access_token_key`
- `access_token_secret`

## Passwords

Pretty self-explanatory - we may have credentials for user accounts logged.

Look for:

- `password`
- `password=`

## AWS keys

May be found in application logs, but more likely to be in the outputs from some infrastructure provisioning tools like userdata scripts or Ansible.

Although these are very likely time-limited, it's also going to give someone with access to the logs perfect access to assume the identity of a running instance and could lead to i.e. data exfiltration or destructive actions.

Look for:

- `AWS_ACCESS_KEY_ID`
- `AWS_ACCESS_KEY`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SECRET_KEY`
- `AWS_SECURITY_TOKEN`
- `EC2_ACCESS_KEY`
- `EC2_SECRET_KEY`
- `EC2_SECURITY_TOKEN`
- `awsAccessKeyId`
- `awsAccessKey`
- `awsSecretAccessKey`
- `awsSecretKey`
- `awsSecurityToken`
- `ec2AccessKey`
- `ec2SecretKey`
- `ec2SecurityToken`

## Vault tokens

If using Hashicorp Vault, the tokens that are used to interact with Vault could allow access to other secrets.

They're less handy to look for, but there are likely regexes we can use to look for them.

Look for:

- `vault login`
- `VAULT_TOKEN=`

## Client Secrets

When using OAuth2, it's likely that you'll be building clients that are credentialed, such as those using a `client_secret` (side note: [avoid using client secrets](/posts/2021/11/09/avoid-client-secret/)).

Look for:

- `client_secret=`
- `clientSecret=`

## Base64-Encoded JSON

This isn't _that_ problematic most of the time, but a base64-encoded JSON blob is often a sign of JWTs, which we'll see next.

Even if not a JWT, they've often got interesting things in them!

Look for:

- `eyJ`

## JSON Web Tokens (JWTs) / JSON Web Signature (JWS) / JSON Web Encryption (JWE)

JWTs are often credentials, and as such need to be protected. Even if they're not used as access/refresh tokens, they may be ID tokens which can be used to impersonate identities.

But remember that, as easily inspectable values - as long as they're not encrypted - the data is available in the clear, and could subsequently include other PII.

Also, if you've got JWTs signed with the following:

```json
{
  "alg": "RS256",
  "kid": "production",
  "typ": "JWT"
}
```

Then look for the base64-encoded JWS header, which is `eyJhbGciOiAiUlMyNTYiLCJraWQiOiAicHJvZHVjdGlvbiIsInR5cCI6ICJKV1QifQo`.

The same can also be true of a JWE's header.

Also, look for:

- `eyJ` (the start of all JWTs)

## Access/Refresh Tokens

If you know the format of the tokens, whether they're JWTs, or a 32-character random hash, you can more easily discover presence of the tokens.

Also look for:

- `token=`
- `refresh_token=`

## Personally Identifiable Information (PII)

Depending on how your organisation and your country's laws work, having PII in your logs may actually be a data breach.

Look for:

- Common fields that could be PII - i.e. `date_of_birth` / `dob`
- If you have test accounts, periodically check for test data that may be from these accounts, in both non-production and production

## Axios errors

[Axios](https://axios-http.com/) is a very commonly used HTTP library for Node.JS. However, if you follow the example documentation for error handling we may get code something like this:

```js
const axios = require('axios').default;

axios.defaults.headers.common['Authorization'] = 'Bearer foo'

axios.post('https://expired.badssl.com/', {
  password: 'not-real'
})
  .then(function (response) {
    // handle success
    console.log(response);
  })
  .catch(function (error) {
    // handle error
    console.log(error);
    console.log(error.toJSON());
  })
  .then(function () {
    // always executed
  });
```

When this runs, we get:

<details>

<summary>Example Axios error log</summary>

```
Error: certificate has expired
    at TLSSocket.onConnectSecure (node:_tls_wrap:1530:34)
    at TLSSocket.emit (node:events:390:28)
    at TLSSocket._finishInit (node:_tls_wrap:944:8)
    at TLSWrap.ssl.onhandshakedone (node:_tls_wrap:725:12)
{
  code: 'CERT_HAS_EXPIRED',
  config: {
    transitional: {
      silentJSONParsing: true,
      forcedJSONParsing: true,
      clarifyTimeoutError: false
    },
    adapter: [Function: httpAdapter],
    transformRequest: [ [Function: transformRequest] ],
    transformResponse: [ [Function: transformResponse] ],
    timeout: 0,
    xsrfCookieName: 'XSRF-TOKEN',
    xsrfHeaderName: 'X-XSRF-TOKEN',
    maxContentLength: -1,
    maxBodyLength: -1,
    validateStatus: [Function: validateStatus],
    headers: {
      Accept: 'application/json, text/plain, */*',
      Authorization: 'Bearer foo',
      'Content-Type': 'application/json',
      'User-Agent': 'axios/0.25.0',
      'Content-Length': 23
    },
    method: 'post',
    url: 'https://expired.badssl.com/',
    data: '{"password":"not-real"}'
  },
  request: <ref *1> Writable {
    _writableState: WritableState {
      objectMode: false,
      highWaterMark: 16384,
      finalCalled: false,
      needDrain: false,
      ending: false,
      ended: false,
      finished: false,
      destroyed: false,
      decodeStrings: true,
      defaultEncoding: 'utf8',
      length: 0,
      writing: false,
      corked: 0,
      sync: true,
      bufferProcessing: false,
      onwrite: [Function: bound onwrite],
      writecb: null,
      writelen: 0,
      afterWriteTickInfo: null,
      buffered: [],
      bufferedIndex: 0,
      allBuffers: true,
      allNoop: true,
      pendingcb: 0,
      constructed: true,
      prefinished: false,
      errorEmitted: false,
      emitClose: true,
      autoDestroy: true,
      errored: null,
      closed: false,
      closeEmitted: false,
      [Symbol(kOnFinished)]: []
    },
    _events: [Object: null prototype] {
      response: [Function: handleResponse],
      error: [Function: handleRequestError],
      socket: [Function: handleRequestSocket]
    },
    _eventsCount: 3,
    _maxListeners: undefined,
    _options: {
      maxRedirects: 21,
      maxBodyLength: 10485760,
      protocol: 'https:',
      path: '/',
      method: 'POST',
      headers: [Object],
      agent: undefined,
      agents: [Object],
      auth: undefined,
      hostname: 'expired.badssl.com',
      port: null,
      nativeProtocols: [Object],
      pathname: '/'
    },
    _ended: false,
    _ending: true,
    _redirectCount: 0,
    _redirects: [],
    _requestBodyLength: 23,
    _requestBodyBuffers: [ [Object] ],
    _onNativeResponse: [Function (anonymous)],
    _currentRequest: ClientRequest {
      _events: [Object: null prototype],
      _eventsCount: 7,
      _maxListeners: undefined,
      outputData: [],
      outputSize: 0,
      writable: true,
      destroyed: false,
      _last: true,
      chunkedEncoding: false,
      shouldKeepAlive: false,
      maxRequestsOnConnectionReached: false,
      _defaultKeepAlive: true,
      useChunkedEncodingByDefault: true,
      sendDate: false,
      _removedConnection: false,
      _removedContLen: false,
      _removedTE: false,
      _contentLength: null,
      _hasBody: true,
      _trailer: '',
      finished: false,
      _headerSent: true,
      _closed: false,
      socket: [TLSSocket],
      _header: 'POST / HTTP/1.1\r\n' +
        'Accept: application/json, text/plain, */*\r\n' +
        'Authorization: Bearer foo\r\n' +
        'Content-Type: application/json\r\n' +
        'User-Agent: axios/0.25.0\r\n' +
        'Content-Length: 23\r\n' +
        'Host: expired.badssl.com\r\n' +
        'Connection: close\r\n' +
        '\r\n',
      _keepAliveTimeout: 0,
      _onPendingData: [Function: nop],
      agent: [Agent],
      socketPath: undefined,
      method: 'POST',
      maxHeaderSize: undefined,
      insecureHTTPParser: undefined,
      path: '/',
      _ended: false,
      res: null,
      aborted: false,
      timeoutCb: null,
      upgradeOrConnect: false,
      parser: null,
      maxHeadersCount: null,
      reusedSocket: false,
      host: 'expired.badssl.com',
      protocol: 'https:',
      _redirectable: [Circular *1],
      [Symbol(kCapture)]: false,
      [Symbol(kNeedDrain)]: false,
      [Symbol(corked)]: 0,
      [Symbol(kOutHeaders)]: [Object: null prototype]
    },
    _currentUrl: 'https://expired.badssl.com/',
    [Symbol(kCapture)]: false
  },
  response: undefined,
  isAxiosError: true,
  toJSON: [Function: toJSON]
}
{
  message: 'certificate has expired',
  name: 'Error',
  description: undefined,
  number: undefined,
  fileName: undefined,
  lineNumber: undefined,
  columnNumber: undefined,
  stack: 'Error: certificate has expired\n' +
    '    at TLSSocket.onConnectSecure (node:_tls_wrap:1530:34)\n' +
    '    at TLSSocket.emit (node:events:390:28)\n' +
    '    at TLSSocket._finishInit (node:_tls_wrap:944:8)\n' +
    '    at TLSWrap.ssl.onhandshakedone (node:_tls_wrap:725:12)',
  config: {
    transitional: {
      silentJSONParsing: true,
      forcedJSONParsing: true,
      clarifyTimeoutError: false
    },
    adapter: [Function: httpAdapter],
    transformRequest: [ [Function: transformRequest] ],
    transformResponse: [ [Function: transformResponse] ],
    timeout: 0,
    xsrfCookieName: 'XSRF-TOKEN',
    xsrfHeaderName: 'X-XSRF-TOKEN',
    maxContentLength: -1,
    maxBodyLength: -1,
    validateStatus: [Function: validateStatus],
    headers: {
      Accept: 'application/json, text/plain, */*',
      Authorization: 'Bearer foo',
      'Content-Type': 'application/json',
      'User-Agent': 'axios/0.25.0',
      'Content-Length': 23
    },
    method: 'post',
    url: 'https://expired.badssl.com/',
    data: '{"password":"not-real"}'
  },
  code: 'CERT_HAS_EXPIRED',
  status: null
}
```

</details>

Notice that we've got our `Authorization` header, and our full request body logged.

If we also had cookies stored, we can now see our cookie jar in the `config` object, too, with all the cookies!

<details>

<summary>Example Axios error log (with cookie jar)</summary>

```
config: {
  ...
  headers: {
  Accept: 'application/json, text/plain, */*',
    'Content-Type': 'application/json',
    'User-Agent': 'axios/0.25.0',
    'Content-Length': 23
  },
  jar: CookieJar {
    rejectPublicSuffixes: true,
    enableLooseMode: false,
    allowSpecialUseDomain: false,
    store: { idx: {
      'stats.jvt.me': {
        '/': {
          MATOMO_SESSID: Cookie="MATOMO_SESSID=0t2qcu2o71abdhrvmorld8qrj3; Path=/; Secure; HttpOnly; SameSite=Lax;       hostOnly=true; aAge=231ms; cAge=231ms"
        }
      },
      'httpbin.org': {
        '/': {
          session: Cookie="session=userid; Path=/; hostOnly=true; aAge=11ms; cAge=17ms"
        }
      }
    } },
   ...
  },
  ...
},
```

This is really dangerous, and can also include information about other requests going through, so even if your specific call isn't sensitive, others may be.

</details>

## `Buffer`s

Something I've also seen is logs containing `Buffer` objects, commonly when dumping out a large object containing binary data, such as an Axios error.

For instance, we see a binary data object that's been produced from the string `hello world`:

```json
{
  "data": [
    104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100
  ],
  "type": "Buffer"
}
```

Look for:

- `"Buffer"`

## API Keys

Depending on how your systems use API keys, they may be found in a special header such as `Api-Key`, or you may be overloading the `Authorization` header.

Look for:

- i.e. `Api-Key`
- the format of API keys themselves

## Use trufflehog

[Trufflehog](https://github.com/trufflesecurity/truffleHog) is a great tool for finding secrets in Git repos. Although this is more likely to help you pick up on committed secrets, it can also be an inspiration for patterns that can be looked for across your logs, too.

## Domain-specific secrets

This is one that I can't predict for you, but there may be things that your application domain requires are protected.

For instance in banking the 16 digit Primary Account Number (PAN) on your card needs to be protected. To look for this, we'd look for 16-digit numbers and then verify if they which pass the [Luhn algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm), in which case it's very likely it's a PAN.

Or if working on OAuth2 APIs with Dynamic Client Registration (such as Open Banking), there are secrets like the Software Statement Assertion that need to be kept secure.

# How to avoid

## Have a strategy for leaks

Firstly, realise that this is a case of when, not if, this will happen. Being prepared for it, and knowing what you need to do to purge the logs, or temporarily drop logs from your log aggregation platform, until the fix has been performed.

Having a strategy to deal with it is really important, and helps before we can take other preventative measures.

## Education

Next, we need to work with engineers to explain the risks of data being put into logs, and just how easy it is to miss at things like code review.

Work with your development and quality engineers to understand what to look for, as they'll be the first line of defence.

### Avoid querystrings for sensitive data

As noted in [_Should That (Secret) Thing Be In Your Querystring?_](/posts/2021/12/08/should-secrets-querystring/), sensitive data shouldn't be available in URLs, as they're logged _all over the place_. Ensure that engineers are supported with this knowledge, so they can work to ensure their services reduce the use of querystrings where applicable.

## Not logging it in the first place!

The easiest way to solve this is, unhelpfully, not to log it. It's especially unhelpful because we rely on so much - from in-house software, to various dependencies, to vendor-built tooling, and even our Cloud providers.

It's not likely to be possible to stop it, but we can do what we can to reduce the chance of it happening.

I've even seen issues arise when there may be an edge case in error handling that wasn't visible until you did an upgrade of your programming language!

## Automated scanning of logs

Adding automated scanning for your logs is the next best thing, so we can start picking up on problematic logs, and address them hopefully before bad actors can use them!

## Automated blocking of logs / don't uplift

If we've got automated scanning, likely including regexes or other string matching that includes our sensitive strings, we can also look to i.e. amend fluentd configuration to omit sensitive patterns, or just drop log messages altogether.

## Manual scanning of logs

Something I ended up doing was looking through logs myself, and this, and as part of routine work by i.e. teams when doing releases, we can catch more edge cases that fall through the cracks of our automated scans.

## Code review

Although code review is more difficult to catch some of the edge cases like the Axios one above, it does give you the chance to really query whether someone adding sensitive data into your logs makes sense, and gives you another chance to catch problems before they go live.

## Align log levels in environments

Making sure that your log levels align between environments, or at least between your staging and production environments,  - at least if you have a production and a staging environment,

Having a non-production environment spewing sensitive data at the minimum desensitises engineers to seeing it in their logs, and being less worried by seeing it in higher accounts, but also has the downside of worrying folks who do see it in a lower environment, thinking it may be in a higher environment!

# Feedback

If you've got any thoughts, or common tools, practices or processes you've got in place to support this, let me know!
