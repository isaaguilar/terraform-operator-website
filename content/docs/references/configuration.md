---
title: Configuration
weight: 1
seo:
  title: Configuration
  description: This is a configuration overview of Terraform Operator
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Configuration
      keyName: property
    - name: 'og:description'
      value: This is the configuration page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Configuration
    - name: 'twitter:description'
      value: This is the configuration page
layout: docs
---

The following is a list of configurable parameters of the `Terraform` CRD. A brief description about each parameter will be defined here. Fore more in-depth details about the features, see [Core Concepts](../../core-concepts).



| `spec` | Description |
| --- | --- |
| `terraformModule`\* | `string` A remote URL to fetch the Terraform module. The URL uses a variation of Terraform's "[Module Source](https://www.terraform.io/language/modules/sources#module-sources)" URL-like syntax. As of writing this, only git/github options are supported. |
| `terraformModuleConfigMap` | `object` Use the `name` and optional `key` of an existing ConfigMap as the Terraform module to use. |
| `terraformModuleInline` | `string`  Write the terraform module as a string. |
| `terraformVersion` | `string` the Terraform version to use for the module. Defaults to `1.1.3` |
| `TerraformRunnerExecutionScriptConfigMap` | `object` |
| `ScriptRunnerExecutionScriptConfigMap` | `object` |
| `SetupRunnerExecutionScriptConfigMap` | `object` |
| `KeepCompletedPods` | `bool` |
| `RunnerRules` | `object` |
| `RunnerAnnotations` | `object` |
| `OutputsSecret` | `string` |



