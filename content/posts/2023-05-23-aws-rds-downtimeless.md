---
title: "Performing downtime-inducing AWS RDS changes with no downtime&star;"
description: "How to limit your downtime to seconds, instead of minutes, when performing downtime-inducing changes with AWS RDS."
date: 2023-05-23T21:33:36+0100
tags:
- blogumentation
- aws
- databases
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/770ef46545.png
slug: aws-rds-downtimeless
---
Sometimes you need to make changes to your AWS RDS databases, such as changing the instance size, or performing routine DB engine upgrades.

As [the AWS documentation notes](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html), some of these incur downtime.

Depending on the size of your database, that downtime may be significant, and if you've got a globally deployed and used service, it may be hard to find "the right time" for that downtime.

Something I've learned recently - through some very talented colleagues at Deliveroo - is that you can minimise the downtime by applying the changes very slowly through your cluster - assuming you have a cluster, that is.

In a recent change we had ~15 seconds of downtime instead of potentially > ~10 minutes!

Let's say that your cluster looks like:

- `service-0` (Writer)
- `service-1` (Reader)
- `service-2` (Reader)
- `service-3` (Reader)

And that we're wanting to upsize all the instance sizes.

And let's assume that you're using Terraform to manage your infrastructure, but you can get access to the AWS console to perform changes if absolutely necessary - like in this case.

We would log into the AWS console - with our administrative access - and go to the RDS console.

Then, for `service-1`, apply the change, for instance upsizing your instance. When I did this the other day, it took ~10 minutes.

Depending on how confident you are with multiple read nodes being down, you could parallelise multiple of these at once. If not, we'd repeat this process with each Reader until we're done.

Finally, once the Reader nodes are all upsized, it's time to upsize the Writer.

But **wait**!!

We can't do that yet, as the Writer is still being heavily used. At this point, we trigger a failover in the cluster - and here's where the downtime comes in - which makes i.e. `service-1` the new Writer, and `service-0` will be a Reader.

Now, we can safely trigger the upsizing of `service-0`.

Finally, once we're all done, we should merge the Terraform code to make sure that the state in production matches our infrastructure-as-code.
