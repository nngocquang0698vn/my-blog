---
title: "Updating a Secret in Kubernetes with the Java Client"
description: "How to use the Kubernetes Java SDK to patch a secret through Kubernetes' secrets API."
tags:
- blogumentation
- kubernetes
- java
date: 2021-10-23T19:23:12+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: kubernetes-java-patch-secret
image: https://media.jvt.me/735ffcb6bd.png
---
While migrating a number of Java services to Kubernetes, I needed to replace handling of secrets on the filesystem with moving them into a secret management solution.

Instead of needing to learn how to operate and maintain a secret management tool like Hashicorp Vault securely, I decided to use Kubernetes' built in [secret management](https://kubernetes.io/docs/concepts/configuration/secret/).

I found that it wasn't super straightforward how to use it with the Java SDK, nor to set up a service account for the service to write the secret.

The below has been tested with [Kubernetes Java SDK v13.0.1](https://github.com/kubernetes-client/java/releases/tag/client-java-parent-13.0.1) and Kubernetes server API v1.21.

# Service Account

**Note** This still allows access to the whole namespace, so is **not very secure** - I've not looked into it very much, but if you have improvements please let me know!

To make sure that only this specific application can write to the secrets, we create a new service account:

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: post-deploy-sa
  namespace: www-api
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: post-deploy-role-secret-rw
  namespace: www-api
rules:
- apiGroups:
  - ''
  resources:
  - secrets
  verbs:
  - 'get'
  - 'update'
  - 'patch'
  - 'create'
  - 'list'
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: post-deploy-secret-rw-binding
  namespace: www-api
subjects:
- kind: ServiceAccount
  name: post-deploy-sa
  namespace: www-api
roleRef:
  kind: Role
  name: post-deploy-role-secret-rw
  apiGroup: rbac.authorization.k8s.io
```

And then in the deployment configuration for the application itself, we need to make sure we bind it to the deployment through `serviceAccountName`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: post-deploy
  name: post-deploy
  namespace: www-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: post-deploy
  strategy: {}
  template:
    metadata:
      labels:
        app: post-deploy
    spec:
      serviceAccountName: post-deploy-sa
      containers:
  # ...
```

# SDK Code

The Kubernetes SDK has the handy `patchNamespacedSecret` method, which requires a `V1Patch`, but it's not super clear that the argument to the constructor needs to be a raw [JSON Patch](http://jsonpatch.com/):

```java
// assuming we have an API client prepared
CoreV1Api api = new CoreV1Api();

// encode the secret into Base64
String rawValue = "this is a super secret value";
String encoded = Base64.getEncoder().encodeToString(rawValue.getBytes(StandardCharsets.UTF_8));

V1Patch patch = new V1Patch("{\"op\": \"replace\", \"path\": \"foo\", \"value\": \"" + encoded "\"}");
V1Secret secret =
  api.patchNamespacedSecret(
      "post-deploy-secrets", "www-api", patch, null, null, "ThisClassName.class", null);
// `secret` has the updated data
```

You'll notice that this isn't super readable, nor will it be super fun to maintain as it's escaped JSON.

The solution I ended up with was a helper class that can handle the encoding to Base64, and then serialised more easily:

```java
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class PatchBody {
  private static final String REPLACE_OPERATION = "replace";
  private final String encodedSecret;
  private final String path;

  public PatchBody(String rawValue, String path) {
    this.encodedSecret =
        Base64.getEncoder().encodeToString(rawValue.getBytes(StandardCharsets.UTF_8));
    this.path = path;
  }

  public String getOp() {
    return REPLACE_OPERATION;
  }

  public String getPath() {
    return path;
  }

  public String getValue() {
    return encodedSecret;
  }
}
```

This then allows us to do something like:

```java
// assuming we have an API client prepared
CoreV1Api api = new CoreV1Api();
ObjectMapper mapper = new ObjectMapper();

// encode the secret into Base64
PatchBody patch = new PatchBody("this is a super secret value", "foo");
V1Patch patch = new V1Patch(mapper.writeValueAsString(patch));
V1Secret secret =
  api.patchNamespacedSecret(
      "post-deploy-secrets", "www-api", patch, null, null, "ThisClassName.class", null);
// `secret` has the updated data
```
