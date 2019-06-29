---
title: 'Creating a versionable, self-contained (fat-/uber-) JAR for Gatling tests'
description: Why you'd want a fat JAR for your Gatling tests and how you'd achieve it.
tags:
- blogumentation
- java
- gatling
- testing
- jar
- artifact
- artefact
- maven
- uber-jar
image: /img/vendor/gatling-logo.png
date: 2018-11-19T22:46:45+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: self-contained-gatling-jar
---
# Why

The reasoning behind this post is very similar to [_Creating a versionable, self-contained (fat-/uber-) JAR for Cucumber tests_]({{< ref 2018-08-15-self-contained-cucumber-jar >}}), but doesn't include the comment about the separation of unit tests and cucumber steps.

This means that the two reasons we'd want a fat JAR is:

- We want to have a versionable artefact for our Gatling tests
- We only want a single JAR downloaded, which contains our dependencies as well as simulations and scenarios, rather than all of the dependencies separately

As mentioned in the Cucumber post, we don't necessarily want both of these, but they're both achieved with this approach.

# Before

A traditional setup for a Gatling project in Maven is as follows:

```
pom.xml
src/test/scala/me/jvt/hacking/BasicSimulation.scala
src/test/scala/me/jvt/hacking/OtherSimulation.scala
```

Our POM uses the `gatling-maven-plugin` to run our tests, hooking it into the `verify` phase:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>me.jvt.hacking</groupId>
    <artifactId>fat-gatling-jar</artifactId>
    <version>0.3</version>

    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <gatling.version>3.0.0</gatling.version>
        <gatling-plugin.version>3.0.0</gatling-plugin.version>
        <scala-maven-plugin.version>3.4.4</scala-maven-plugin.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>io.gatling.highcharts</groupId>
            <artifactId>gatling-charts-highcharts</artifactId>
            <version>${gatling.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>net.alchim31.maven</groupId>
                <artifactId>scala-maven-plugin</artifactId>
                <version>${scala-maven-plugin.version}</version>
            </plugin>
            <plugin>
                <groupId>io.gatling</groupId>
                <artifactId>gatling-maven-plugin</artifactId>
                <version>${gatling-plugin.version}</version>
                <executions>
                    <execution>
                        <id>BasicSimulation</id>
                        <goals>
                            <goal>test</goal>
                        </goals>
                        <phase>verify</phase>
                        <configuration>
                            <simulationClass>me.jvt.hacking.BasicSimulation</simulationClass>
                        </configuration>
                    </execution>
                    <execution>
                        <id>OtherSimulation</id>
                        <goals>
                            <goal>test</goal>
                        </goals>
                        <phase>verify</phase>
                        <configuration>
                            <simulationClass>me.jvt.hacking.OtherSimulation</simulationClass>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

When we perform a `mvn clean verify`:

```
[INFO] Scanning for projects...
[INFO]
[INFO] -------------------< me.jvt.hacking:fat-gatling-jar >-------------------
[INFO] Building fat-gatling-jar 0.3
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ fat-gatling-jar ---
[INFO] Deleting /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ fat-gatling-jar ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ fat-gatling-jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ fat-gatling-jar ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ fat-gatling-jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ fat-gatling-jar ---
[INFO] No tests to run.
[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ fat-gatling-jar ---
[INFO] Building jar: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/fat-gatling-jar-0.3.jar
[INFO]
[INFO] --- gatling-maven-plugin:3.0.0:test (BasicSimulation) @ fat-gatling-jar ---
Simulation me.jvt.hacking.BasicSimulation started...

================================================================================
2018-11-18 14:03:45                                           5s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[--------------------------------------------------------------------------]  0%
          waiting: 0      / active: 1      / done: 0
================================================================================


================================================================================
2018-11-18 14:03:47                                           6s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[##########################################################################]100%
          waiting: 0      / active: 0      / done: 1
================================================================================

Simulation me.jvt.hacking.BasicSimulation completed in 5 seconds
Parsing log file(s)...
Parsing log file(s) done
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                          2 (OK=2      KO=0     )
> min response time                                     32 (OK=32     KO=-     )
> max response time                                    117 (OK=117    KO=-     )
> mean response time                                    75 (OK=75     KO=-     )
> std deviation                                         43 (OK=43     KO=-     )
> response time 50th percentile                         75 (OK=75     KO=-     )
> response time 75th percentile                         96 (OK=96     KO=-     )
> response time 95th percentile                        113 (OK=113    KO=-     )
> response time 99th percentile                        116 (OK=116    KO=-     )
> mean requests/sec                                  0.333 (OK=0.333  KO=-     )
---- Response Time Distribution ------------------------------------------------
> t < 25 ms                                              0 (  0%)
> 25 ms < t < 50 ms                                      1 ( 50%)
> t > 50 ms                                              1 ( 50%)
> failed                                                 0 (  0%)
================================================================================

Reports generated in 0s.
Please open the following file: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/gatling/basicsimulation-20181118140340625/index.html
[INFO]
[INFO] --- gatling-maven-plugin:3.0.0:test (OtherSimulation) @ fat-gatling-jar ---
Simulation me.jvt.hacking.OtherSimulation started...

================================================================================
2018-11-18 14:03:57                                           5s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_2                                                (OK=1      KO=0     )
> request_2 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[--------------------------------------------------------------------------]  0%
          waiting: 0      / active: 1      / done: 0
================================================================================


================================================================================
2018-11-18 14:03:58                                           6s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_2                                                (OK=1      KO=0     )
> request_2 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[##########################################################################]100%
          waiting: 0      / active: 0      / done: 1
================================================================================

Simulation me.jvt.hacking.OtherSimulation completed in 5 seconds
Parsing log file(s)...
Parsing log file(s) done
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                          2 (OK=2      KO=0     )
> min response time                                     39 (OK=39     KO=-     )
> max response time                                    105 (OK=105    KO=-     )
> mean response time                                    72 (OK=72     KO=-     )
> std deviation                                         33 (OK=33     KO=-     )
> response time 50th percentile                         72 (OK=72     KO=-     )
> response time 75th percentile                         89 (OK=89     KO=-     )
> response time 95th percentile                        102 (OK=102    KO=-     )
> response time 99th percentile                        104 (OK=104    KO=-     )
> mean requests/sec                                  0.333 (OK=0.333  KO=-     )
---- Response Time Distribution ------------------------------------------------
> t < 25 ms                                              0 (  0%)
> 25 ms < t < 50 ms                                      1 ( 50%)
> t > 50 ms                                              1 ( 50%)
> failed                                                 0 (  0%)
================================================================================

Reports generated in 0s.
Please open the following file: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/gatling/othersimulation-20181118140352474/index.html
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  33.747 s
[INFO] Finished at: 2018-11-18T14:03:59Z
[INFO] ------------------------------------------------------------------------
```

Also notice the warning about the JAR not having anything to be included in it. This is expected, as at this stage we don't have anything in `src/main` to be included:

```
% ls -al target/*.jar
-rw-r--r-- 1 jamie jamie 2019 Nov 18 14:03 target/fat-gatling-jar-0.3.jar
% unzip -l target/*.jar
Archive:  target/fat-gatling-jar-0.3.jar
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2018-11-18 14:03   META-INF/
      131  2018-11-18 14:03   META-INF/MANIFEST.MF
        0  2018-11-18 14:03   META-INF/maven/
        0  2018-11-18 14:03   META-INF/maven/me.jvt.hacking/
        0  2018-11-18 14:03   META-INF/maven/me.jvt.hacking/fat-gatling-jar/
     2563  2018-11-18 14:03   META-INF/maven/me.jvt.hacking/fat-gatling-jar/pom.xml
      112  2018-11-18 14:03   META-INF/maven/me.jvt.hacking/fat-gatling-jar/pom.properties
---------                     -------
     2903                     8 files
```

# After

To enable the creation of a self-contained Gatling artefact, we first need to move our Gatling files from `src/test` to `src/main` to fit within Maven's directory structures:

```
pom.xml
src/main/scala/me/jvt/hacking/BasicSimulation.scala
src/main/scala/me/jvt/hacking/OtherSimulation.scala
```

Then, we need to make sure that the `scala-maven-plugin` is hooked in to to the `compile` phase, so our Scala files are built and available to be pulled into the JAR:

```diff
     <groupId>me.jvt.hacking</groupId>
     <artifactId>fat-gatling-jar</artifactId>
-    <version>0.3</version>
+    <version>0.4</version>
+    <packaging>jar</packaging>

     <properties>
         <maven.compiler.source>1.8</maven.compiler.source>
@@ -22,7 +23,6 @@
             <groupId>io.gatling.highcharts</groupId>
             <artifactId>gatling-charts-highcharts</artifactId>
             <version>${gatling.version}</version>
-            <scope>test</scope>
         </dependency>
     </dependencies>

@@ -32,7 +32,49 @@
                 <groupId>net.alchim31.maven</groupId>
                 <artifactId>scala-maven-plugin</artifactId>
                 <version>${scala-maven-plugin.version}</version>
+                <executions>
+                  <execution>
+                    <goals>
+                      <goal>compile</goal>
+                      <goal>testCompile</goal>
+                    </goals>
+                  </execution>
+                </executions>
             </plugin>
+            <plugin>
+              <groupId>org.apache.maven.plugins</groupId>
+              <artifactId>maven-shade-plugin</artifactId>
+              <version>3.1.1</version>
+              <configuration>
+                <filters>
+                  <!-- https://stackoverflow.com/a/6743609 -->
+                  <filter>
+                    <artifact>*:*</artifact>
+                    <excludes>
+                      <exclude>META-INF/*.DSA</exclude>
+                      <exclude>META-INF/*.SF</exclude>
+                      <exclude>META-INF/*.RSA</exclude>
+                    </excludes>
+                  </filter>
+                </filters>
+              </configuration>
+              <executions>
+                <execution>
+                  <phase>package</phase>
+                  <goals>
+                    <goal>shade</goal>
+                  </goals>
+                  <configuration>
+                    <transformers>
+                      <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
+                        <mainClass>io.gatling.app.Gatling</mainClass>
+                      </transformer>
+                    </transformers>
+                  </configuration>
+                </execution>
+              </executions>
+            </plugin>
+
             <plugin>
                 <groupId>io.gatling</groupId>
                 <artifactId>gatling-maven-plugin</artifactId>
```

Note that we're marking the `packaging` of the project as a `jar` because we've now got an actual artefact that this project creates.

```
% ls -al target/*.jar
-rw-r--r-- 1 jamie jamie 44578503 Nov 18 14:14 target/fat-gatling-jar-0.4.jar
-rw-r--r-- 1 jamie jamie     7559 Nov 18 14:14 target/original-fat-gatling-jar-0.4.jar
% unzip -l target/fat-gatling-jar-0.4.jar
Archive:  target/fat-gatling-jar-0.4.jar
  Length      Date    Time    Name
---------  ---------- -----   ----
      167  2018-11-18 14:14   META-INF/MANIFEST.MF
        0  2018-11-18 14:14   META-INF/
        0  2018-11-18 14:14   me/
        0  2018-11-18 14:14   me/jvt/
        0  2018-11-18 14:14   me/jvt/hacking/
     5272  2018-11-18 14:14   me/jvt/hacking/BasicSimulation.class
     5272  2018-11-18 14:14   me/jvt/hacking/OtherSimulation.class
        0  2018-11-18 14:14   META-INF/maven/
        0  2018-11-18 14:14   META-INF/maven/me.jvt.hacking/
        0  2018-11-18 14:14   META-INF/maven/me.jvt.hacking/fat-gatling-jar/
     4148  2018-11-18 14:12   META-INF/maven/me.jvt.hacking/fat-gatling-jar/pom.xml
      112  2018-11-18 14:14   META-INF/maven/me.jvt.hacking/fat-gatling-jar/pom.properties
        ...
        0  2018-11-18 14:14   META-INF/maven/com.eatthepath/
        0  2018-11-18 14:14   META-INF/maven/com.eatthepath/fast-uuid/
     5857  2018-01-26 21:04   META-INF/maven/com.eatthepath/fast-uuid/pom.xml
       87  2018-01-26 21:04   META-INF/maven/com.eatthepath/fast-uuid/pom.properties
---------                     -------
102144180                     24150 files
```

Now, when we perform a `mvn clean verify`:

```
[INFO] Scanning for projects...
[INFO]
[INFO] -------------------< me.jvt.hacking:fat-gatling-jar >-------------------
[INFO] Building fat-gatling-jar 0.4
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ fat-gatling-jar ---
[INFO] Deleting /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ fat-gatling-jar ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ fat-gatling-jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- scala-maven-plugin:3.4.4:compile (default) @ fat-gatling-jar ---
[INFO] /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/src/main/scala:-1: info: compiling
[INFO] Compiling 2 source files to /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/classes at 1542550447891
[INFO] prepare-compile in 0 s
[INFO] compile in 5 s
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ fat-gatling-jar ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ fat-gatling-jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- scala-maven-plugin:3.4.4:testCompile (default) @ fat-gatling-jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ fat-gatling-jar ---
[INFO] No tests to run.
[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ fat-gatling-jar ---
[INFO] Building jar: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/fat-gatling-jar-0.4.jar
[INFO]
[INFO] --- maven-shade-plugin:3.1.1:shade (default) @ fat-gatling-jar ---
[INFO] Including io.gatling.highcharts:gatling-charts-highcharts:jar:3.0.0 in the shaded jar.
[INFO] Including org.scala-lang:scala-library:jar:2.12.7 in the shaded jar.
[INFO] Including io.gatling:gatling-charts:jar:3.0.0 in the shaded jar.
[INFO] Including io.gatling:gatling-core:jar:3.0.0 in the shaded jar.
[INFO] Including com.typesafe.akka:akka-slf4j_2.12:jar:2.5.17 in the shaded jar.
[INFO] Including org.simpleflatmapper:lightning-csv:jar:6.0.1 in the shaded jar.
[INFO] Including org.simpleflatmapper:sfm-util:jar:6.0.1 in the shaded jar.
[INFO] Including com.github.ben-manes.caffeine:caffeine:jar:2.6.2 in the shaded jar.
[INFO] Including io.pebbletemplates:pebble:jar:3.0.5 in the shaded jar.
[INFO] Including org.unbescape:unbescape:jar:1.1.6.RELEASE in the shaded jar.
[INFO] Including org.scala-lang.modules:scala-parser-combinators_2.12:jar:1.1.1 in the shaded jar.
[INFO] Including com.github.scopt:scopt_2.12:jar:3.7.0 in the shaded jar.
[INFO] Including io.gatling:jsonpath_2.12:jar:0.6.14 in the shaded jar.
[INFO] Including org.jodd:jodd-json:jar:5.0.5 in the shaded jar.
[INFO] Including org.jodd:jodd-bean:jar:5.0.5 in the shaded jar.
[INFO] Including org.jodd:jodd-core:jar:5.0.5 in the shaded jar.
[INFO] Including net.sf.saxon:Saxon-HE:jar:9.9.0-1 in the shaded jar.
[INFO] Including org.jodd:jodd-lagarto:jar:5.0.5 in the shaded jar.
[INFO] Including org.jodd:jodd-log:jar:5.0.5 in the shaded jar.
[INFO] Including com.tdunning:t-digest:jar:3.1 in the shaded jar.
[INFO] Including io.gatling:gatling-app:jar:3.0.0 in the shaded jar.
[INFO] Including io.gatling:gatling-http:jar:3.0.0 in the shaded jar.
[INFO] Including org.scala-lang.modules:scala-xml_2.12:jar:1.1.0 in the shaded jar.
[INFO] Including io.gatling:gatling-jms:jar:3.0.0 in the shaded jar.
[INFO] Including org.apache.geronimo.specs:geronimo-jms_1.1_spec:jar:1.1.1 in the shaded jar.
[INFO] Including io.gatling:gatling-jdbc:jar:3.0.0 in the shaded jar.
[INFO] Including io.gatling:gatling-redis:jar:3.0.0 in the shaded jar.
[INFO] Including net.debasishg:redisclient_2.12:jar:3.7 in the shaded jar.
[INFO] Including commons-pool:commons-pool:jar:1.6 in the shaded jar.
[INFO] Including io.gatling:gatling-graphite:jar:3.0.0 in the shaded jar.
[INFO] Including org.hdrhistogram:HdrHistogram:jar:2.1.10 in the shaded jar.
[INFO] Including io.gatling:gatling-recorder:jar:3.0.0 in the shaded jar.
[INFO] Including org.scala-lang.modules:scala-swing_2.12:jar:2.0.1 in the shaded jar.
[INFO] Including com.fasterxml.jackson.core:jackson-databind:jar:2.9.7 in the shaded jar.
[INFO] Including com.fasterxml.jackson.core:jackson-annotations:jar:2.9.0 in the shaded jar.
[INFO] Including com.fasterxml.jackson.core:jackson-core:jar:2.9.7 in the shaded jar.
[INFO] Including org.json4s:json4s-jackson_2.12:jar:3.6.1 in the shaded jar.
[INFO] Including org.json4s:json4s-core_2.12:jar:3.6.1 in the shaded jar.
[INFO] Including org.json4s:json4s-ast_2.12:jar:3.6.1 in the shaded jar.
[INFO] Including org.json4s:json4s-scalap_2.12:jar:3.6.1 in the shaded jar.
[INFO] Including com.thoughtworks.paranamer:paranamer:jar:2.8 in the shaded jar.
[INFO] Including org.bouncycastle:bcpkix-jdk15on:jar:1.60 in the shaded jar.
[INFO] Including org.bouncycastle:bcprov-jdk15on:jar:1.60 in the shaded jar.
[INFO] Including io.netty:netty-codec-http:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-codec:jar:4.1.30.Final in the shaded jar.
[INFO] Including com.typesafe.akka:akka-actor_2.12:jar:2.5.17 in the shaded jar.
[INFO] Including io.gatling:gatling-http-client:jar:3.0.0 in the shaded jar.
[INFO] Including io.gatling:gatling-netty-util:jar:3.0.0 in the shaded jar.
[INFO] Including io.netty:netty-buffer:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-common:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-handler:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-transport:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-handler-proxy:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-codec-socks:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-resolver-dns:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-resolver:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-codec-dns:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-transport-native-unix-common:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-codec-http2:jar:4.1.30.Final in the shaded jar.
[INFO] Including io.netty:netty-tcnative-boringssl-static:jar:2.0.15.Final in the shaded jar.
[INFO] Including com.sun.activation:javax.activation:jar:1.2.0 in the shaded jar.
[INFO] Including org.slf4j:slf4j-api:jar:1.7.25 in the shaded jar.
[INFO] Including com.typesafe.scala-logging:scala-logging_2.12:jar:3.9.0 in the shaded jar.
[INFO] Including ch.qos.logback:logback-classic:jar:1.2.3 in the shaded jar.
[INFO] Including ch.qos.logback:logback-core:jar:1.2.3 in the shaded jar.
[INFO] Including io.gatling:gatling-commons:jar:3.0.0 in the shaded jar.
[INFO] Including org.scala-lang:scala-reflect:jar:2.12.7 in the shaded jar.
[INFO] Including com.typesafe:config:jar:1.3.3 in the shaded jar.
[INFO] Including com.dongxiguo:fastring_2.12:jar:1.0.0 in the shaded jar.
[INFO] Including io.suzaku:boopickle_2.12:jar:1.3.0 in the shaded jar.
[INFO] Including org.typelevel:spire-macros_2.12:jar:0.16.0 in the shaded jar.
[INFO] Including com.softwaremill.quicklens:quicklens_2.12:jar:1.4.11 in the shaded jar.
[INFO] Including org.scala-lang.modules:scala-java8-compat_2.12:jar:0.9.0 in the shaded jar.
[INFO] Including com.eatthepath:fast-uuid:jar:0.1 in the shaded jar.
[INFO] Replacing original artifact with shaded artifact.
[INFO] Replacing /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/fat-gatling-jar-0.4.jar with /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/fat-gatling-jar-0.4-shaded.jar
[INFO] Dependency-reduced POM written at: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/dependency-reduced-pom.xml
[INFO]
[INFO] --- gatling-maven-plugin:3.0.0:test (BasicSimulation) @ fat-gatling-jar ---
Simulation me.jvt.hacking.BasicSimulation started...

================================================================================
2018-11-18 14:14:29                                           5s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[--------------------------------------------------------------------------]  0%
          waiting: 0      / active: 1      / done: 0
================================================================================


================================================================================
2018-11-18 14:14:31                                           6s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[##########################################################################]100%
          waiting: 0      / active: 0      / done: 1
================================================================================

Simulation me.jvt.hacking.BasicSimulation completed in 5 seconds
Parsing log file(s)...
Parsing log file(s) done
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                          2 (OK=2      KO=0     )
> min response time                                     31 (OK=31     KO=-     )
> max response time                                     99 (OK=99     KO=-     )
> mean response time                                    65 (OK=65     KO=-     )
> std deviation                                         34 (OK=34     KO=-     )
> response time 50th percentile                         65 (OK=65     KO=-     )
> response time 75th percentile                         82 (OK=82     KO=-     )
> response time 95th percentile                         96 (OK=96     KO=-     )
> response time 99th percentile                         98 (OK=98     KO=-     )
> mean requests/sec                                  0.333 (OK=0.333  KO=-     )
---- Response Time Distribution ------------------------------------------------
> t < 25 ms                                              0 (  0%)
> 25 ms < t < 50 ms                                      1 ( 50%)
> t > 50 ms                                              1 ( 50%)
> failed                                                 0 (  0%)
================================================================================

Reports generated in 0s.
Please open the following file: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/gatling/basicsimulation-20181118141424648/index.html
[INFO]
[INFO] --- gatling-maven-plugin:3.0.0:test (OtherSimulation) @ fat-gatling-jar ---
Simulation me.jvt.hacking.OtherSimulation started...

================================================================================
2018-11-18 14:14:42                                           5s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_2                                                (OK=1      KO=0     )
> request_2 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[--------------------------------------------------------------------------]  0%
          waiting: 0      / active: 1      / done: 0
================================================================================


================================================================================
2018-11-18 14:14:43                                           6s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_2                                                (OK=1      KO=0     )
> request_2 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[##########################################################################]100%
          waiting: 0      / active: 0      / done: 1
================================================================================

Simulation me.jvt.hacking.OtherSimulation completed in 5 seconds
Parsing log file(s)...
Parsing log file(s) done
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                          2 (OK=2      KO=0     )
> min response time                                     40 (OK=40     KO=-     )
> max response time                                     89 (OK=89     KO=-     )
> mean response time                                    65 (OK=65     KO=-     )
> std deviation                                         25 (OK=25     KO=-     )
> response time 50th percentile                         65 (OK=65     KO=-     )
> response time 75th percentile                         77 (OK=77     KO=-     )
> response time 95th percentile                         87 (OK=87     KO=-     )
> response time 99th percentile                         89 (OK=89     KO=-     )
> mean requests/sec                                  0.333 (OK=0.333  KO=-     )
---- Response Time Distribution ------------------------------------------------
> t < 25 ms                                              0 (  0%)
> 25 ms < t < 50 ms                                      1 ( 50%)
> t > 50 ms                                              1 ( 50%)
> failed                                                 0 (  0%)
================================================================================

Reports generated in 0s.
Please open the following file: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/target/gatling/othersimulation-20181118141437364/index.html
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  40.180 s
[INFO] Finished at: 2018-11-18T14:14:44Z
[INFO] ------------------------------------------------------------------------
```

It builds as before, but as we can see, there's a bit more in there which relates to building the JAR.

We set the Gatling class as our `main` to allow us to run the JAR on its own, allowing us to specify the simulation on the command-line:

```
% java -jar target/fat-gatling-jar-0.4.jar -s me.jvt.hacking.BasicSimulation
14:20:32.782 [main] INFO io.gatling.core.config.GatlingConfiguration$ - Gatling will try to use 'gatling.conf' as custom config file.
...
14:20:34.374 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Write request WritableRequest{request=DefaultFullHttpRequest(decodeResult: success, version: HTTP/1.1, content: UnpooledByteBufAllocator$InstrumentedUnpooledUnsafeHeapByteBuf(ridx: 0, widx: 0, cap: 0))
GET / HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Connection: close
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0
accept-encoding: gzip
origin: https://gatling.io
host: gatling.io, content=null}
14:20:34.380 [gatling-http-1-1] DEBUG io.netty.handler.ssl.SslHandler - [id: 0x6aeb6892, L:/192.168.0.19:52922 - R:gatling.io/52.47.152.183:443] HANDSHAKEN: TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
14:20:34.456 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpResponse(decodeResult: success, version: HTTP/1.1)
HTTP/1.1 200 OK
Server: nginx/1.12.1
Date: Sun, 18 Nov 2018 14:20:34 GMT
Content-Type: text/html; charset=UTF-8
Transfer-Encoding: chunked
Connection: close
X-Powered-By: PHP/7.0.31
Link: <https://gatling.io/wp-json/>; rel="https://api.w.org/"
Link: <https://gatling.io/?p=3640>; rel=shortlink
X-Cache: HIT'
14:20:34.458 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 8192, cap: 8192/8192, unwrapped: PooledUnsafeDirectByteBuf(ridx: 8517, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.459 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 7867, cap: 7867/7867, unwrapped: PooledUnsafeDirectByteBuf(ridx: 16384, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.461 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 8192, cap: 8192/8192, unwrapped: PooledUnsafeDirectByteBuf(ridx: 8192, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.461 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 8192, cap: 8192/8192, unwrapped: PooledUnsafeDirectByteBuf(ridx: 16384, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.484 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 325, cap: 325/325, unwrapped: PooledUnsafeDirectByteBuf(ridx: 327, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.485 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 8192, cap: 8192/8192, unwrapped: PooledUnsafeDirectByteBuf(ridx: 8525, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.485 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 7859, cap: 7859/7859, unwrapped: PooledUnsafeDirectByteBuf(ridx: 16384, widx: 16384, cap: 16413)), decoderResult: success)'
14:20:34.488 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 1741, cap: 1741/1741, unwrapped: PooledUnsafeDirectByteBuf(ridx: 1743, widx: 1748, cap: 1777)), decoderResult: success)'
14:20:34.488 [gatling-http-1-1] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='EmptyLastHttpContent'
14:20:34.491 [main] DEBUG io.gatling.http.engine.HttpEngine - Warm up request https://gatling.io successful
14:20:34.493 [main] INFO io.gatling.http.engine.HttpEngine - Warm up done
14:20:34.537 [main] DEBUG io.gatling.http.cache.HttpCaches - HTTP/2 disabled
Simulation me.jvt.hacking.BasicSimulation started...
14:20:34.609 [GatlingSystem-akka.actor.default-dispatcher-4] DEBUG io.gatling.http.engine.tx.HttpTxExecutor - Sending request=request_1 uri=http://computer-database.gatling.io/: scenario=BasicSimulation, userId=1
14:20:34.614 [GatlingSystem-akka.actor.default-dispatcher-4] DEBUG io.gatling.core.controller.inject.open.OpenWorkload - Start user #1
14:20:34.615 [GatlingSystem-akka.actor.default-dispatcher-4] DEBUG io.gatling.core.controller.inject.open.OpenWorkload - Injecting 1 users in scenario BasicSimulation, continue=false
14:20:34.616 [GatlingSystem-akka.actor.default-dispatcher-4] INFO io.gatling.core.controller.inject.Injector - StoppedInjecting
14:20:34.693 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Write request WritableRequest{request=DefaultFullHttpRequest(decodeResult: success, version: HTTP/1.1, content: UnpooledByteBufAllocator$InstrumentedUnpooledUnsafeHeapByteBuf(ridx: 0, widx: 0, cap: 0))
GET / HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
DNT: 1
Accept-Language: en-US,en;q=0.5
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0
accept-encoding: gzip, deflate
origin: http://computer-database.gatling.io
host: computer-database.gatling.io, content=null}
14:20:34.733 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpResponse(decodeResult: success, version: HTTP/1.1)
HTTP/1.1 303 See Other
Server: nginx/1.12.1
Date: Sun, 18 Nov 2018 14:20:34 GMT
Content-Length: 0
Connection: keep-alive
Keep-Alive: timeout=5
Location: /computers'
14:20:34.734 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='EmptyLastHttpContent'
14:20:34.749 [gatling-http-1-2] DEBUG io.gatling.http.engine.tx.HttpTxExecutor - Sending request=request_1 uri=http://computer-database.gatling.io/computers: scenario=BasicSimulation, userId=1
14:20:34.749 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Write request WritableRequest{request=DefaultFullHttpRequest(decodeResult: success, version: HTTP/1.1, content: UnpooledByteBufAllocator$InstrumentedUnpooledUnsafeHeapByteBuf(ridx: 0, widx: 0, cap: 0))
GET /computers HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
DNT: 1
Accept-Language: en-US,en;q=0.5
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0
Referer: http://computer-database.gatling.io/
accept-encoding: gzip, deflate
origin: http://computer-database.gatling.io
host: computer-database.gatling.io, content=null}
14:20:34.785 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpResponse(decodeResult: success, version: HTTP/1.1)
HTTP/1.1 200 OK
Server: nginx/1.12.1
Date: Sun, 18 Nov 2018 14:20:34 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 7197
Connection: keep-alive
Keep-Alive: timeout=5'
14:20:34.785 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 837, cap: 837/837, unwrapped: PooledUnsafeDirectByteBuf(ridx: 1024, widx: 1024, cap: 1024)), decoderResult: success)'
14:20:34.786 [gatling-http-1-2] DEBUG io.gatling.http.client.impl.HttpAppHandler - Read msg='DefaultLastHttpContent(data: PooledSlicedByteBuf(ridx: 0, widx: 6360, cap: 6360/6360, unwrapped: PooledUnsafeDirectByteBuf(ridx: 6360, widx: 6360, cap: 16384)), decoderResult: success)'
14:20:34.807 [gatling-http-1-2] DEBUG io.gatling.core.action.Pause - Pausing for 5000ms (real=4980ms)

================================================================================
2018-11-18 14:20:38                                           5s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[--------------------------------------------------------------------------]  0%
          waiting: 0      / active: 1      / done: 0
================================================================================

14:20:39.806 [GatlingSystem-akka.actor.default-dispatcher-5] DEBUG io.gatling.core.action.Exit - End user #1
14:20:39.812 [GatlingSystem-akka.actor.default-dispatcher-5] INFO io.gatling.core.controller.inject.Injector - All users of scenario BasicSimulation are stopped
14:20:39.812 [GatlingSystem-akka.actor.default-dispatcher-5] INFO io.gatling.core.controller.inject.Injector - Stopping
14:20:39.813 [GatlingSystem-akka.actor.default-dispatcher-4] INFO io.gatling.core.controller.Controller - Injector has stopped, initiating graceful stop

================================================================================
2018-11-18 14:20:39                                           6s elapsed
---- Requests ------------------------------------------------------------------
> Global                                                   (OK=2      KO=0     )
> request_1                                                (OK=1      KO=0     )
> request_1 Redirect 1                                     (OK=1      KO=0     )

---- BasicSimulation -----------------------------------------------------------
[##########################################################################]100%
          waiting: 0      / active: 0      / done: 1
================================================================================

14:20:39.900 [GatlingSystem-akka.actor.default-dispatcher-3] INFO io.gatling.core.controller.Controller - StatsEngineStopped
Simulation me.jvt.hacking.BasicSimulation completed in 5 seconds
Parsing log file(s)...
14:20:39.950 [main] INFO io.gatling.charts.stats.LogFileReader - Collected ArrayBuffer(/home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/results/basicsimulation-20181118142033626/simulation.log) from basicsimulation-20181118142033626
14:20:39.957 [main] INFO io.gatling.charts.stats.LogFileReader - First pass
14:20:39.963 [main] INFO io.gatling.charts.stats.LogFileReader - First pass done: read 5 lines
14:20:39.971 [main] INFO io.gatling.charts.stats.LogFileReader - Second pass
14:20:39.999 [main] INFO io.gatling.charts.stats.LogFileReader - Second pass: read 5 lines
Parsing log file(s) done
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                          2 (OK=2      KO=0     )
> min response time                                     37 (OK=37     KO=-     )
> max response time                                    122 (OK=122    KO=-     )
> mean response time                                    80 (OK=80     KO=-     )
> std deviation                                         43 (OK=43     KO=-     )
> response time 50th percentile                         80 (OK=80     KO=-     )
> response time 75th percentile                        101 (OK=101    KO=-     )
> response time 95th percentile                        118 (OK=118    KO=-     )
> response time 99th percentile                        121 (OK=121    KO=-     )
> mean requests/sec                                  0.333 (OK=0.333  KO=-     )
---- Response Time Distribution ------------------------------------------------
> t < 25 ms                                              0 (  0%)
> 25 ms < t < 50 ms                                      1 ( 50%)
> t > 50 ms                                              1 ( 50%)
> failed                                                 0 (  0%)
================================================================================

Reports generated in 0s.
Please open the following file: /home/jamie/workspaces/jvt.me/tmp/fat-gatling-jar/results/basicsimulation-20181118142033626/index.html
```

We ideally should remove our `gatling-maven-plugin` and instead run our JARs separately:


```diff
     <groupId>me.jvt.hacking</groupId>
     <artifactId>fat-gatling-jar</artifactId>
-    <version>0.4</version>
+    <version>0.5</version>
     <packaging>jar</packaging>

     <properties>
@@ -14,7 +14,7 @@
         <maven.compiler.target>1.8</maven.compiler.target>
         <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
         <gatling.version>3.0.0</gatling.version>
-        <gatling-plugin.version>3.0.0</gatling-plugin.version>
+        <maven-exec.version>1.2.1</maven-exec.version>
         <scala-maven-plugin.version>3.4.4</scala-maven-plugin.version>
     </properties>

@@ -76,28 +76,36 @@
             </plugin>

             <plugin>
-                <groupId>io.gatling</groupId>
-                <artifactId>gatling-maven-plugin</artifactId>
-                <version>${gatling-plugin.version}</version>
+                <groupId>org.codehaus.mojo</groupId>
+                <artifactId>exec-maven-plugin</artifactId>
+                <version>${maven-exec.version}</version>
                 <executions>
                     <execution>
                         <id>BasicSimulation</id>
                         <goals>
-                            <goal>test</goal>
+                            <goal>java</goal>
                         </goals>
-                        <phase>verify</phase>
+                        <phase>integration-test</phase>
                         <configuration>
-                            <simulationClass>me.jvt.hacking.BasicSimulation</simulationClass>
+                            <mainClass>io.gatling.app.Gatling</mainClass>
+                            <arguments>
+                                <argument>-s</argument>
+                                <argument>me.jvt.hacking.BasicSimulation</argument>
+                            </arguments>
                         </configuration>
                     </execution>
                     <execution>
                         <id>OtherSimulation</id>
                         <goals>
-                            <goal>test</goal>
+                            <goal>java</goal>
                         </goals>
-                        <phase>verify</phase>
+                        <phase>integration-test</phase>
                         <configuration>
-                            <simulationClass>me.jvt.hacking.OtherSimulation</simulationClass>
+                            <mainClass>io.gatling.app.Gatling</mainClass>
+                            <arguments>
+                                <argument>-s</argument>
+                                <argument>me.jvt.hacking.OtherSimulation</argument>
+                            </arguments>
                         </configuration>
                     </execution>
                 </executions>
```

# Notes

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

[bounds for response times]: {{< ref 2018-11-19-gatling-highcharts-response-time-bounds >}}
