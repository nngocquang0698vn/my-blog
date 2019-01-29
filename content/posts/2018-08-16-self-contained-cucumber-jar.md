---
title: 'Creating a versionable, self-contained (fat-/uber-) JAR for Cucumber tests'
description: Why you'd want a fat JAR and how you'd achieve it.
categories:
- blogumentation
tags:
- java
- cucumber
- testing
- jar
- artifact
- artefact
- maven
- uber-jar
date: 2018-08-16
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: self-contained-cucumber-jar
---
There are three key reasons for why we would want a self-contained (fat-/uber-jar) JAR for Cucumber tests:

- We have our Cucumber implementation (steps and feature files) but we also want to create tests for our steps
- We want to have a versionable artefact for our Cucumber tests
- We only want a single JAR downloaded, which contains our dependencies, feature files and steps, rather than all of the dependencies separately

Although you may only be interested in one of the above, all three are enabled when we have a fat JAR.

This post is supported by the Git repo [<i class="fa fa-gitlab"></i> fat-cucumber-jar][fat-cucumber-jar] and uses the very arbitrary example of testing that adding items to a `List` works. However, these examples will work with more complicated examples such as working with an API.

# Why?

Let's break down each of these reasons into an explanation of why they're important.

## "Why would I want tests for my Cucumber steps?"

This is likely a separate post altogether but the short of it is that until you can run your Cucumber steps against i.e. your API, you have no idea if it will work. By testing the steps themselves, before they're actually run by Cucumber, we can gain further confidence that the behaviour of the steps once we run it in Cucumber will be correct.

This has the added bonus if you're in a situation where you can write your test changes ahead-of-time to the implementation changes, you can make the changes, release the artefact, and wait for the implementation changes to be tested against the new contract.

**Update**: I've expanded on this point in the article [_Why You Should Be Unit Testing Your Functional (i.e. Cucumber) Tests_]({{< ref 2018-11-07-unit-test-functional-tests >}}).

## "Why would I want a versionable JAR?"

Although checking out the source code of the project (be it using a Git commit hash, Git tag, or just a branch reference) is a great way to ensure you're running a given version of the tests, it doesn't beat having a source-of-truth in the form of an artefact that can be published to i.e. Maven Central.

Not only does this mean that you don't risk conversations like "what branch are you on? What's the SHA hash of the commit you're on?", but you also don't have to worry about local build environments being different, as you can simply say "I used v1.2.2018-08-13.123 and here is the direct link" to that arefact.

## "Why would I want a self-contained artefact?"

By having a self-contained artefact, we only need to pull down one JAR instead of using Maven dependency management to pull all the dependencies at runtime. This simplifies the process as there's now only a single artefact to download.

However, as outlined in [Resurrecting dinosaurs, what could possibly go wrong?][resurrecting-dinosaurs], this will result in downloading many copies of the same version of Cucumber (and all other dependencies) which is duplicated in each artifact, increasing your download sizes and the size of your Maven cache.

# Before

A traditional setup for a Cucumber project in Maven is as follows:

```
pom.xml
src/test/java/me/jvt/hacking/RunCukesIT.java
src/test/java/me/jvt/hacking/Steps.java
src/test/java/me/jvt/hacking/StepsTest.java
src/test/resources/features/List.feature
```

Our feature files are under `src/test/resources`, any Cucumber steps are under `src/test/java` and any tests for those Cucumber steps are _also_ under `src/test/java`, albeit with a `Test` suffix.

[Our POM] uses the `maven-failsafe-plugin` to run Cucumber by automagically detecting the filename `RunCukesIT` with the `IT` suffix:

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>me.jvt.hacking</groupId>
    <artifactId>fat-cucumber.jar</artifactId>
    <version>0.1</version>

    <dependencies>
        <dependency>
            <groupId>io.cucumber</groupId>
            <artifactId>cucumber-junit</artifactId>
            <version>3.0.2</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>io.cucumber</groupId>
            <artifactId>cucumber-java</artifactId>
            <version>3.0.2</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>3.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <version>2.22.0</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>integration-test</goal>
                            <goal>verify</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

This gives us the following `mvn clean verify` run:

```
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building fat-cucumber.jar 0.1
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ fat-cucumber.jar ---
[INFO] Deleting /home/jamie/workspaces/cucumber-jar/new-repo/target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ fat-cucumber.jar ---
[INFO] skip non existing resourceDirectory /home/jamie/workspaces/cucumber-jar/new-repo/src/main/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ fat-cucumber.jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ fat-cucumber.jar ---
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ fat-cucumber.jar ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 3 source files to /home/jamie/workspaces/cucumber-jar/new-repo/target/test-classes
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ fat-cucumber.jar ---
[INFO] Surefire report directory: /home/jamie/workspaces/cucumber-jar/new-repo/target/surefire-reports

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running me.jvt.hacking.StepsTest
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.127 sec

Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0

[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ fat-cucumber.jar ---
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/jamie/workspaces/cucumber-jar/new-repo/target/fat-cucumber.jar-0.1.jar
[INFO]
[INFO] --- maven-failsafe-plugin:2.22.0:integration-test (default) @ fat-cucumber.jar ---
[INFO]
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running me.jvt.hacking.RunCukesIT

2 Scenarios (2 passed)
7 Steps (7 passed)
0m0.066s

[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.331 s - in me.jvt.hacking.RunCukesIT
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO]
[INFO] --- maven-failsafe-plugin:2.22.0:verify (default) @ fat-cucumber.jar ---
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.851 s
[INFO] Finished at: 2018-08-13T13:47:51+01:00
[INFO] Final Memory: 17M/161M
[INFO] ------------------------------------------------------------------------
```

Notice that we have a JUnit run followed by a Cucumber run on success.

Also notice the warning about the JAR not having anything to be included in it, which is expected as at this stage we don't have anything in `src/main` to be included:

```
$ ls -al target/fat-cucumber.jar-0.1.jar
-rw-r--r-- 1 jamie jamie 1716 Aug 13 14:09 target/fat-cucumber.jar-0.1.jar
$ unzip -l target/fat-cucumber.jar-0.1.jar
Archive:  target/fat-cucumber.jar-0.1.jar
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2018-08-13 13:56   META-INF/
      131  2018-08-13 13:56   META-INF/MANIFEST.MF
        0  2018-08-13 13:56   META-INF/maven/
        0  2018-08-13 13:56   META-INF/maven/me.jvt.hacking/
        0  2018-08-13 13:56   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/
     1840  2018-08-13 13:47   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/pom.xml
      113  2018-08-13 13:56   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/pom.properties
---------                     -------
     2084                     7 files
```

# After

## Splitting Implementation and Tests

Firstly, we need to change our directory structure:

```
pom.xml
src/main/java/me/jvt/hacking/RunCukes.java
src/main/java/me/jvt/hacking/Steps.java
src/main/resources/features/List.feature
src/test/java/me/jvt/hacking/StepsTest.java
```

Notice that we now only have `StepsTest` in our `src/test` folder, and that the other files are now in `src/main` as they're implementation-specific.

## Building a JAR

We need to [update our POM] to replace `maven-surefire-plugin` with `maven-shade-plugin`:

```diff
         <plugins>
             <plugin>
                 <groupId>org.apache.maven.plugins</groupId>
-                <artifactId>maven-failsafe-plugin</artifactId>
-                <version>2.22.0</version>
+                <artifactId>maven-shade-plugin</artifactId>
+                <version>3.1.1</version>
                 <executions>
                     <execution>
+                        <phase>package</phase>
                         <goals>
-                            <goal>integration-test</goal>
-                            <goal>verify</goal>
+                            <goal>shade</goal>
                         </goals>
+                        <configuration>
+                            <transformers>
+                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
+                                    <mainClass>me.jvt.hacking.RunCukes</mainClass>
+                                </transformer>
+                            </transformers>
+                        </configuration>
                     </execution>
                 </executions>
             </plugin>
```

Here we specify that our `mainClass` is the `RunCukes` class, which now has a `main` method:

```diff
 @RunWith(Cucumber.class)
 @CucumberOptions(plugin = "json:target/report.json", features = {"classpath:features"})
 public class RunCukes {
+   public static void main(String[] args) {
+     JUnitCore.main(RunCukes.class.getName());
+   }
 }
```

Note here that our `features` need to be pulled from the `classpath`. This is important, otherwise it won't automagically pick up the location of the feature files.

This means that when we run `java -jar` it'll pick up the right class, and run our Cucumber tests with the JUnit runner (which `maven-failsafe-plugin` does under the hood).

## Updating Dependency Scopes

Finally we need to update the `scope` of our dependencies, ensuring we now have everything relevant outside of `test`:

```diff
     <dependencies>
         <dependency>
             <groupId>io.cucumber</groupId>
             <artifactId>cucumber-junit</artifactId>
             <version>3.0.2</version>
-            <scope>test</scope>
         </dependency>
         <dependency>
             <groupId>io.cucumber</groupId>
             <artifactId>cucumber-java</artifactId>
             <version>3.0.2</version>
-            <scope>test</scope>
         </dependency>
         <dependency>
             <groupId>junit</groupId>
             <artifactId>junit</artifactId>
             <version>4.12</version>
-            <scope>test</scope>
+            <scope>compile</scope>
         </dependency>
         <dependency>
             <groupId>org.assertj</groupId>
             <artifactId>assertj-core</artifactId>
             <version>3.10.0</version>
-            <scope>test</scope>
         </dependency>
     </dependencies>
```

## Building the Project

We can now build the project with a `mvn clean verify`:

```
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building fat-cucumber.jar 0.1
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ fat-cucumber.jar ---
[INFO] Deleting /home/jamie/workspaces/cucumber-jar/new-repo/target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ fat-cucumber.jar ---
[INFO] skip non existing resourceDirectory /home/jamie/workspaces/cucumber-jar/new-repo/src/main/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ fat-cucumber.jar ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ fat-cucumber.jar ---
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ fat-cucumber.jar ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 3 source files to /home/jamie/workspaces/cucumber-jar/new-repo/target/test-classes
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ fat-cucumber.jar ---
[INFO] Surefire report directory: /home/jamie/workspaces/cucumber-jar/new-repo/target/surefire-reports

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running me.jvt.hacking.StepsTest
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.127 sec

Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0

[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ fat-cucumber.jar ---
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/jamie/workspaces/cucumber-jar/new-repo/target/fat-cucumber.jar-0.1.jar
[INFO]
[INFO] --- maven-failsafe-plugin:2.22.0:integration-test (default) @ fat-cucumber.jar ---
[INFO]
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running me.jvt.hacking.RunCukesIT

2 Scenarios (2 passed)
7 Steps (7 passed)
0m0.066s

[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.331 s - in me.jvt.hacking.RunCukesIT
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO]
[INFO] --- maven-failsafe-plugin:2.22.0:verify (default) @ fat-cucumber.jar ---
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.851 s
[INFO] Finished at: 2018-08-13T13:47:51+01:00
[INFO] Final Memory: 17M/161M
[INFO] ------------------------------------------------------------------------
```

Our JAR is now a lot more heavyweight (trimmed for brevity):

```
$ ls -alh target/fat-cucumber.jar-0.2.jar
-rw-r--r-- 1 jamie jamie 7.0M Aug 13 14:00 target/fat-cucumber.jar-0.2.jar
$ unzip -l target/fat-cucumber.jar-0.2.jar
Archive:  target/fat-cucumber.jar-0.2.jar
  Length      Date    Time    Name
---------  ---------- -----   ----
      168  2018-08-13 14:00   META-INF/MANIFEST.MF
        0  2018-08-13 14:00   META-INF/
        0  2018-08-13 14:00   features/
      329  2018-08-13 14:00   features/List.feature
        0  2018-08-13 14:00   me/
        0  2018-08-13 14:00   me/jvt/
        0  2018-08-13 14:00   me/jvt/hacking/
      778  2018-08-13 14:00   me/jvt/hacking/RunCukes.class
     1615  2018-08-13 14:00   me/jvt/hacking/Steps.class
        0  2018-08-13 14:00   META-INF/maven/
        0  2018-08-13 14:00   META-INF/maven/me.jvt.hacking/
        0  2018-08-13 14:00   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/
     2160  2018-08-13 14:00   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/pom.xml
      113  2018-08-13 14:00   META-INF/maven/me.jvt.hacking/fat-cucumber.jar/pom.properties
      ...
---------                     -------
 18569423                     5356 files
```

## Running Cucumber

You'll notice there was no Cucumber run at this point. As Surefire is no longer triggered, we'll need to manually run our Cucumber tests using `java -jar`:

```
$ java -jar target/fat-cucumber.jar-0.2.jar
JUnit version 4.12
..
2 Scenarios (2 passed)
7 Steps (7 passed)
0m0.063s


Time: 0.059

OK (2 tests)
```

Now, we only run our Cucumber tests.

## Running Cucumber from the JAR as Part of a `mvn verify`

We can also hook in our Cucumber run from the JAR as part of our Maven build, [hooking into the `integration-test` phase in our parent POM]:

```diff
             </plugin>
+            <plugin>
+                <groupId>org.codehaus.mojo</groupId>
+                <artifactId>exec-maven-plugin</artifactId>
+                <version>1.6.0</version>
+                <executions>
+                    <execution>
+                        <phase>integration-test</phase>
+                        <goals>
+                            <goal>java</goal>
+                        </goals>
+                    </execution>
+                </executions>
+                <configuration>
+                    <mainClass>me.jvt.hacking.RunCukes</mainClass>
+                </configuration>
+            </plugin>
         </plugins>
```

This means that when we run a `mvn clean verify`:

```
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building fat-cucumber.jar 0.3
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ fat-cucumber.jar ---
[INFO] Deleting /home/jamie/workspaces/cucumber-jar/target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ fat-cucumber.jar ---
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ fat-cucumber.jar ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /home/jamie/workspaces/cucumber-jar/target/classes
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ fat-cucumber.jar ---
[INFO] skip non existing resourceDirectory /home/jamie/workspaces/cucumber-jar/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ fat-cucumber.jar ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to /home/jamie/workspaces/cucumber-jar/target/test-classes
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ fat-cucumber.jar ---
[INFO] Surefire report directory: /home/jamie/workspaces/cucumber-jar/target/surefire-reports

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running me.jvt.hacking.StepsTest
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.432 sec

Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0

[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ fat-cucumber.jar ---
[INFO] Building jar: /home/jamie/workspaces/cucumber-jar/target/fat-cucumber.jar-0.3.jar
[INFO]
[INFO] --- maven-shade-plugin:3.1.1:shade (default) @ fat-cucumber.jar ---
[INFO] Including io.cucumber:cucumber-junit:jar:3.0.2 in the shaded jar.
[INFO] Including io.cucumber:cucumber-core:jar:3.0.2 in the shaded jar.
[INFO] Including io.cucumber:cucumber-html:jar:0.2.7 in the shaded jar.
[INFO] Including io.cucumber:gherkin:jar:5.0.0 in the shaded jar.
[INFO] Including io.cucumber:tag-expressions:jar:1.1.1 in the shaded jar.
[INFO] Including io.cucumber:cucumber-expressions:jar:5.0.19 in the shaded jar.
[INFO] Including io.cucumber:datatable:jar:1.0.3 in the shaded jar.
[INFO] Including io.cucumber:datatable-dependencies:jar:1.0.3 in the shaded jar.
[INFO] Including io.cucumber:cucumber-java:jar:3.0.2 in the shaded jar.
[INFO] Including junit:junit:jar:4.12 in the shaded jar.
[INFO] Including org.hamcrest:hamcrest-core:jar:1.3 in the shaded jar.
[INFO] Including org.assertj:assertj-core:jar:3.10.0 in the shaded jar.
[INFO] Replacing original artifact with shaded artifact.
[INFO] Replacing /home/jamie/workspaces/cucumber-jar/target/fat-cucumber.jar-0.3.jar with /home/jamie/workspaces/cucumber-jar/target/fat-cucumber.jar-0.3-shaded.jar
[INFO] Dependency-reduced POM written at: /home/jamie/workspaces/cucumber-jar/dependency-reduced-pom.xml
[INFO]
[INFO] --- exec-maven-plugin:1.6.0:java (default) @ fat-cucumber.jar ---
JUnit version 4.12
..
2 Scenarios (2 passed)
7 Steps (7 passed)
0m0.093s


Time: 0.089

OK (2 tests)
```

Which as we can see, runs Cucumber right at the end of the Maven build.

# Adding HTML outputs

As an avid reader has reminded me, we may also want to have HTML reports from our Cucumber run. This can be done by [amending the `CucumberOptions` annotation]:

```diff
-@CucumberOptions(plugin = "json:target/report.json", features = {"classpath:features"})
+@CucumberOptions(plugin = {"html:target/cucumber-html", "json:target/report.json"}, features = {"classpath:features"})
```

Now, after running our Cucumber tests, we can we have populated `target/cucumber-html`:

```
$ ls target/cucumber-html
formatter.js  index.html  jquery-1.8.2.min.js  report.js  style.css
```

# Prettier Cucumber Command-Line Output

If we wanted a slightly more `pretty` output for our test run, we can update our `CucumberOptions`:

```diff
-@CucumberOptions(plugin = {"html:target/cucumber-html", "json:target/report.json"}, features = {"classpath:features"})
+@CucumberOptions(plugin = {"pretty", "html:target/cucumber-html", "json:target/report.json"}, features = {"classpath:features"})
```

This gives us the following output:

```
Feature: List

  Scenario: When I append to a list, it appends # features/List.feature:3
.    Given I create a new List                   # Steps.createANewList()
    When I append a new item                    # Steps.appendItemToList()
    Then the list has 1 item in it              # Steps.theListHasItemsInIt(int)

  Scenario: When I append to a list, it appends # features/List.feature:8
.    Given I create a new List                   # Steps.createANewList()
    When I append a new item                    # Steps.appendItemToList()
    And I append a new item                     # Steps.appendItemToList()
    Then the list has 2 items in it             # Steps.theListHasItemsInIt(int)

2 Scenarios (2 passed)
7 Steps (7 passed)
0m0.084s


Time: 0.083

OK (2 tests)
```


# Summary

We're now building a JAR for our Cucumber tests, which allows us to build once and run many times. We have confidence in releasing our JARs by writing tests for our steps, meaning we're able to release our tests before we actually run them against our API, as we are happy they'll do what they are meant to.

Note that I've also implemented this process for Gatling, which follows a very similar set of instructions. I've created a follow-up article with the Gatling steps in [_Creating a versionable, self-contained (fat-/uber-) JAR for Gatling tests_][fat-gatling-jar].

[our POM]: https://gitlab.com/jamietanna/fat-cucumber-jar/blob/5367d363f4038dcce2cec5a04856dc3d7c9afc0e/pom.xml
[update our POM]: https://gitlab.com/jamietanna/fat-cucumber-jar/blob/cccd0c167eb444cb1c8d7cf9e09eb23b564b4b4e/pom.xml
[hooking into the `integration-test` phase in our parent POM]: https://gitlab.com/jamietanna/fat-cucumber-jar/blob/d1f3458a0b6e601d0043f65afe1344a9308c7de3/pom.xml
[resurrecting-dinosaurs]: {{< ref 2017-02-15-resurrecting-dinosaurs >}}
[fat-cucumber-jar]: https://gitlab.com/jamietanna/fat-cucumber-jar
[fat-gatling-jar]: {{< ref 2018-11-19-self-contained-gatling-jar >}}
[amending the `CucumberOptions` annotation]: https://gitlab.com/jamietanna/fat-cucumber-jar/commit/8e61448d656bd39b4f2e3daa0d3391bbec2decd1
