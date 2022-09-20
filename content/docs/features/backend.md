---
title: Backend
weight: 1
seo:
  title: Backend
  description: Configure the backend to save your TFstate file to
  extra:

    # og
    - name: 'og:type'
      value: website
    - name: 'og:title'
      value: 'Feature: Backend'
    - name: 'og:description'
      value: The backend feature allows you to configure where to save your tfstate file.
    - name: 'og:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'

    # twitter
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: 'Feature: Backend'
    - name: 'twitter:description'
      value: The backend feature allows you to configure where to save your tfstate file.
    - name: 'twitter:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'
layout: docs
showJumpToSection: false
---

<div class="note"><code>backend</code> is a required field of the <a href="http://localhost:1313/docs/references/v0.9.0/#TerraformSpec_v1alpha2_tf.isaaguilar.com">Terraform spec</a>.</div>

Backend is a required Terraform Operator field. It is defined as a multiline string in yaml and must be a
fully defined Terraform [Backend Block](https://www.terraform.io/language/settings/backends/configuration#using-a-backend-block).
For more information see https://www.terraform.io/language/settings/backends/configuration.

Example usage of the kubernetes cluster as a backend:

```hcl
  terraform {
   backend "kubernetes" {
    secret_suffix     = "all-task-types"
    namespace         = "default"
    in_cluster_config = true
   }
  }
```

Example of a remote backend:

```hcl
  terraform {
   backend "remote" {
    organization = "example_corp"
    workspaces {
      name = "my-app-prod"
    }
   }
  }
```

Usage of the kubernetes backend is only available as of terraform v0.13+.

