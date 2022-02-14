---
title: "Running a Java WAR File on the Command-Line"
description: "How to run a WAR file locally, using Jetty, without installing anything."
date: 2021-11-08T21:17:49+0000
tags:
- blogumentation
- java
- war
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "run-war-locally"
image: https://media.jvt.me/7e70383567.png
---
If you're working with Web WAR files for your web applications, you may want to deploy and test them locally.

In a lot of cases, you are unlikely to have a web server like Tomcat or Jetty installed and ready to go to, especially if you're wanting to test things infrequently.

This evening I've been trying to run the [MitreID Connect OpenID Connect reference implementation](https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server), which is packaged in a WAR, but I didn't want to set up a web server.

Fortunately, the Jetty web server makes it pretty straightforward to get up and running.

# Jetty 9

In pre-Jetty 10, there is the `jetty-runner` project, which makes it incredibly simple to get up-and-running with a single JAR file.

For instance, say we want to run a WAR under a specific context root, we can run the `jetty-runner` JAR as below:

```sh
java -jar jetty-runner.jar --path /openid-connect-server-webapp openid-connect-server-webapp-1.3.3.war
```

This then will allow us to access our application running on `http://localhost:8080/openid-connect-server-webapp`.

The JAR can be downloaded [from Maven central](https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-runner) - remember to get a 9.x release!

# Jetty 10+

Unfortunately in Jetty 10+ the `jetty-runner` has been made a no-op, so we need a slightly more complex setup, using the `jetty-home` project.

To get this working with the new version, we need to set up the [Jetty base dir](https://www.eclipse.org/jetty/documentation/jetty-11/operations-guide/index.html#og-start) by running the following:

```sh
# for our pre-downloaded ZIP
unzip jetty-home*.zip
cd jetty-home*
java -jar start.jar --add-module=http
# other modules may be required
cp /path/to/openid-connect-server-webapp-1.3.3.war webapps/openid-connect-server-webapp.war
```

This then will allow us to access our application running on `http://localhost:8080/openid-connect-server-webapp`.

The ZIP can be downloaded [from Maven central](https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-home) - remember to get a 11.x release!
