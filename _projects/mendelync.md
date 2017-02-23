---
layout: project
date: 2014-10-4
title: Mendelync
image: mendelync.png
github:
gitlab:
description: An Android application to provide easy access to Mendeley papers via NFC.
tech_stack:
- nodejs
- android
- mendeley
---

Mendelync is an Android application that simplifies the process of authorizing access to Mendeley papers.

For instance, at a conference, an attendee enters a request to access a paper, and then can go to the author and be able to simply tap the two phones together. This is done via NFC, and transmits the request, which the app on the author's devices then pushes to a Node.JS backend to perform the processing through Mendeley's API.

The initial version also worked with NFC rings, which had to have authorization codes manually written to them. Unfortunately this wasn't as user-friendly, so we moved to creating an Android app.
