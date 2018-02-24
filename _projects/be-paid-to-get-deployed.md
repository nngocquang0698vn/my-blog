---
layout: project
title: Be Paid to Get Deployed
image: /assets/img/projects/be-paid-to-get-deployed.png
date: 2017-10-22
github:
gitlab:
description: A tool to allow auto-deployment of web development changes upon full payments from clients.
project_status: completed
tech_stack:
- flask
- github_status
- quickbooks
- starling
---
The project was built to be a way to allow freelance web developers to push amends to client sites upon receiving full payments.

The flow is as follows:

1. Developer makes change on feature branch
1. Developer raises PR to main branch
1. WebHook is triggered to _Be Paid to Get Deployed_
1. _Be Paid to Get Deployed_ queries QuickBooks API
1. QuickBooks API returns whether the payment has been received in full

A client can then be informed that the changes have been made, and an invoice has been sent. The flow is then:

1. Client makes a payment into a Starling bank account
1. Starling triggers a WebHook on _Be Paid to Get Deployed_
1. _Be Paid to Get Deployed_ triggers a payment to QuickBooks
1. _Be Paid to Get Deployed_ updates the status of the GitHub branch status
1. If the branch status succeeds, merge the changes!
