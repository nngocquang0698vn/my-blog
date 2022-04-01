---
title: Adding a Non-AWS Hosted Custom Domain to an AWS API Gateway without CloudFront
description: How to set up a domain name for AWS API Gateway for a domain that isn't managed through AWS Route 53.
tags:
- blogumentation
- aws
date: 2022-04-01T15:37:30+0100
syndication:
- "brid.gy/publish/twitter"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/770ef46545.png"
slug: "api-gateway-domain"
---
I run a number of services using the [Architect Framework](https://arc.codes), which makes running services on AWS API Gateway really straightforward.

As I wanted slightly nicer URLs for my services, instead of the default API Gateway URLs, I wanted to attach custom domain name. However, one thing that I found a bit frustrating was that a lot of guides that folks have produced to do this require using CloudFront, and I didn't need CloudFront for my purposes.

I thought I should document how I've done it for anyone else going through this in the future.

Note that the screenshots below may come out of sync over time with AWS, but hopefully it will still remain similar enough this can be followed.

First, browse to the API Gateway console and click the `Custom domain names` link in the sidebar:

![Screenshot of the API Gateway console, showing several APIs, and on the left hand sidebar, a link to APIs, Custom domain names, and VPC links](https://media.jvt.me/3f776f8cbe.png)

Next, we `Create` a new domain name, and specify the domain name we want. In my case, I'm setting up the domain name `tiktok-mf2.tanna.dev`.

![Screenshot of the Custom domains name page, showing several domain names, and a Create button](https://media.jvt.me/31da960779.png)

We need to set up a certificate in Amazon Certificate Manager (ACM) to provide us a secure means of interacting with our API Gateway. Because this is needed as part of the domain name process, we need to click `Create a new ACM certificate` and complete that process before returning.

When we do return, we'll then have a list of endpoints available in the Endpoint configuration box:

![A list of endpoints in a selection box when clicking the Choose a certificate option](https://media.jvt.me/41166e0389.png)

Once created, we can see the `API Gateway domain name`, shown below:

![Screenshot of the newly created domain name, showing the endpoint configuration, with a API Gateway domain name, and a tab for API mappings](https://media.jvt.me/285b41ff79.png)

This domain name noted above is the domain that we need to CNAME, for instance:

```
; <<>> DiG 9.18.1 <<>> tiktok-mf2.tanna.dev
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20072
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;tiktok-mf2.tanna.dev.          IN      A

;; ANSWER SECTION:
tiktok-mf2.tanna.dev.   3600    IN      CNAME   d-f6nzqppwe5.execute-api.eu-west-2.amazonaws.com.
d-f6nzqppwe5.execute-api.eu-west-2.amazonaws.com. 60 IN A 3.10.130.88
d-f6nzqppwe5.execute-api.eu-west-2.amazonaws.com. 60 IN A 18.168.240.252
```

This is the most important part, I've often trialed using the API Gateway ID, instead of the domain name, which does not work.

Remember that we need to add the `API mapping`s, otherwise our traffic will not be routed to the right API:

![Screenshot of the empty API mappings page, before the API has been configured](https://media.jvt.me/19ed59f220.png)
![Screenshot of the in-progress configuration for the API mapping](https://media.jvt.me/6741fe10ff.png)

Et voilà, we can successfully access our service on the domain!
