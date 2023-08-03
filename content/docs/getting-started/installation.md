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

<!--<div class="important">

</div>-->

## Install using Helm

**Add or update the helm repos**

```bash
#!/usr/bin/env bash
helm repo add galleybytes https://galleybytes.github.io/helm-charts
helm repo update
```

**CRD Upgrades when using Helm**

Helm is a great tool for upgrading resources, but it does not handle CRDs very well. See [Helm Custom Resource Definitions](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-1-let-helm-do-it-for-you) for details.

Here is a nifty script to install the right CRD for a specific version of the helm chart:

```bash
#!/usr/bin/env bash
tmpdir=$(mktemp -d)
helm fetch galleybytes/terraform-operator -d $tmpdir --version 0.4.5 --untar
kubectl apply -f $tmpdir/terraform-operator/crds
```

**Install the latest using helm:**

```bash
#!/usr/bin/env bash
helm upgrade --install terraform-operator galleybytes/terraform-operator --version 0.4.5 --namespace tf-system --create-namespace
```

See previous versions that can be installed by running `helm search repo -l`.

<div class="note">
See <a href="https://github.com/galleybytes/helm-charts/tree/master/charts/terraform-operator">terraform-operator's helm chart</a> for options.
</div>



## Install using kubectl

Install the bundle which includes the correct CRD version for the release:

```bash
#!/usr/bin/env bash
git clone https://github.com/galleybytes/terraform-operator.git
cd terraform-operator
kubectl apply -f deploy/bundles/v0.13.0/v0.13.0.yaml
```

Once the operator is installed, terraform resources are ready to be deployed.

Check out the [examples](https://github.com/galleybytes/terraform-operator/tree/master/examples) directory to see the different options tf-operator handles. For a full list of options, see [API References](/docs/references/latest)