---
title: Overengineering Your Personal Website - How I Learn Things Best
layout: talk
type:
- lightning
description:
  I often want to test new things, but don't have many full on projects. If I want to test a full deployment pipeline, from local development to production, I need something to deploy. So I've made my personal website _super complicated_.
---
In this lightning talk, I'll take your through the journey I've taken to making a static site _super complicated_.

From a simple Jekyll site, I now run Jekyll with a number of plugins, minified with Gulp, using Browsersync for development. Then, in order to test for broken links, I use HTMLProofer. And finally, for the deployment, I use Capistrano and Docker onto a server provisioned with Terraform and Chef.

Really, though, this has all been a journey to experimenting with different tools and parts of the tech stack, giving me more understanding about CI/CD and the steps that are essential for a software projects such as testing and reproducibility. Additionally, it's given me more understanding of Docker, and producing lean (or in my case not quite so lean) built artefacts.
