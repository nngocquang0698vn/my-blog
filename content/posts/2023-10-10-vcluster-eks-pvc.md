---
title: "Gotcha: Using vCluster on Elastic Kubernetes Service requires a Container Storage Interface driver"
description: "How to avoid `PersistentVolumeClaim`s getting stuck in a `Pending` state with vCluster and EKS when you've not set up the cluster with a Container Storage Interface driver for Elastic Block Store."
date: 2023-10-10T13:38:13+0100
tags:
- blogumentation
- aws
- kubernetes
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/735ffcb6bd.png
slug: vcluster-eks-pvc
---
I've recently been playing around with [vcluster](https://www.vcluster.com/) on an Amazon Elastic Kubernetes Service (EKS) cluster, but about two commands into getting set up on my cluster, I had the vcluster setup fail.

After failing to create the vcluster, I investigated the pods in the vcluster, and saw that etcd was in a `CrashLoopBackOff`.

When I went to investigate the pod, I could see the following error in the events:

```sh
$ kubectl describe -n vcluster-test-vcluster pods/test-vcluster-etcd-0
...
Events:
  Type     Reason            Age                  From               Message
  ----     ------            ----                 ----               -------
  Warning  FailedScheduling  3m36s (x3 over 23m)  default-scheduler  running PreBind plugin "VolumeBinding": binding volumes: timed out waiting for the condition
```

Searching around recommended that I dig into the `PersistentVolumeClaim`s by running:

```
kubectl describe pvc -n vcluster-test-vcluster
Name:          data-test-vcluster-etcd-0
Namespace:     vcluster-test-vcluster
StorageClass:  gp2
Status:        Pending
Volume:
Labels:        app=vcluster-etcd
               release=test-vcluster
Annotations:   volume.beta.kubernetes.io/storage-provisioner: ebs.csi.aws.com
               volume.kubernetes.io/selected-node: ip-xxx-xxx-x-xxx.ec2.internal
               volume.kubernetes.io/storage-provisioner: ebs.csi.aws.com
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:
Access Modes:
VolumeMode:    Filesystem
Used By:       test-vcluster-etcd-0
Events:
  Type    Reason                Age                      From                         Message
  ----    ------                ----                     ----                         -------
  Normal  WaitForFirstConsumer  41s                      persistentvolume-controller  waiting for first consumer to be created before binding
  Normal  ExternalProvisioning  <invalid> (x8 over 41s)  persistentvolume-controller  waiting for a volume to be created, either by external provisioner "ebs.csi.aws.com" or manually created by system administrator
```

This error led me to [this StackOverflow answer](https://stackoverflow.com/a/75758116), which indicated that I needed to make sure that I needed to set up my cluster to be able to provision Amazon Elastic Block Store with the steps mentioned. Once completed, my etcd was able to start correctly, and I could continue with my setup.
