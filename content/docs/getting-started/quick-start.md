---
title: Quick Start
weight: 2
seo:
  title: Quick Start
  description: This is the quick start page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Quick Start
      keyName: property
    - name: 'og:description'
      value: This is the quick start page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Quick Start
    - name: 'twitter:description'
      value: This is the quick start page
layout: docs
---

## Hello Terraform Operator Example

Create your first Terraform resource using Terraform-operator

Create a Terraform resource by running this _hello_world_ example:



```bash
printf 'apiVersion: tf.isaaguilar.com/v1alpha1
kind: Terraform
metadata:
  name: hello-tfo
spec:
  terraformModule: https://github.com/isaaguilar/simple-aws-tf-modules.git//create_file

  customBackend: |-
    terraform {
      backend "kubernetes" {
        secret_suffix    = "hello-tfo"
        in_cluster_config  = true
      }
    }

  keepCompletedPods: true
'|kubectl apply -f-
```

<div class="note">
  <code>backend "kubernetes"</code> is an available backend for Terraform v0.13+.
</div>

See the pods getting created:

```bash
kubectl get po -w| grep hello-tfo
```

Finally, go ahead and delete the resource:

```bash
kubectl delete tf hello-tfo
```

The default behavior is to clean up the terraform resource. Watch the delete workflow being executed:

<div class="note">
  The delete will go by fast for this sample module, so the following command may not show any results. If that's the case, the terraform was already cleaned up.
</div>

```bash
kubectl get po -w| grep hello-tfo
```