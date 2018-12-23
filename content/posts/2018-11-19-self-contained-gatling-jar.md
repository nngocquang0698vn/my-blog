---
title: 'Creating a versionable, self-contained (fat-/uber-) JAR for Gatling tests'
description: Why you'd want a fat JAR for your Gatling tests and how you'd achieve it.
categories:
- blogumentation
tags:
- java
- gatling
- testing
- jar
- artifact
- artefact
- maven
- uber-jar
image: /img/vendor/gatling-logo.png
date: 2018-11-19
---
## Why

The reasoning behind this post is very similar to [_Creating a versionable, self-contained (fat-/uber-) JAR for Cucumber tests_]({% post_url 2018-08-16-self-contained-cucumber-jar %}), but doesn't include the comment about the separation of unit tests and cucumber steps.

This means that the two reasons we'd want a fat JAR is:

- We want to have a versionable artefact for our Gatling tests
- We only want a single JAR downloaded, which contains our dependencies as well as simulations and scenarios, rather than all of the dependencies separately

As mentioned in the Cucumber post, we don't necessarily want both of these, but they're both achieved with this approach.

## Before

A traditional setup for a Gatling project in Maven is as follows:

```
pom.xml
src/test/scala/me/jvt/hacking/BasicSimulation.scala
src/test/scala/me/jvt/hacking/OtherSimulation.scala
```

Our POM uses the `gatling-maven-plugin` to run our tests, hooking it into the `verify` phase:

```xml
{% include src/self-contained-gatling-jar/before/pom.xml %}
```

When we perform a `mvn clean verify`:

```
{% include src/self-contained-gatling-jar/before/mvn-verify.txt %}
```

Also notice the warning about the JAR not having anything to be included in it. This is expected, as at this stage we don't have anything in `src/main` to be included:

```
{% include src/self-contained-gatling-jar/before/jar.txt %}
```

## After

To enable the creation of a self-contained Gatling artefact, we first need to move our Gatling files from `src/test` to `src/main` to fit within Maven's directory structures:

```
pom.xml
src/main/scala/me/jvt/hacking/BasicSimulation.scala
src/main/scala/me/jvt/hacking/OtherSimulation.scala
```

Then, we need to make sure that the `scala-maven-plugin` is hooked in to to the `compile` phase, so our Scala files are built and available to be pulled into the JAR:

```diff
{% include src/self-contained-gatling-jar/after/pom.xml.diff %}
```

Note that we're marking the `packaging` of the project as a `jar` because we've now got an actual artefact that this project creates.

```
{% include src/self-contained-gatling-jar/after/jar.txt %}
```

Now, when we perform a `mvn clean verify`:

```
{% include src/self-contained-gatling-jar/after/mvn-verify.txt %}
```

It builds as before, but as we can see, there's a bit more in there which relates to building the JAR.

We set the Gatling class as our `main` to allow us to run the JAR on its own, allowing us to specify the simulation on the command-line:

```
{% include src/self-contained-gatling-jar/after/run-jar.txt %}
```

We ideally should remove our `gatling-maven-plugin` and instead run our JARs separately:


```diff
{% include src/self-contained-gatling-jar/after-exec/pom.xml.diff %}
```

## Notes

You may receive the following error if your Maven shade configuration doesn't include the `excludes` mentioned in [this StackOverflow post](https://stackoverflow.com/a/6743609):

```
Error: A JNI error has occurred, please check your installation and try again
Exception in thread "main" java.lang.SecurityException: Invalid signature file digest for Manifest main attributes
	at sun.security.util.SignatureFileVerifier.processImpl(SignatureFileVerifier.java:330)
	at sun.security.util.SignatureFileVerifier.process(SignatureFileVerifier.java:263)
	at java.util.jar.JarVerifier.processEntry(JarVerifier.java:318)
	at java.util.jar.JarVerifier.update(JarVerifier.java:230)
	at java.util.jar.JarFile.initializeVerifier(JarFile.java:383)
	at java.util.jar.JarFile.ensureInitialization(JarFile.java:612)
	at java.util.jar.JavaUtilJarAccessImpl.ensureInitialization(JavaUtilJarAccessImpl.java:69)
	at sun.misc.URLClassPath$JarLoader$2.getManifest(URLClassPath.java:991)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:451)
	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
	at java.security.AccessController.doPrivileged(Native Method)
	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:349)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:495)
```

You may also want to tweak your [bounds for response times] so your graphs are a little more useful than the defaults.

This blog post is supported by the repo [<i class="fa fa-gitlab"></i> fat-gatling-jar](https://gitlab.com/jamietanna/fat-gatling-jar).

[bounds for response times]: {% post_url 2018-11-19-gatling-highcharts-response-time-bounds %}
