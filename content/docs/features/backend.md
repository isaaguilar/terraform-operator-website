---
title: Backend
weight: 1
seo:
  title: Backend
  description: Configure the backend to save your TFstate file to
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Backend
      keyName: property
    - name: 'og:description'
      value: The backend feature enables configuring where tfstate is saved.
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Backend
    - name: 'twitter:description'
      value: The backend feature allows you to configure where to save your tfstate file.
layout: docs
---

<div class="note"><code>backend</code> is a required field of the <a href="http://localhost:1313/docs/references/latest">Terraform resource kind</a>.</div>

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

