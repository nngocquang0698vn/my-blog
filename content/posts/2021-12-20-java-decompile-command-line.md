---
title: "Decompiling Java Class Files On the Command-Line"
description: "How to use the Fernflower decompiler on the command-line to decompile compiled Java classes."
tags:
- blogumentation
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-20T20:49:57+0000
slug: java-decompile-command-line
---
Sometimes you come across compiled Java/JVM class files that you need to decompile. It's incredibly convenient when this occurs when this happens while in the midst of development, in your IDE, but sometimes it's when you're SSH'd into a machine, and it's a little more awkward, or if you don't have an IDE installed.

Fortunately, the Fernflower decompiler that IntelliJ uses under the hood is [Open Source]((https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine)) and has a powerful command-line interface that can be used to decompile classes.

# Getting Fernflower

Before we can run this, you need to have access to the Fernflower JAR file.

## IntelliJ

If you have IntelliJ installed, you can find it present in the `plugins/java-decompiler/lib/java-decompiler.jar` path within your IntelliJ installation.

The version distributed unfortunately doesn't have a `Main-Class` attribute in the JAR, so we need to provide it when executing it:

```sh
cd /path/to/intellij
java -cp plugins/java-decompiler/lib/java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler <args>
```

## Building from source

As the JAR isn't (officially) published to any Maven repositories, if you don't have IntelliJ installed, it's worthwhile building it yourself from source.

You can either build it from the [official IntelliJ repo](https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine) or may find it more convenient to use [the unofficial mirror of just the decompiler](https://github.com/fesh0r/fernflower).

This version includes the `Main-Class` attribute so you can execute it via:

```sh
cd /path/to/source-repo
# build the project
java -jar build/libs/fernflower.jar <args>
```

# Running

Now we have our JAR, and the prefix required to execute it, we can then decompile the class file(s) to a directory, for instance:

```sh
java -jar build/libs/fernflower.jar build/classes/java/main/org/jetbrains/java/decompiler/code/FullInstructionSequence.class .
```

And now we can open up `FullInstructionSequence.java` in our editor to see the decompiled code!

There are a lot of options to tune the decompilation process, so it's worth having a look at the project README to see which are best for usage.
