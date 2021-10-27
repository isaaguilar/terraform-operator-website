---
title: Installation
weight: 1
seo:
  title: Installation
  description: This is the installation page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Installation
      keyName: property
    - name: 'og:description'
      value: This is the installation page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Installation
    - name: 'twitter:description'
      value: This is the installation page
layout: docs
---

## Install using Helm

```bash
helm repo add isaaguilar https://isaaguilar.github.io/helm-charts
helm install terraform-operator isaaguilar/terraform-operator --namespace tf-system --create-namespace
```

<div class="note">
See <a href="https://github.com/isaaguilar/helm-charts/tree/master/charts/terraform-operator">terraform-operator's helm chart</a> for options.
</div>

## Install using kubectl

First install the CRDs

```bash
kubectl apply -f deploy/crds/tf.isaaguilar.com_terraforms_crd.yaml
```

Then install the controller

```bash
kubectl apply -f deploy --namespace tf-system
```

Once the operator is installed, terraform resources are ready to be deployed.

Check out the [examples](examples) directory to see the different options tf-operator handles. See [complete-examples](../examples/complete-examples) for realistic examples.