---
title: Installation
weight: 1
seo:
  title: Installation
  description: Install Terraform Operator with Helm or try the bundled kubectl manifest.
  extra:

    # og
    - name: 'og:type'
      value: website
    - name: 'og:title'
      value: Installation options for Terraform Operator
    - name: 'og:description'
      value: How to install Terraform Operator with Helm. Or try the bundled manifest for a simple kubectl installation.
    - name: 'og:image'
      value: https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png


    # twitter
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Installation options for Terraform Operator
    - name: 'twitter:description'
      value: Install Terraform Operator with Helm or the bundled kubectl manifest.
    - name: 'twitter:image'
      value: https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png
layout: docs
---

<!--<div class="note">
Generally, the helm chart is kept up-to-date with the latest stable release of Terraform Operator. However, the Terraform Operator <code>v0.5.0</code> release is not yet ready for installation with the current helm-chart release. Please use the <code>kubectl</code> install method instead.
</div>-->

<div class="important">
These docs will reference the release v0.9.0-pre2+ which uses the latest CRD (ie the <code>v1alpha2</code> apiVersion).
</div>

## Install using Helm

Install the latest using helm:

```bash
#!/usr/bin/env bash
helm repo add isaaguilar https://isaaguilar.github.io/helm-charts
helm repo update
helm upgrade --install terraform-operator isaaguilar/terraform-operator \
  --version v0.2.13 --namespace tf-system --create-namespace
```

See previous versions that can be installed by running `helm search repo -l`.

<div class="note">
See <a href="https://github.com/isaaguilar/helm-charts/tree/master/charts/terraform-operator">terraform-operator's helm chart</a> for options.
</div>

**CRD Upgrades when using Helm**

Helm is a great tool for upgrading resources, but it does not handle CRDs very well. See [Helm Custom Resource Definitions](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-1-let-helm-do-it-for-you) for details.

Here is a nifty script to install the right CRD for a specific version of the helm chart:

```bash
#!/usr/bin/env bash
tmpdir=$(mktemp -d)
helm fetch isaaguilar/terraform-operator -d $tmpdir --version v0.2.13 --untar
kubectl apply -f $tmpdir/crds
```

## Install using kubectl

Install the bundle which includes the correct CRD version for the release:

```bash
#!/usr/bin/env bash
git clone https://github.com/isaaguilar/terraform-operator.git
cd terraform-operator
kubectl apply -f deploy/bundles/v0.9.0-pre2/v0.9.0-pre2.yaml
```

Once the operator is installed, terraform resources are ready to be deployed.

Check out the [examples](https://github.com/isaaguilar/terraform-operator/tree/master/examples) directory to see the different options tf-operator handles. For a full list of options, see [API References](/docs/references/latest)