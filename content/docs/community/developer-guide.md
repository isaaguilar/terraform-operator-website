---
title: Development Guide
excerpt: >-
  Learn how to set up your system for local development of Terraform Operator
seo:
  title: Development Guide
  description: This is the Development Guide page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Development Guide
      keyName: property
    - name: 'og:description'
      value: This is the Development Guide page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Development Guide
    - name: 'twitter:description'
      value: This is the Development Guide page
layout: docs
---

## Development

Requires the following installed on your system:

- go >= v1.15.0

Run `make install` to install or update the crd in your current-context cluster.

Finally, run `make run` to start the controller to operate in your current-context cluster.