---
title: "How to Run Java on the Command-Line to Attach a Debugger"
description: "How to run `java` on the command-line, and make it possible to attach a debugger."
tags:
- blogumentation
- java
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-29T23:15:36+0100
slug: "java-debug"
---
It can be pretty useful to attach a debugging to a Java process, such as when you're running a JAR as a standalone process.

We can use the following to set up a debugger on port 5050:

```sh
# wait for the debugger to attach before running the process
java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5000
# don't wait for the debugger to attach before running the process
java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5000
```
