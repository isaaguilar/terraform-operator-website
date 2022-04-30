---
title: How to use Private Repos with Terraform Operator
draft: false
excerpt: >-
  Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator.
date: '2022-04-29'
author: Isa Aguilar
# thumb_image: images/4.jpg
image: images/hcl.png
seo:
  title: Introducing The Libris Theme
  description: >-
    Vis accumsan feugiat adipiscing nisl amet adipiscing accumsan blandit
    accumsan
  extra:
    - name: 'og:type'
      value: article
      keyName: property
    - name: 'og:title'
      value: Introducing The Libris Theme
      keyName: property
    - name: 'og:description'
      value: >-
        Vis accumsan feugiat adipiscing nisl amet adipiscing accumsan blandit
        accumsan
      keyName: property
    - name: 'og:image'
      value: images/3.jpg
      keyName: property
      relativeUrl: true
    - name: 'twitter:card'
      value: summary_large_image
    - name: 'twitter:title'
      value: Introducing The Libris Theme
    - name: 'twitter:description'
      value: >-
        Vis accumsan feugiat adipiscing nisl amet adipiscing accumsan blandit
        accumsan
    - name: 'twitter:image'
      value: images/hcl.png
      relativeUrl: true
layout: post
---

Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator.

### Using Private Repo (SSH) Keys and (HTTPS) Tokens

To access private repos, generally an SSH key or a token is required. Terraform can accept both keys (for SSH) and tokens (for HTTPS) to access git repos. Both keys or tokens must first be added to the cluster as a kubernetes Secret.

To start, you'll need an basic understanding of Git, SSH, and optionally GitHub. Let's pretend our private git repo is hosted on GitHub and we want to use HTTPS to download our module. First, get an "Access Token" from GitHub. Check the "repo" access checkbox. (Need help? Check out this article to help you [Generate Access Tokens from Github Account](https://techmonger.github.io/58/github-token-authentication/#generate-token).)

<img style="padding-top:20px;padding-bottom:20px;" src="/images/gh-access-token-setup.png"/>

When you create the token, the token will only show up once. Copy it. We'll save this to the cluster as a Secret.

<img style="padding-top:20px;padding-bottom:20px;" src="/images/gh-access-token.png"/>

Create a Secret in your cluster with the token.


```bash
GHTOKEN=$(printf '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' | base64)

cat << EOF | kubectl apply -f -
apiVersion: v1
data:
  mytoken: $GHTOKEN
kind: Secret
metadata:
  name: gh-access-token
  namespace: default
type: Opaque
EOF
```

Here we save our Github token to the cluster as a Secret in a data key called `mytoken` in the `default` namespace. The namespace is important since the terraform k8s-resource we will create next can only access the Secret in the same namespace.

After the Secret is created, next create the terraform k8s-resource manifest and add the key we created above to `scmAuthMethods` of the terraform spec.

```yaml
apiVersion: tf.isaaguilar.com/v1alpha1
kind: Terraform
metadata:
  name: my-module
spec:
  terraformVersion: 1.1.9
  terraformModule: https://github.com/isaaguilar/terraform-do-something-awesome.git?ref=main
  customBackend: |-
    terraform {
      backend "kubernetes" {
        secret_suffix     = "my-module"
        namespace         = "default"
        in_cluster_config = true
      }
    }

  # *-------------------------*
  scmAuthMethods:
  - host: github.com
    git:
      https:
        tokenSecretRef:
          name: gh-access-token
          key: mytoken
  # *-------------------------*

  keepLatestPodsOnly: true
  ignoreDelete: false
  writeOutputsToStatus: true
```

The `scmAuthMethods` is an array of methods. Each method takes a `host:`, in this case we're using `github.com`. And for this host, we're using `git:` as an SCM.

For git, we have the option use use `https:` like we're doing here. Another option is `ssh:` which we'll try later on. Both `https` and `ssh` options have configurations for the secret reference.

Apply the terraform k8s manifest and there shouldn't be any issues getting to the private repo on github.

**Using a token to get private repo**

<script id="asciicast-491183" src="https://asciinema.org/a/491183.js" async></script>

A few notes:

1. When an HTTPS token is defined for a host, all git pulls, whether it be downloading the initial module or any module pulled within the a module will use the defined token.
2. Using an HTTPS token to pull a git module that pulls over SSH will not work. Use `scmAuthMethods[].git.ssh`.
3. Only a single token can be used to pull git resources over HTTPS. Use SSH if there are multiple git hosts for your Terraform modules.


