---
title: Introduction
seo:
  title: Introduction to Terraform Operator
  description: This is the documentation page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Introduction to Terraform Operator
      keyName: property
    - name: 'og:description'
      value: This is the documentation page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Introduction to Terraform Operator
    - name: 'twitter:description'
      value: This is the documentation page
layout: docs
---

## What is terraform-operator?

This project is:

- A way to run Terraform in Kubernetes by defining Terraform deployments as Kubernetes manifests
- A controller that configures and starts [Terraform Workflows](core-concepts/workflow) when it sees changes to the Kubernetes manifest
- Workflow runner pods that execute Terraform plan/apply and other user-defined scripts

This project is not:

- An HCL to YAML converter or vice versa
- A Terraform Module or Registry