---
title: "{{ replace (.Name | replaceRE "^[0-9]{4}-[0-9]{2}-[0-9]{2}-" "") "-" " " | title }}"
description: ""
tags: []
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: {{ .Name | replaceRE "^([0-9]{4}-[0-9]{2}-[0-9]{2}).*" "$1" }}
slug: "{{ .Name | replaceRE "^[0-9]{4}-[0-9]{2}-[0-9]{2}-" "" }}"
---
