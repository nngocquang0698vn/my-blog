---
title: "Pretty Printing XML on the Command-Line"
description: "How to use `xmllint` to pretty-print XML/HTML files."
tags:
- blogumentation
- html
- xml
- pretty-print
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-17T21:47:31+0000
slug: "xml-pretty-print"
---
A couple of times recently I've found that I need to pretty-print XML - be that HTML or actual XML, but haven't found a great way from the command-line.

Fortunately [DuckDuckGo has an HTML Beautify setup](https://duckduckgo.com/?q=html+beautify&ia=answer) but that's not super safe for proprietary content, nor for automating the pretty-printing.

But as I found today, it turns out that the [`xmllint` command](https://linux.die.net/man/1/xmllint) can save us here.

For instance, take the following XML file that I've purposefully uglified:

```xml
<?xml version="1.0" encoding="UTF-8"?> <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> <modelVersion>4.0.0</modelVersion> <groupId>me.jvt.www</groupId> <artifactId>www-api</artifactId> <version>0.5.0-SNAPSHOT</version> <modules> <module>www-api-web</module> <module>www-api-acceptance</module> <module>www-api-core</module> <module>indieauth-spring-security</module> </modules> <packaging>pom</packaging> </project>
```

If we feed this through `xmllint --format`:

```sh
$ xmllint --format in.xml
```

We then get the following pretty-printed XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>me.jvt.www</groupId>
  <artifactId>www-api</artifactId>
  <version>0.5.0-SNAPSHOT</version>
  <modules>
    <module>www-api-web</module>
    <module>www-api-acceptance</module>
    <module>www-api-core</module>
    <module>indieauth-spring-security</module>
  </modules>
  <packaging>pom</packaging>
</project>
```

If you are using this to pretty-print HTML, you can use:

```sh
$ xmllint --html --format in.html
```

But note that it will not ignore any non-standard HTML elements, or anything that it doesn't understand at least.
