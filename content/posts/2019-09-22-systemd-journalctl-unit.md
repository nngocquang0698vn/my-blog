---
title: "Viewing Logs for a systemd Unit with `journalctl`"
description: "How to view the logs for a given unit, using systemd and `journalctl`."
tags:
- blogumentation
- systemd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-22T10:12:59+0100
slug: "systemd-journalctl-unit"
---
When running systemd, the journal stores all the logs that are associated with the various services running under it.

This means that if you want to have a quick look through you'll likely have a lot of noise for other services, which may make it harder to find what you're looking for. If you know the unit you're looking to get the logs for, i.e. `micropub.service`, you can run the following:

```
$ journalctl -u micropub.service
-- Logs begin at Sat 2019-09-21 17:18:35 CEST, end at Sun 2019-09-22 10:46:25 CEST. --
Sep 21 18:24:43 www-api java[5513]: 2019-09-21 18:24:43.593  WARN 5513 --- [nio-8080-exec-1] o.s.web.servlet.PageNotFound             : Request method 'GET' not supported
Sep 22 08:21:51 www-api java[5513]: 2019-09-22 08:21:51.063 ERROR 5513 --- [nio-8080-exec-3] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception
Sep 22 08:21:51 www-api java[5513]: java.lang.IllegalArgumentException: Error when fetching token endpoint (unauthorized): The token provided was malformed
Sep 22 08:21:51 www-api java[5513]:         at me.jvt.www.api.micropub.security.IndieAuthAuthenticationResolver.resolveAuthenticationFromToken(IndieAuthAuthenticationResolver.java:36) ~[classes!/:na]
```
