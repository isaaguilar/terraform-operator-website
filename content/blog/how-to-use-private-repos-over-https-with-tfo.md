---
title: How to use Private Repos over HTTPS with Terraform Operator
draft: false
excerpt: >-
  Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator.
date: '2022-04-29'
author: Isa Aguilar
# thumb_image: images/4.jpg
image: images/hcl.png
seo:
  title: How to use Private Repos over HTTPS with Terraform Operator
  description: >-
    A demo of terraform-operator using a token to access private git repos in Github.com over HTTPS.
  extra:
    - name: 'og:type'
      value: article
      keyName: property
    - name: 'og:title'
      value: How to use Private Repos over HTTPS with Terraform Operator
      keyName: property
    - name: 'og:description'
      value: >-
        A demo of terraform-operator using a token to access private git repos in Github.com over HTTPS.
      keyName: property
    - name: 'og:image'
      value: images/hcl.png
      keyName: property
      relativeUrl: true
    - name: 'twitter:card'
      value: summary_large_image
    - name: 'twitter:title'
      value: How to use Private Repos over HTTPS with Terraform Operator
    - name: 'twitter:description'
      value: >-
        A demo of terraform-operator using a token to access private git repos in Github.com over HTTPS.
    - name: 'twitter:image'
      value: images/hcl.png
      relativeUrl: true
layout: post
---

### Using Private Repo (SSH) Keys and (HTTPS) Tokens

Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator. In general, Terraform can accept either ssh keys and/or tokens to access modules in git repos.

#### Example 1: Private Repos over HTTPS on Github

To start, you'll need an basic understanding of Git, and GitHub. Let's pretend our private git repo is hosted on GitHub and we want to use HTTPS to download our module. First, get an "Access Token" from GitHub. Check the "repo" access checkbox. (Need help? Check out this article to help you [Generate Access Tokens from Github Account](https://techmonger.github.io/58/github-token-authentication/#generate-token).)

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

In the above code, we saved our Github token to the cluster as a Secret called `gh-access-token` with data key `mytoken` in the `default` namespace. Next we'll add these item to our terraform k8s-resource manifest.

Create the terraform k8s-resource manifest, let's call it `terraform.yaml`. The following is an example of my manifest. Notice the `scmAuthMethods`. The `scmAuthMethods` is an array of objects.

1. In example below, we'll fill in `host:` with `github.com`. That is the host our token is valid for.
2. Next, we're using `git:` as the SCM (Source Control Management).
3. Under `git:`, we're going with the `https:` protocol. The other protocol for git is `ssh:` which will be covered later.
4. And finally under `https:`, the secret that was created earlier is defined in `tokenSecretRef:`.

Take a look for the final manifest:

```yaml
---
# terraform.yaml

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

Apply the manifest using kubectl and we're done and terraform-operator will handle the rest.

```bash
kubectl apply -f terraform.yaml
```

> Watch this short terminal capture which follows the steps above of
> using a Github Token with Terraform Operator.
> <script id="asciicast-491183" src="https://asciinema.org/a/491183.js" async></script>

<div class="note">
A few notes:

1. When an HTTPS token is defined for a host, all git pulls, whether it be downloading the initial module or any module pulled within the a module will use the defined token.
2. Using an HTTPS token to pull a git module that pulls over SSH will not work. Use `scmAuthMethods[].git.ssh`.
3. Only a single token can be used to pull git resources over HTTPS. Use SSH if there are multiple git hosts for your Terraform modules.
</div>

