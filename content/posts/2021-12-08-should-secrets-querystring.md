---
title: "Should That (Secret) Thing Be In Your Querystring?"
description: "Why you should be very cautious about putting potentially sensitive values into the querystring of web APIs."
tags:
- api
- security
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-08T16:34:27+0000
slug: "should-secrets-querystring"
---
In the past, I've worked with quite a few APIs that have a required querystring parameter which is used to provide specific parameters, such as an API key.

Aside from the API best practice of not making querystring parameters required, this is a straightforward pattern to make it easier to test an API, especially from a browser.

I've seen a few things in querystrings to APIs that you probably don't want in there, and hope this non-exhaustive list will give you some food for thought:

- `access_token` / `access_token_key` + `access_token_secret`
- `api_key`
- `date_of_birth` and `postcode` (or other data that could be used to impersonate people for Knowledge Based Authentication journeys)
- Signed JSON Web Tokens

With my history in financial services, I've had a number of cases where we've discussed the visibility of pieces of data in logs, querystrings, and other means, and it's helped me think a bit more carefully about what's exposed in my APIs.

But even if you don't feel you've got anything too dangerous, consider how the HTTP request will reach your API. There will likely be at least two layers of networking before the actual API is served, such as an API Gateway and a load balancer, but there could be more layers.

Each layer introduces more risk that logging is either purposefully or inadvertently enabled - for instance Nginx access logs are usually enabled by default - and it's very common for URLs (including querystring) to be logged. Also note that these could be logged in a customer's browser, which could be going through a proxy server or on a not-well-secured network, introducing further chance for leakage.

Instead, if we move these values to a POST request body, or into HTTP headers, they're _much_ more unlikely to be logged, as these commonly contain sensitive information that shouldn't be logged.
