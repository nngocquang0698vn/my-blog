---
title: "Comparing Pretty-Printed JSON files on the Command-Line"
title: "Diffing Pretty-Printed JSON Files"
description: "How to compare two JSON documents by pretty-printing them."
tags:
- blogumentation
- json
- pretty-print
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-24T20:56:20+0100
slug: "pretty-print-json-diff"
series: pretty-print-json
---
As a lot of tools are now using JSON as their configuration format, we will inevitably need to compare differences between files.

But it can be quite difficult to see what's going on, especially without using an online tool (which may be quite risky depending on the JSON you're comparing).

Let's use two examples for how we can diff two different files.

For these examples, I would strongly recommend using a diff tool that allows for side-by-side view, such as `diff -y` or `vimdiff`.

# Simple example

Firstly, let's use a more straightforward example.

<details>
  <summary>1.json</summary>

```json
{
    "key": [
        123,
        456
    ],
    "key2": "value"
}
```

</details>

<details>
  <summary>2.json</summary>

```json
{
    "key": [
        456
    ],
    "key2": "value"
}
```

</details>

We can utilise one of the solutions documented in my [pretty-print-json series](/series/pretty-print-json/) to pretty-print the JSON before diffing it, to try and make it more readable:

```bash
$ diff -u <(python -mjson.tool 1.json) <(python -mjson.tool 2.json)
```

This gives us the following output, which is a little clearer:

```diff
--- /proc/self/fd/11	2020-08-24 19:22:51.513741484 +0100
+++ /proc/self/fd/13	2020-08-24 19:22:51.513741484 +0100
@@ -1,7 +1,6 @@
 {
   "key": [
-    456,
-    123
+    456
   ],
   "key2": "value"
 }
```

# More complex example

However, the above is a bad example, as it's not super realistic, as we generally have a large, nested document, as well as the keys being in different orders:

<details>
  <summary>1.json</summary>

```json
{
  "Resources": {
    "Ec2Instance": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "SecurityGroups": [
          {
            "Ref": "InstanceSecurityGroup"
          },
          "MyExistingSecurityGroup"
        ],
        "KeyName": {
          "Ref": "KeyName"
        },
        "ImageId": "ami-7a11e213"
      }
    },
    "InstanceSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Enable direct HTTP access",
        "SecurityGroupIngress": [
          {
            "IpProtocol": "https",
            "FromPort": "443",
            "ToPort": "443",
            "CidrIp": "0.0.0.0/0"
          }
        ]
      }
    }
  }
}
```

</details>

<details>
  <summary>2.json</summary>

```json
{
  "Parameters": {
    "KeyName": {
      "Description": "The EC2 Key Pair to allow SSH access to the instance",
      "Type": "AWS::EC2::KeyPair::KeyName"
    }
  },
  "Resources": {
    "Ec2Instance": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "SecurityGroups": [
          {
            "Ref": "InstanceSecurityGroup"
          },
          "MyExistingSecurityGroup"
        ],
        "KeyName": {
          "Ref": "KeyName"
        },
        "ImageId": "ami-7a11e213"
      }
    },
    "InstanceSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Enable SSH access via port 22",
        "SecurityGroupIngress": [
          {
            "ToPort": "22",
            "FromPort": "22",
            "CidrIp": "0.0.0.0/0",
            "IpProtocol": "tcp",
            "Description": "Only found on 2.json"
          }
        ]
      }
    }
  }
}
```

</details>

If we were to use the above diff example, we'd end up with quite a few lines showing as diffs, even though they've actually got a lot in common:

```diff
--- /proc/self/fd/11	2020-08-24 20:34:48.645452666 +0100
+++ /proc/self/fd/13	2020-08-24 20:34:48.648785937 +0100
@@ -1,4 +1,10 @@
 {
+    "Parameters": {
+        "KeyName": {
+            "Description": "The EC2 Key Pair to allow SSH access to the instance",
+            "Type": "AWS::EC2::KeyPair::KeyName"
+        }
+    },
     "Resources": {
         "Ec2Instance": {
             "Type": "AWS::EC2::Instance",
@@ -18,13 +24,14 @@
         "InstanceSecurityGroup": {
             "Type": "AWS::EC2::SecurityGroup",
             "Properties": {
-                "GroupDescription": "Enable direct HTTP access",
+                "GroupDescription": "Enable SSH access via port 22",
                 "SecurityGroupIngress": [
                     {
-                        "IpProtocol": "https",
-                        "FromPort": "443",
-                        "ToPort": "443",
-                        "CidrIp": "0.0.0.0/0"
+                        "ToPort": "22",
+                        "FromPort": "22",
+                        "CidrIp": "0.0.0.0/0",
+                        "IpProtocol": "tcp",
+                        "Description": "Only found on 2.json"
                     }
                 ]
             }
```

So instead, I'd recommend reaching for something that can sort the JSON documents to make it a bit easier semantically, such as [this JSON script I've written](/posts/2020/08/24/sort-recursive-hash-ruby/) (as an aside, this is based on the fact that JSON keys should not be order-dependent - if yours are, you'll not have a great time).

This means that we can run the following:

```bash
$ diff -u <(ruby sort-keys.rb 1.json) <(ruby sort-keys.rb 2.json)
```

This gives us the following, slightly easier to understand, output:

```diff
--- /proc/self/fd/11	2020-08-24 20:10:11.630671779 +0100
+++ /proc/self/fd/13	2020-08-24 20:10:11.630671779 +0100
@@ -1,4 +1,10 @@
 {
+  "Parameters": {
+    "KeyName": {
+      "Description": "The EC2 Key Pair to allow SSH access to the instance",
+      "Type": "AWS::EC2::KeyPair::KeyName"
+    }
+  },
   "Resources": {
     "Ec2Instance": {
       "Properties": {
@@ -17,13 +23,14 @@
     },
     "InstanceSecurityGroup": {
       "Properties": {
-        "GroupDescription": "Enable direct HTTP access",
+        "GroupDescription": "Enable SSH access via port 22",
         "SecurityGroupIngress": [
           {
             "CidrIp": "0.0.0.0/0",
-            "FromPort": "443",
-            "IpProtocol": "https",
-            "ToPort": "443"
+            "Description": "Only found on 2.json",
+            "FromPort": "22",
+            "IpProtocol": "tcp",
+            "ToPort": "22"
           }
         ]
       },
```
