---
title: Pretty Printing JSON Web Tokens (JWTs) on the Command Line using OpenSSL
description: How to easily introspect a JWT on the command line using OpenSSL and optionally Python for real pretty-printing.
tags:
- blogumentation
- python
- cli
- jwt
- json
- pretty-print
image: /img/vendor/jwt.io.jpg
date: 2019-06-13T13:02:21+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: "pretty-printing-jwt-openssl"
---
Let's say you're starting to work with JWTs, and to confirm that their payload is correct, you want to introspect their contents. However, you may be aware that JWTs can contain sensitive information such as the hostname of a server, personally identifiable information, or could be used as a bearer token to access a service, so you shouldn't really be introspecting it in some public space such as [JWT.io](https://jwt.io).

This has put you in a difficult position, but no more - decoding a JWT is really easy, and in this example I'll show you how to do it using just GNU Bash and OpenSSL for a dependency-less alternative to [using Ruby]({{< ref 2018-08-31-pretty-printing-jwt-ruby >}}).

**Update 2019-10-22**: This previous version did not work very helpfully when trying to introspect an encrypted JWT (JWE). I have updated the code below to support encrypted and non-encrypted JWTs.

Let us use the following JWT in `example.jwt`, via JWT.io:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

As well as the following encrypted JWT (JWE) from [RFC7516: JSON Web Encryption (JWE)](https://tools.ietf.org/html/rfc7516#section-3.3):

```
eyJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkEyNTZHQ00ifQ.OKOawDo13gRp2ojaHV7LFpZcgV7T6DVZKTyKOMTYUmKoTCVJRgckCL9kiMT03JGeipsEdY3mx_etLbbWSrFr05kLzcSr4qKAq7YN7e9jwQRb23nfa6c9d-StnImGyFDbSv04uVuxIp5Zms1gNxKKK2Da14B8S4rzVRltdYwam_lDp5XnZAYpQdb76FdIKLaVmqgfwX7XWRxv2322i-vDxRfqNzo_tETKzpVLzfiwQyeyPGLBIO56YJ7eObdv0je81860ppamavo35UgoRdbYaBcoh9QcfylQr66oc6vFWXRcZ_ZT2LawVCWTIy3brGPi6UklfCpIMfIjf7iGdXKHzg.48V1_ALb6US04U3b.5eym8TW_c8SuK0ltJ3rpYIzOeDQz7TALvtu6UG9oMo4vpzs9tX_EFShS8iB7j6jiSdiwkIr3ajwQzaBtQD_A.XFBoMYUZodetZdvTiFvSkQ
```

JWTs have a couple of characteristics that we need to be aware of - they can be URL encoded ([RFC7515](https://tools.ietf.org/html/rfc7515#appendix-C)) and they Base64 encoding will need to padded out so OpenSSL can read it properly.

We don't care about looking at the signature, only the header and payload, so just want to pull out the first two pieces and output them:

```bash
function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    echo "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}
```

This then outputs the JWT as follows:

```json
{"alg":"HS256","typ":"JWT"}
{"sub":"1234567890","name":"John Doe","iat":1516239022}
```

Or with an encrypted JWT (JWE):

```json
{"alg":"RSA-OAEP","enc":"A256GCM"}
```

But that doesn't look _so_ pretty, especially when we have large JSON objects. So instead for an almost dependency-less script, we can use [Python to pretty-print the JSON]({{< ref 2017-06-05-pretty-printing-json-cli >}}):

```bash
function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}
```

Which then outputs:

```json
{
    "alg": "HS256",
    "typ": "JWT"
}
{
    "sub": "1234567890",
    "name": "John Doe",
    "iat": 1516239022
}
```

Or with an encrypted JWT (JWE):

```json
{
    "alg": "RSA-OAEP",
    "enc": "A256GCM"
}
```
