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
  name: tf-operator-test
spec:

  terraformVersion: 0.12.23
  terraformModule:
    address: https://github.com/cloudposse/terraform-aws-test-module.git

  customBackend: |-
    terraform {
      backend "local" {
        path = "relative/path/to/terraform.tfstate"
      }
    }

  keepCompletedPods: true
'|kubectl apply -f-
```

<div class="note">
  <strong>Note:</strong>
  This is the demo content for demonstration purpose only. The primary function of this content is to show you how to get started with Terraform Operator, and using a local <strong>"local"</strong> type backend is strongly discouraged.
</div>

See the pods getting created:

```bash
kubectl get po | grep tf-operator-test
```

<div class="note">
Since the configured tf module just creates a random number, the workflow should complete in seconds.
</div>

Delete the resource:

```bash
kubectl delete tf tf-operator-test
```