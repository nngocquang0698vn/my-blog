---
title: "AWS Nottingham: Where Did All the Money Go?"
description: "A writeup of the AWS Nottingham meetup about cost saving in AWS."
tags:
- aws
- cloud
- cost-saving
- events
- nottingham-aws-meetup
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-20T22:32:29+01:00
slug: "aws-cost-saving"
---
[Ian Harris](https://twitter.com/ian_x_harris) gave us a really interesting talk <a class="u-in-reply-to" href="https://www.meetup.com/Nottingham-AWS-Meetup/events/263190185/">tonight at AWS Nottingham</a> about AWS and some great ways to not burn money.

Although the below is very AWS specific, there are a number of points that relate across all Cloud platforms.

I've also intertwined Ian's thoughts with my own, so be aware this post may not be quite the same as if you were in the room!

# Why is it hard?

It's unfortunately really hard because a lot of these issues are the intersection of culture and technology issues.

Some teams may be happy paying a little more money to deliver quicker, but then don't want to (or aren't given the time to) go back and re-size their instances afterwards. And on the other hand you have the finance team or your leadership wanting you to try and squeeze every last CPU credit out of your instance.

It's most definitely a cultural and people issue, rather than anything you can throw the tech at, which is something for you to solve in your company! But there are some tips on the technical side that you can use to push ahead once you've got the buy-in.

# Six Rs

Ian shared the six Rs which are common in Cloud Migrations.

If you're looking to migrate, you have three stages:

- Rehost - lift and shift your software to the Cloud
- Replatform - lift, shift and tinker
- Refactor - can we rewrite / largely tweak this application to become more Cloud Native?

As well as some steps that are the exact opposite of migration:

- Repurchase - can we replace i.e. our Identity platform with an outsourced, hosted solution?
- Retire - can we completely delete that service? Is it needed, now we're thinking about it?
- Retain - don't touch it... yet

## Rehost

Ian mentioned that most organisations feel that rehosting the application is generally the easiest solution, because what can go wrong with lift-and-shift?

Well, most likely we'll be over-sizing the compute resources, won't look at replacing things like load balancers with an ELB, or replacing an Oracle database with i.e. Aurora. This leads to a large amount of tech debt, which could also come in the form of literal monetary costs!

Ian mentioned that he's seen some folks work on this where there are tight deadlines i.e. "we're not renewing our datacentre lease that's due in 3 months", as well as doing an easy proof of concept, but then try and migrate a legacy spaghetti mess and complain that it wasn't as easy.

We also heard a little about the cost implications of shift-and-lift in respect to Red Hat Enterprise Linux (RHEL) licensing, and how it often doesn't make sense to keep it in the Cloud (unless you have bring your own licensing that you can use on EC2). Sharing a visualisation where a t2.small instance is 476% more expensive on RHEL than Amazon Linux, compared to a t2.medium which is only 120%. Some of these numbers showed that if you're not careful, the "we did this on-prem" argument can really start to cost you!

## Replatform

On the other hand, if you have a little more time you can look to decide what you can tweak.

For instance, can I tinker with my Non-Functional Requirements and sacrifice a little latency to spend $100/mo less per instance? What if I'm no longer running active-active resiliency, and instead just look at a cold Disaster Recovery setup?

Also, look at whether you do really need a feature of i.e. an Oracle database, or as above, can you drop the RHEL requirement of your platform?

And can we stick an ELB in front of our app, instead of hosting an F5 load balancer or Nginx?

Ian mentioned that this is largely around having some fun and experimenting with some of the offerings as part of AWS, and then thinking a bit more pragmatically around "do I actually need that vendor-provided feature?"

## Refactor

We didn't spend too much time talking about this one, but it's an interesting one, especially if you're a bit more lax with your timelines to migrate applications.

For instance, what if you rewrote large swathes of the application to take on board [12 Factor Application principles](https://12factor.net/) or to be a [Cloud Native application](https://pivotal.io/cloud-native)?

This gives your teams a good chance to dissect the legacy and build something more maintainable, but also likely find places where you can rip out existing functionality and replace it with libraries or existing solutions.

## Repurchase, Retire and Retain

Again, we didn't really talk about this that much, but these are interesting to think about too.

Having the opportunity to decide whether we even need to migrate something is a good way to look at things realistically and decide whether they're needed. Or it may be that they're more of a pain than could be expected so there's a lot of groundwork that other teams can do before tackling this big one.

# Cost impact in migration

Ian spoke about how "every decision you make from logging into the console costs", so you _really_ need to think carefully about what you're going to do.

Ian mentioned that as an AWS Partner, his employer [BJSS](https://bjss.com), has great experience with these things, and helping to plan your Cloud migration. But even if not BJSS, other AWS Partners or even AWS themselves can help you get you on your way if you're needing a hand.

It's also important to try and avoid thinking "well, we did this on-prem" when instead you can look at driving out new patterns for the Cloud i.e. replacing the mindset of "hey I've already got an EC2 with resources for this API, why don't I put another service on that instance, as that's what we do on-prem".

Ian also warned about becoming "Shadow IT", where you i.e. use your boss' credit card to foot the bill, as it helps you avoid organisation issues, but has severe impacts to the business!

Ian also mentioned we should look to have Proof of Concepts to help get business buy-in on the architecture and expected costs.

# Optimise

But once we've got the applications live, we've still got work to do on optimising the running costs.

AWS has a few models for how EC2 works:

- On Demand - A Pay as You Go model where it's easy to get running, flexible as you can use what you want, when you want, but you pay a bit more
  - It's mostly possible to get the EC2 instances that you want, but there can be shortages if there are no on-demand m4.larges left at that given time
  - This can be helpful before you want to commit to anything, and is fairly common
- Reserved - A bit of a commitment, but allows you save a chunk of money, and be guaranteed to get the instance type you want (from your pool of reserved instances)
  - This has a lot of options for you to think about in terms of expected usage, but also you can use more than what you need, it'll just then be back to on-demand
- Spot
  - Amazon's spare capacity EC2s which can be torn up and down with very little notice, so your workloads need to be able to spin up quickly, and not take on too much work
  - Can be _huge_ cost savings
  - Great for use in development environments where it doesn't 100% matter about production quality performance, or 100% uptime
  - Prices differ per Availability Zone so investigation required

# Scaling

Ian spoke a little about how we can look to scale our instances - completely rigid, or very elastic.

## Scaling with On Demand / Reserved Instances

With rigid scaling, we know we're going to waste resources - be it too much, or too little. We can have 2 instances running, but if we receive a load spike we need to manually go in and increment the instances in the Auto Scaling Group / create and then add another instance to the Load Balancer. This means we need to know how much traffic we're going to get, and scale accordingly, but we have the risk that we'll be using fewer resources than we're paying for, as it's then able to handle a bit more load than usual.

One great way to save cost with rigid scaling is to scale down to very low capacity in off hours (for whatever measurement that means to your own applications, if even applicable) rather than thinking "in the afternoon we have 40% load, so we can scale to 40% servers" as that may take a bit more engineering work than just saying "overnight we'll run 1/4 instances".

However, with elastic scaling, we can say to our Auto Scaling Group to spin up a new instance if the other instances are above a certain threshold, i.e. 80% CPU if the application is CPU bound. This is largely better, but requires some thinking in terms of how best to set your scaling to work.

## Scaling with Spot Instances

As mentioned, Spot Instances can save a huge amount of money, provided your workload can be run in a way that may have a minute to prepare for shutdown.

Ian warned against using T2 instances with Spot instances because of the way it can exhaust CPU credits, they can cause AWS to block your usages until you get in touch with them!

T3 instances are useful, but you can't turn of T3 Unlimited unless you're using [Spot Fleet](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet.html).

Also, if you can, try using containers within the Spot instances to try and reduce the size and runtime of the EC2s.

As before, think about whether you need RHEL for your workload, as again you can save a lot of money by going with Amazon Linux.

# Tips for Using Reserved Instances

We heard a little bit about the different models that you can use with Reserved Instances, and how different choices can affect the bottom line.

Ian mentioned that it's important to decide whether you want to go for Standard Reserved Instances, which won't allow you to change instance families, but does let you sell unused instances to other users (for a reduced selling price). Alternatively you can go for Convertible Reserved Instances, which allow you to change families if you find that you don't want to use many m4 instances one month, but do need a lot of t3 instances. But of course, the flexibility comes at a cost.

There are options with respect to how much you want to pay up front, as well as whether you want to reserve for 1 year or 3 years.

Ian noted that for some organisations, they may be happy with paying for reserved instances all up front for 3 years as it's very similar to their on-prem model of buying hardware.

We then heard a little bit about how we need to maximise the use of these reserved instances, otherwise you're burning money - keep an eye on it, and push teams to use the reserved models if possible.

# Serverless

We heard a little bit about difficulty of working with AWS Lambda (and Serverless tooling in general) which is that it's going to be cheap, _until it isn't_.

Ian's had some great experience where once the Lambdas have been written, the only operations burden has been a billing alert, and that other than that, they've _just worked_.

However, an issue with Serverless is that you are unfortunately going to have a fair bit of lock-in. Although the code "runs anywhere", you're going to be tied into the ecosystem of API Gateway, DynamoDB, CloudWatch logs, Secrets Manager, KMS, SQS, and maybe a VPC + NAT. These can also be quite expensive to spin up and down, so it's worth keeping some around and shifting them around, instead of each developer having 1 environment they completely own, you could have a pool of some of these that they can own.

Some of the lock-in within your code can come from building mappings for each Cloud environment, which you can avoid somewhat with [Serverless framework](https://serverless.com) or I've used [Spring Cloud Functions](https://cloud.spring.io/spring-cloud-function/) in the past to allow me to write code that had no understanding of AWS Lambda, but was able to be built to work with it transparently to the core code.

Also, as with the EC2 model, remember to look at reserving capacity vs running it on-demand, if you're aware of what your capacity may be.

# So What am I Spending?

There are a few tools within AWS that can help:

- [Billing Information](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/getting-viewing-bill.html)
- [Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/) which can have some great visualisation
  - It's worth making sure that you tag your resources in a uniform way to make breakdown easier!
- [Trusted Adviser](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) - can be useful, but can be quite optimistic
  - Also misses out on context i.e. a Load Balancer not being used that much would have a time cost to spin up/down if it's needed, so it's not worth the investment

But also remember that Data Transfer is something that will likely catch you out:

  - especially cross-account or cross-VPC
  - think about whether you need to i.e. perform performance testing cross-account/cross-VPC, or whether you can run it all in the same account/VPC
  - think about whether you even need communication across VPCs

## Resource Optimisation Recommendations

Ian mentioned there is some new functionality in Trusted Adviser which looks like it'll make things much better.

This takes 14 days of background info for usage, taking into account more contextual information (such as disk / memory usage if you allow the CloudWatch Agent to run on the EC2) and provide a better recommendation.

Ian noted that it's still quite conservative, so will only tell you to go down from an `m4.xlarge` to an `m4.large`, but you can keep monitoring, or make judgement calls.

It also takes into effect the usage of Reserved Instances, and tells you whether you should be using a Reserved Instance for your services if there are instances available.

Finally, **remember that you know best**! It's your service, so you'll know better how it'll respond. For instance, if you know the instance is memory-bound, not CPU-bound, there's no point increasing the CPU sizing of the instance.

# CloudWatch Log Insights

Ian mentioned about how in the past, most people didn't really touch CloudWatch as-is, but instead dumped all their logs to CloudWatch, then used a Lambda to pump them into ElasticSearch which was then easier to read.

However, the issue with that is that you're paying for storage in two places, as well as the execution time of the Lambdas, and aren't really getting a good experience.

AWS have taken this feedback onboard that the CloudWatch log parsing / searching experience isn't ideal, so have brought out [CloudWatch Log Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html).

This is a Pay As You Go model again, but in Ian's examples they've parsed ~15 million rows of data for less than 2 cents, and ~14 billion rows for roughly $4. That's a huge saving, especially if you're able to refine the logs to something more usable, in a pretty usable timeframe too, without needing to set up the infrastructure + log-refining tooling.

Log Insights helps give you better visibility on operations issues from any logs that may be running through AWS, and can be a great experience when you get them working.

Ian did however, warn us of the documentation not being great for their custom query language, and I can agree that it's not the best, especially when coming from some of the searches you can do with an ELK stack. However, AWS are meant to be working on the developer experience of Log Insights, so keep an eye out for updates.

# TL;DR

Ian's TL;DR was:

- Switch things off when you don't need them
- Beware ancillary costs i.e. network traffic
- There isn't a right answer, just a lot of suggestions that may or may not help for your workloads
- Don't accept conventional wisdom, experiment and find what works for your workloads
- As is unfortunately the case in a large amount of technology issues, people problems are harder than the tech

I found it interesting to see some more about how to save money on AWS, as at [Capital One](https://www.capitalone.co.uk/), we have a fair amount of tooling from the enterprise, such as the [Open Source'd Cloud Custodian](https://github.com/capitalone/cloud-custodian), as well as a number of other quite specific Capital One tools for determining cost improvements.
