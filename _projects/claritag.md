---
layout: project
date: 2015-11-1
title: Claritag
image: claritag.png
github:
gitlab: rwdrich/claritag
description: A web application to automatically categorise your Dropbox photos for you.
tech_stack:
- flask
- dropbox
- clarifai
- mysql
project_status: open-sourced
---

Claritag is a web app that categorises photos in a user's Dropbox folder. The categorisation is done through the Clarifai API, which provides an endpoint for us to send through a link to the image. Fortunately Dropbox provides the [`.media`](https://www.dropbox.com/developers-v1/core/docs#media) API call, which allows us to get a public link to the file so we can plug it into Clarifai's API. If we did not have this available, we would need to provide some public facing server, such as AWS S3 or DigitalOcean in which to save these images temporarily for analysis.

We list all top-level JPEGs and PNGs inside our `/Photos` folder in Dropbox, and utilise the above API call to collect the tags from Clarifai's API. We store the top 10 tags in a database entry (with a horribly un-normalised schema; sorry, this is hackathon code!) for later collection.

When a user browses to `http://localhost:5000`, they will be presented with the list of all tags found in the database, linking to a separate page to list all images which have been found for that image.
