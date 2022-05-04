---
title: How to use Private Repos over SSH with Terraform Operator
draft: false
excerpt: >-
  Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator.
date: '2022-05-04'
author: Isa Aguilar
# thumb_image: images/4.jpg
image: images/hcl.png
seo:
  title: How to use Private Repos over SSH with Terraform Operator
  description: >-
    A demo of terraform-operator using SSH keys to access private git repos
  extra:
    - name: 'og:type'
      value: article
      keyName: property
    - name: 'og:title'
      value: How to use Private Repos over SSH with Terraform Operator
      keyName: property
    - name: 'og:description'
      value: >-
        A demo of terraform-operator using SSH keys to access private git repos
      keyName: property
    - name: 'og:image'
      value: images/hcl.png
      keyName: property
      relativeUrl: true
    - name: 'twitter:card'
      value: summary_large_image
    - name: 'twitter:title'
      value: How to use Private Repos over SSH with Terraform Operator
    - name: 'twitter:description'
      value: >-
        A demo of terraform-operator using SSH keys to access private git repos
    - name: 'twitter:image'
      value: images/hcl.png
      relativeUrl: true
layout: post
---

### Using Private Repo (SSH) Keys and (HTTPS) Tokens

Often Terraform modules are not stored in public git repos for any number of reasons. Fortunately, with the right keys or tokens, it's not that hard to access them. In this article we'll go over a few common examples of how to access terraform modules in private repos with Terraform Operator. In general, Terraform can accept either ssh keys and/or tokens to access modules in git repos.

#### Example 2: Private Repos over SSH

To start, you'll need an basic understanding of Git and SSH. Let's pretend our private git repo is hosted on `gitlab.com` and we want to use SSH to download our module. I'm not going to go into generating an SSH key and I'll assume you have a key that can access your git server.

The first thing we need to do is save the SSH key to Kubernetes as a Secret. Below is an example of me adding my key to the Kubernetes cluster. Note that the ssh key location on my system is at `~/.ssh/mygitid_rsa`. Change the filepath according to the key you've configured to access your git server.

```bash
$ GITSSHKEY=$(cat ~/.ssh/mygitid_rsa | base64)

$ cat << EOF | kubectl apply -f -
apiVersion: v1
data:
  my_key: $GITSSHKEY
kind: Secret
metadata:
  name: my-gitlab-ssh-key
  namespace: default
type: Opaque
EOF
```

In the above commands, we saved our GitLab access key to the cluster as a Secret called `my-gitlab-ssh-key` with data key `my_key` in the `default` namespace. Next we'll add these item to our terraform k8s-resource manifest.




Create the terraform k8s-resource manifest, let's call it `terraform.yaml`. The following is an example of my manifest. Notice the `scmAuthMethods`. The `scmAuthMethods` is an array of objects.

1. In example below, we'll fill in `host:` with `gitlab.com`. That is the host our ssh-key is valid for.
2. Next, we're using `git:` as the SCM (Source Control Management).
3. Under `git:`, we're going with the `ssh:` protocol.
4. And finally under `ssh:`, the secret that was created earlier is defined in `sshKeySecretRef:`.

Take a look for the final manifest:

```yaml
---
# terraform.yaml

apiVersion: tf.isaaguilar.com/v1alpha1
kind: Terraform
metadata:
  name: my-private-ssh-module
spec:
  terraformVersion: 1.1.9
  terraformModule: git@gitlab.com:isaaguilar/terraform-awesome-module.git?ref=main
  customBackend: |-
    terraform {
      backend "kubernetes" {
        secret_suffix     = "my-private-ssh-module"
        namespace         = "default"
        in_cluster_config = true
      }
    }
  # *-------------------------*
  scmAuthMethods:
  - host: gitlab.com
    git:
      ssh:
        sshKeySecretRef:
          name: my-gitlab-ssh-key
          key: my_key
  # *-------------------------*
  keepLatestPodsOnly: true
  ignoreDelete: false
  writeOutputsToStatus: true
```

Apply the manifest using kubectl and we're done and terraform-operator will handle the rest.

```bash
kubectl apply -f terraform.yaml
```

Here's the logs from the setup pod which completed successfully:

```
Cloning into '/tmp/tmp.DjOLKO/stack'...
Warning: Permanently added 'gitlab.com,172.65.251.78' (ECDSA) to the list of known hosts.
Already on 'main'
Your branch is up to date with 'origin/main'.
Using custom backend
stream closed
```


<div class="note">
SSH keys are usually tied to a user on the target server. Github, GitLab, and other Git providers assign the user <code>git</code> to any ssh key used to access a repo.
<br/><br/>
Private git servers can definitely be used as well. The main difference will be seen when defining the terraform module in the terraform k8s-resource.
<br/><br/>

For example, a github module would look like the following:

```yaml
kind: Terraform
spec:
  ...
  terraformModule: git@github.com:isaaguilar/terraform-my-awesome-module.git
```

If a private git server was used, it might look something like the following:

```yaml
kind: Terraform
spec:
  ...
  terraformModule: bob@172.16.0.200:/home/bob/terraform/my-awesome-module
```

</div>