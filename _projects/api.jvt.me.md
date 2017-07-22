---
layout: project
title: '`api.jvt.me`'
image:
github:
gitlab: jamietanna/api.jvt.me
description: An API to get information about me.
project_status: planned
---
This is an API to get information about me, born out of house hunting, and realising that to get certain information, such as previous addresses, I needed to search through emails to find exact details.

Currently, this is just a specification for the API. The implementation is yet to be completed.

The aim is that this will be a static API; it is not possible to update the API via standard HTTP verbs. The configuration for API data will be via static files that will be parsed by the API, leading to the endpoints being populated.

Note that this will include both public and private information, therefore will require authorization to be considered, to ensure that this information is not made public.
