---
title: "Spring Boot: `'junit-vintage' failed to discover tests` When Using Only JUnit5 Tests"
description: "How to avoid the error `'junit-vintage' failed to discover tests` when using Spring Boot."
tags:
- blogumentation
- spring-boot
- java
- junit
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-30T21:24:11+0100
slug: "spring-boot-junit-vintage-failed-discover"
---
I've just done an upgrade from Spring Boot 2.2.2.RELEASE to Spring Boot 2.3.1.RELEASE, and have suddenly started getting these errors:

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:3.0.0-M4:test (default-test) on project postdeploy: There are test failures.
[ERROR]
[ERROR] Please refer to /home/jamie/workspaces/www-api/www-api-web/postdeploy/target/surefire-reports for the individual test results.
[ERROR] Please refer to dump files (if any exist) [date].dump, [date]-jvmRun[N].dump and [date].dumpstream.
[ERROR] There was an error in the forked processTestEngine with ID 'junit-vintage' failed to discover tests
[ERROR] org.apache.maven.surefire.booter.SurefireBooterForkException: There was an error in the forked processTestEngine with ID 'junit-vintage' failed to discover tests
[ERROR]         at org.apache.maven.plugin.surefire.booterclient.ForkStarter.fork(ForkStarter.java:675)
[ERROR]         at org.apache.maven.plugin.surefire.booterclient.ForkStarter.run(ForkStarter.java:285)
[ERROR]         at org.apache.maven.plugin.surefire.booterclient.ForkStarter.run(ForkStarter.java:248)
[ERROR]         at org.apache.maven.plugin.surefire.AbstractSurefireMojo.executeProvider(AbstractSurefireMojo.java:1217)
[ERROR]         at org.apache.maven.plugin.surefire.AbstractSurefireMojo.executeAfterPreconditionsChecked(AbstractSurefireMojo.java:1063)
[ERROR]         at org.apache.maven.plugin.surefire.AbstractSurefireMojo.execute(AbstractSurefireMojo.java:889)
[ERROR]         at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:137)
[ERROR]         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
[ERROR]         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
[ERROR]         at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
[ERROR]         at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
[ERROR]         at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
[ERROR]         at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
[ERROR]         at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
[ERROR]         at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
[ERROR]         at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
[ERROR]         at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
[ERROR]         at org.apache.maven.cli.MavenCli.execute(MavenCli.java:957)
[ERROR]         at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:289)
[ERROR]         at org.apache.maven.cli.MavenCli.main(MavenCli.java:193)
[ERROR]         at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
[ERROR]         at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
[ERROR]         at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
[ERROR]         at java.lang.reflect.Method.invoke(Method.java:498)
[ERROR]         at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
[ERROR]         at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
[ERROR]         at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
[ERROR]         at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)
```

My codebase doesn't use any JUnit4 dependencies, so I purposefully ignored it when pulling in `spring-boot-starter-test`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <version>${spring-boot.version}</version>
    <exclusions>
        <exclusion>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

It turns out, as of 2.3.1.RELEASE, I also need to now _either_ remove my `<exclusions>`:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <version>${spring-boot.version}</version>
</dependency>
```

Or exclude both JUnit 4 and JUnit's "Vintage" engine [which allows running both JUnit4 and JUnit5 code side-by-side]({{< ref 2019-12-23-junit4-junit5-gotcha-together-maven>}}):

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <version>${spring-boot.version}</version>
  <exclusions>
    <exclusion>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
    </exclusion>
    <exclusion>
      <groupId>org.junit.vintage</groupId>
      <artifactId>jupiter-vintage-engine</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

Note that this needs to be done in every place that you're pulling the `spring-boot-starter-test` dependency.

Now it works as expected!
