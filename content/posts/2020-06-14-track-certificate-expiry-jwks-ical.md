---
title: "Keeping Track of Certificate Expiry with a JWKS to iCalendar Converter"
description: "Creating an iCalendar feed for certificate expiry details, given a URI for a JSON Web Key Set."
tags:
- java
- jwks
- certificates
- jwks-ical
- calendar
- google-cloud
- serverless
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-14T22:14:56+0100
slug: "track-certificate-expiry-jwks-ical"
syndication:
- https://lobste.rs/s/nlbqhv/keeping_track_certificate_expiry_with
- https://news.ycombinator.com/item?id=23524907
---
# Why?

I work with a number of certificates, and probably the thing I like about them most (but also least!) is how they have a built-in requirement for regular rotation.

Because I work with a number of certificates, I want to make sure that I know ahead of time when I need to plan to rotate them, instead of leaving it until it's last minute (at least for cases where I'm not using Let's Encrypt).

The best way I've found this works is by tracking their expiries in my calendar, so as I'm looking week(s) into the future, I can see what needs to be rotated soon.

I've looked at writing one-off scripts to set these alerts up, but wasn't as much of a fan, as I'd need to keep re-running the scripts.

Because the certs I'm using are generally exposed on a JSON Web Key Set (JWKS) endpoint, I decided to build on the idea of these scripts to generate calendar entries, and have created a lightweight API that can take a given JWKS, parse the X509 certificate from the `x5c` field, and return an iCalendar feed.

# Demo

You can interact with the API by performing a GET request on the below URL:

```sh
https://europe-west1-jwksical-jvt-me.cloudfunctions.net/jwks-ical
  ?jwks_uri=$jwks_uri
```

Where `jwks_uri` is a URI for a given JWKS endpoint, such as `https://jamietanna.eu.auth0.com/.well-known/jwks.json`:

```json
{
  "keys": [
    {
      "alg": "RS256",
      "kty": "RSA",
      "use": "sig",
      "n": "0gDujz_AKJEPpwagtlMu6fjEC6Sjsy28G4vqh7nM13FdN39DuKn1NGFyYbvFtmKMzv1vnf-vRVbbuWhhQYmsApY8T4C8mf_JWOZmOpN_tkehdSzExfQt8nAJtpMYJWEoF61xJkrIqUiAi3diE6EKlpAJ1xTlbKv8SP3O3VLz8pvAQAoSqIm9A9BjVZ1QVGTJBdZwvNccDOFo9yHPDsN3j0cE0WlJal_BLE7w2zvUS3gCxkqzedMR5x_74tPhWKv0jRq38UWemnNGJ51PY4oZnRGJulLbtlWDekdRBhTubqQeFECf0pDtyIi2lTVvNiz0G1rCTEPnF5OgPto5HU16iw",
      "e": "AQAB",
      "kid": "ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzUxQzc5MUY0MjI2Nw",
      "x5t": "ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzUxQzc5MUY0MjI2Nw",
      "x5c": [
        "MIIDCTCCAfGgAwIBAgIJQGn5s3JXIPp1MA0GCSqGSIb3DQEBCwUAMCIxIDAeBgNVBAMTF2phbWlldGFubmEuZXUuYXV0aDAuY29tMB4XDTE4MTAxMzEyMDEzMloXDTMyMDYyMTEyMDEzMlowIjEgMB4GA1UEAxMXamFtaWV0YW5uYS5ldS5hdXRoMC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDSAO6PP8AokQ+nBqC2Uy7p+MQLpKOzLbwbi+qHuczXcV03f0O4qfU0YXJhu8W2YozO/W+d/69FVtu5aGFBiawCljxPgLyZ/8lY5mY6k3+2R6F1LMTF9C3ycAm2kxglYSgXrXEmSsipSICLd2IToQqWkAnXFOVsq/xI/c7dUvPym8BAChKoib0D0GNVnVBUZMkF1nC81xwM4Wj3Ic8Ow3ePRwTRaUlqX8EsTvDbO9RLeALGSrN50xHnH/vi0+FYq/SNGrfxRZ6ac0YnnU9jihmdEYm6Utu2VYN6R1EGFO5upB4UQJ/SkO3IiLaVNW82LPQbWsJMQ+cXk6A+2jkdTXqLAgMBAAGjQjBAMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFA/S9SidqazcF0a8muCcUT6HWFWPMA4GA1UdDwEB/wQEAwIChDANBgkqhkiG9w0BAQsFAAOCAQEAJSiHw0030rEWRB8sF/RgiHjDa8X6Yr7xP5KrbzmRIvnjjO0DpeOW8DOJ4YD++Hv0aUjvJ9xzXxjeeFiXMyLlpnknws1GXANYvx/o7ss1TWTVKRqKdviq8OoDPPvloL8EIUyFuTHw4e/Lapejd8hOs91pEXXVPEeHF4QQSH2cqqZ1fpmzgLtfFsCkQyCcwEY7imp49VYiaTuGtiIFn5gzxu/fS3RGqzwOIMZAEs82d2jINHP29lfalNCW1lYI9PUN/fIBtLV84x15iOJNMW5M2Th/9y6eirry/TCY9OMc+Xp8Eq44wZinWrezK7ges1Xa1XDY8AMylJ4Ai2WH6JgCuw=="
      ]
    },
    {
      "alg": "RS256",
      "kty": "RSA",
      "use": "sig",
      "n": "nPp-Jdf4tOYClmGLn7XewSoRNqEI59kAmAezojE0kX3OueeekJTN4A-kLN9StrO0MNfORkeGbAdYle3fIXN3TyFn-9MwTysCX4GQmTpRE2kEktHy1Gjd_7sGq7vw7_UfP2zwBMlsLt4JLElAhi_dwbASPvKPA5f1Sf-I67x4fN2iGdoRyGJauJ3vRiKhd_qXL7rh2Yfx3SCohEtNji_BwNtiRDSUgD2LOMN8NZ-3TlLRvZk5tN44Oe0_x9QTkCFqq6FngtC1HGHcPOj05DPM2H2_1GC5g156gJroUKMuahY4vdOKJaTecQ29e9Uz6aQrtl4GueeWwQ560v4t70HCMw",
      "e": "AQAB",
      "kid": "wWbdWIDy-Op5zSH4u53PM",
      "x5t": "351BhlP9swkmXZXjisbkeJkUSp8",
      "x5c": [
        "MIIDCTCCAfGgAwIBAgIJQH5gIZjaIVaqMA0GCSqGSIb3DQEBCwUAMCIxIDAeBgNVBAMTF2phbWlldGFubmEuZXUuYXV0aDAuY29tMB4XDTIwMDMxMzExNTg1N1oXDTMzMTEyMDExNTg1N1owIjEgMB4GA1UEAxMXamFtaWV0YW5uYS5ldS5hdXRoMC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCc+n4l1/i05gKWYYuftd7BKhE2oQjn2QCYB7OiMTSRfc65556QlM3gD6Qs31K2s7Qw185GR4ZsB1iV7d8hc3dPIWf70zBPKwJfgZCZOlETaQSS0fLUaN3/uwaru/Dv9R8/bPAEyWwu3gksSUCGL93BsBI+8o8Dl/VJ/4jrvHh83aIZ2hHIYlq4ne9GIqF3+pcvuuHZh/HdIKiES02OL8HA22JENJSAPYs4w3w1n7dOUtG9mTm03jg57T/H1BOQIWqroWeC0LUcYdw86PTkM8zYfb/UYLmDXnqAmuhQoy5qFji904olpN5xDb171TPppCu2Xga555bBDnrS/i3vQcIzAgMBAAGjQjBAMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFDFn7euS5mK9s5Hzieby3Y6R4Z/RMA4GA1UdDwEB/wQEAwIChDANBgkqhkiG9w0BAQsFAAOCAQEATqkteUMQsqjjbsStWXsQj3zz9aMA39q8exaogcV0T9JexN2hgunJGJAVB5yDupikj4jP61Ji02hEhnql3q7Kig9+SYRkK1E5RI4WoHm0c2oXj6GoKYnwlGsEsW/bPUr5CSEQXLte6czlfSCr0VW5XV8YuVjiO9E7yARXcVywFdToipT8F0lMbugkVBJO2k/n4RpJ2nO0rH0TMdgQDXsotUdvLAbsvppJl/+LHknY0pN7dXMhZVCiyfdLE9/LdQJxlpmFi65FF2XMwr2x/uTcP4hytRaQIsU9mE3scPAx5RFxCppZu9BcVbAZTJFl/PemhonaZolrOMAo8hq0AbJ3rg=="
      ]
    }
  ]
}
```

(Aside: if you're interested in what the certs look like, check out [_Extracting `x5c`s from a JSON Web Key Set (JWKS) to PEM files with Ruby_]({{< ref 2020-04-30-jwks-to-pem >}})).

By running this JWKS URI through the jwks-ical API, you will be returned with the following iCalendar representation:

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Michael Angstadt//biweekly 0.6.3//EN
BEGIN:VEVENT
UID:76becdc5-a56f-4c6b-ab92-c69ef2f52640
DTSTAMP:20200614T191639Z
DTSTART:20320621T080000Z
DTEND:20320621T200000Z
DESCRIPTION:The certificate for kid ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzU
 xQzc5MUY0MjI2Nw (with use: `sig` and subject: `CN=jamietanna.eu.auth0.com`
 ) is expiring on Mon Jun 21 12:01:32 UTC 2032
SUMMARY: Certificate expiry for ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzUxQzc
 5MUY0MjI2Nw
END:VEVENT
BEGIN:VEVENT
UID:5074509f-9fbe-4021-bd20-810d1e9d7c0a
DTSTAMP:20200614T191639Z
DTSTART:20331120T080000Z
DTEND:20331120T200000Z
DESCRIPTION:The certificate for kid wWbdWIDy-Op5zSH4u53PM (with use: `sig`
 and subject: `CN=jamietanna.eu.auth0.com`) is expiring on Sun Nov 20 11:58
 :57 UTC 2033
SUMMARY: Certificate expiry for wWbdWIDy-Op5zSH4u53PM
END:VEVENT
END:VCALENDAR
```

Which you can feed into your calendar reader of choice, and keep an eye on when your certificates are expiring.

## Providing more event context

If you've got lots of certs you're keeping an eye of, or if you want to make it more obvious when you've got a production certificate expiring, you can provide a value for the querystring parameter `prefix`:

```
https://europe-west1-jwksical-jvt-me.cloudfunctions.net/jwks-ical
  ?jwks_uri=$jwks_uri
  &prefix=Auth0+Production
```

Which generates a slightly different event description, to make it a little more obvious:

```diff
 DESCRIPTION:The certificate for kid ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzU
  xQzc5MUY0MjI2Nw (with use: `sig` and subject: `CN=jamietanna.eu.auth0.com`
  ) is expiring on Mon Jun 21 12:01:32 UTC 2032
-SUMMARY: Certificate expiry for ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzUxQzc
+SUMMARY: Auth0 Production Certificate expiry for ODg2MzE1Qzg5Q0Y3ODdCNjcxNUU1RURERkMzMzUxQzc
  5MUY0MjI2Nw
 END:VEVENT
```

## Insecure SSL/TLS configuration

Because I want to use this with Open Banking's certificates, I needed to disable the SSL/TLS validation, as `https://keystore.openbanking.org.uk/` uses a self-signed certificate.

Is this a dealbreaker for your own use cases? Let me know, and I can move to a per-JWKS configuration for insecure connections.

## Performance

This is a Java function, so note that performance isn't exactly going to be perfect. But a) I wanted to write it in Java and b) the performance doesn't need to be perfect, as it doesn't need to be realtime.

# Vanity URL

This is my first experience with [Google Cloud Functions](https://cloud.google.com/functions), and I've found it pretty fun to work with. Unfortunately I couldn't get a custom domain working properly with Google Cloud Functions, even using Firebase, so for now you can use `https://europe-west1-jwksical-jvt-me.cloudfunctions.net/jwks-ical`.

If that's a bit of a mouthful, you can use `https://u.jvt.me/jwks-ical` to remember it.

# Source Code

The source code for this can be found at [<i class="fa fa-gitlab"></i> jamietanna/jwks-ical](https://gitlab.com/jamietanna/jwks-ical), and is licensed under the AGPL3.

# Feedback

Feedback is always welcome - please feel free to raise an issue on [<i class="fa fa-gitlab"></i> jamietanna/jwks-ical](https://gitlab.com/jamietanna/jwks-ical), or contact me with one of the methods below.
