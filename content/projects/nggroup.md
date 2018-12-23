---
layout: project
date: 2015-01-7
title: nggroup
image: /img/projects/nggroup.png
github: jamietanna/nggroup
gitlab:
description: Fine grained user/group access control for nginx basic HTTP authentication.
tech_stack:
- bash
- python
project_status: open-sourced
---
When working at Intel, I was administering a server which required multiple users to have access to different areas of the web server via authentication means. Instead of working on some sort of server-side application to manage this, I decided to go with HTTP Basic Authentication. However, to reduce the amount of repetition needed, I threw together a script called Nginx htgroups, or nggroup for short, which provided a CLI-driven method of organising multiple users and their access rights.
