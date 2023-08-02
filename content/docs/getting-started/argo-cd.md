---
title: ArgoCD integration
weight: 3
seo:
  title: ArgoCD integration
  description: Walkthrough of setting up terraform operator with ArgoCD
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: ArgoCD integration
      keyName: property
    - name: 'og:description'
      value: rough of setting up terraform operator with ArgoCD
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Quick Start
    - name: 'twitter:description'
      value: rough of setting up terraform operator with ArgoCD
layout: docs
---

## ArgoCD

This assumes you are using [ArgoCD](https://argo-cd.readthedocs.io/en/stable) applications to deploy your Terraform operators resource.

### Health assesment

By default, ArgoCD will just create the Terraform Operator resource and see that all is well in the world. Except it isn't actually; until the Terraform operator has said it is.

It is therefore necessary to tell ArgoCD how it must read the status from the Terraform Operator resource.

This is done by making a [custom health specification](https://argo-cd.readthedocs.io/en/stable/operator-manual/health/#way-1-define-a-custom-health-check-in-argocd-cm-configmap)

```yaml
# Enable the health assessment of terraform
resource.customizations.health.tf.galleybytes.com_Terraform: |
  hs = {}
  hs.status = "Progressing"
  hs.message = ""
  if obj.status ~= nil then
    if obj.status.phase ~= nil then
      if obj.status.phase == "initializing" or obj.status.phase == "running" or obj.status.phase == "initializing-delete" or obj.status.phase == "deleting" then
        if obj.status.stage.state == "failed" then
          hs.status = "Degraded"
        else
          hs.status = "Progressing"
        end
      elseif obj.status.phase == "completed" then
        hs.status = "Healthy"
      else
        hs.status = "Degraded"
      end
    end
    if obj.status.stage ~= nil then
      if obj.status.stage.message ~= nil then
        hs.message = obj.status.stage.message
      end
    end
  end
  return hs
```

<div class="note">
This configuration goes in the ArgoCD, not the Terraform Operator. See the above link for how to configure `argocd-cm` or if using [helm chart](https://artifacthub.io/packages/helm/argo/argo-cd) to deploy ArgoCD you can set the above with `configs.cm."resource\.customizations\.health\.tf\.galleybytes\.com_Terraform"`.
</div>
