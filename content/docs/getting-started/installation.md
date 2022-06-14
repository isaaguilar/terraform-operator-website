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

<!--<div class="note">
Generally, the helm chart is kept up-to-date with the latest stable release of Terraform Operator. However, the Terraform Operator <code>v0.5.0</code> release is not yet ready for installation with the current helm-chart release. Please use the <code>kubectl</code> install method instead.
</div>-->


## Install using Helm

```bash
helm repo add isaaguilar https://isaaguilar.github.io/helm-charts
helm repo update
helm upgrade --install terraform-operator isaaguilar/terraform-operator \
  --version v0.2.9 --namespace tf-system --create-namespace
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

Check out the [examples](https://github.com/isaaguilar/terraform-operator/tree/master/examples) directory to see the different options tf-operator handles. For a full list of options, see [API References](/docs/references/latest)