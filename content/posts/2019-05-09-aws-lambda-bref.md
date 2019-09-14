---
title: "PHPMiNDS May: Running your PHP site on AWS Lambda with Bref"
description: "The May edition of the PHPMiNDS meetup, and things I've learnt about porting existing applications to AWS Lambda."
tags:
- events
- phpminds
- serverless
- aws-lambda
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-09T22:19:50+0100
slug: "aws-lambda-bref"
aliases:
- /notes/dc1e847e-c02f-453b-84d0-91e824be6a57/
- /mf2/dc1e847e-c02f-453b-84d0-91e824be6a57/
---
Tonight at https://phpminds.org/ we had a talk from Neal (https://medium.com/@nealio82) about https://bref.sh and how you can use it to build serverless PHP applications.

Neal spoke about how, although PHP is officially supported in AWS Lambda, the difficulties of getting it running are still quite high, especially the complexities of getting Lambda Layers working.

This is where Bref comes in, which helps you scaffold the application and provide an easier interface for running applications on Lambda.

Neal spoke about how Bref was built to remove choices from you, rather than allow you to make things super configurable, as an opinionated setup is easier to manage and build for.

I was quite impressed with the AWS' Serverless Application Model (SAM) command-line tool and how you can easily spin up your serverless application locally - very cool!

An aside, but an interesting tidbit of info was that AWS charges you for CNAME lookups, opposed to A records which don't cost anything - a good thing to be aware of!

Neal started off by showing us a PHP page running `<?php phpinfo(); ?>`, but noted that it wasn't super impressive. So for something much more exciting, Neal took us through taking an existing application using a PHP framework, and chucked it onto Lambda with Bref, in an *incredibly easy fashion*. I was incredibly bowled over how easy it was. All we needed to do was:

- refer static assets to an S3 bucket/Content Distribution Network, not on the same host as the PHP process
- externalise session stores, as you will most likely hit a different instance of your function
- externalise your file store, i.e. an S3 bucket, as you can't store files long-term in a function's container, which can be done with pre-signed URLs

And now we had a pretty standard PHP app, with an admin backend, working in AWS Lambda. Awesome stuff.

As Neal mentioned, now we're delegating some of these pieces of work to the cloud provider, we can remove a load of code from our application - win-win!

Neal mentioned there are some performance impacts of running Lambdas in an AWS VPC, and how they can be ~10x increase in response times (citing https://medium.freecodecamp.org/lambda-vpc-cold-starts-a-latency-killer-5408323278dd)

But Lambda can still make huge differences to your underlying bills - one user of Bref cited that for quite large workloads, they were saving ~25% against EC2.

Neal also mentioned that there has been some work towards getting WordPress running on Lambda, although it's still very much a work in progress.

Although I'm not a PHP dev, it was a great talk, and I can see lots of great things that I can apply to my own projects.
