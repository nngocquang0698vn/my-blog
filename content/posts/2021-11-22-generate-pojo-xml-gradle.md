---
title: "Generate Plain Old Java Objects (POJOs) from XML Schema Definitions with Gradle"
description: How to generate POJOs really quickly and easily, with no manual work, using the Gradle XJC Plugin.
tags:
- blogumentation
- gradle
- java
- xml
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-22T17:35:34+0000
slug: "generate-pojo-xml-gradle"
---
My blog post [_Generate Plain Old Java Objects (POJOs) from XML Schema Definitions with `xjc`_](/posts/2020/02/03/generate-pojo-xml-xsd/) is pretty popular, and I've enjoyed getting use out of it myself. But the problem with this is that it introduces a number of source files into your repo, which you then need to maintain in terms of your own code style standards, maybe manage Javadoc, and generally add a lot of code to your codebase that isn't _yours_.

One thing we can do instead is utilise [Gradle XJC Plugin](https://unbroken-dome.github.io/projects/gradle-xjc-plugin/) to automagically generate these files each time we do a build.

To make this work, we need to do two things. Firstly, we need to put the XML Schema Definition (XSD) in our project under the `src/main/xsd` directory. The plugin will iterate over all XSDs it can find, generating them as necessary.

Next we need to add the Gradle configuration to hook in the plugin:


```groovy
plugins {
  id 'org.unbroken-dome.xjc' version '2.0.0'
}

xjc {
  srcDirName = 'xsd'
}
```

It's that simple! You can now reference the classes from your regular code, but you may need to compile the project first if the classes aren't showing up in your IDE.
