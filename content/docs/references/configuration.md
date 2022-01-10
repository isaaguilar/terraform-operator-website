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

## TerraformSpec v1alpha1 tf.isaaguilar.com

| Field | Description |
| --- | --- |
| `terraformModule`<br/>_string_ | A remote URL to fetch the Terraform module. The URL uses a variation of Terraform's "[Module Source](https://www.terraform.io/language/modules/sources#module-sources)" URL-like syntax. As of writing this, only git/github options are supported. |
| `terraformModuleConfigMap`<br/>_[ConfigMapSelector](#configmapselector-v1alpha1-tfisaaguilarcom)_ | Mount a ConfigMap as the Terraform module. |
| `terraformModuleInline`<br/>_string_ | Write the terraform module as a string. |
| `terraformVersion`<br/>_string_ | the Terraform version to use for the module. Defaults to `1.1.3` |
| `terraformRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Terraform Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `scriptRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Script Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `setupRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Setup Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `keepCompletedPods`<br/>_boolean_ | When `true` will keep completed pods. Default is `false` and completed pods are removed. |
| `runnerRules`<br/>_[PolicyRule](#policyrule-v1-rbacauthorizationk8sio)_ | RunnerRules are RBAC rules that will be added to all runner pods. |
| `runnerAnnotations`<br/>_object_ |  RunnerAnnotations is an unstructured key value map or annotations that will be added to all runner pods. |
| `outputsSecret`<br/>_string_ | OutputsSecret will create a secret with the outputs from the terraform module. All outputs from the module will be written to the secret unless the user defines "outputsToInclude" or "outputsToOmit". |
| `outputsToInclude`<br/>_string array_ | A whitelist of the terraform module's outputs to save to the `OutputsSecret` or [`TerraformStatus`](#terraformstatus-v1alpha1-tfisaaguilarcom) |
| `outputsToOmit`<br/>_string array_ | A blacklist of the terraform module's outputs to omit when writing the to the `OutputsSecret` or [`TerraformStatus`](#terraformstatus-v1alpha1-tfisaaguilarcom) |
| `writeOutputsToStatus`<br/>_boolean_ | |
| `terraformVersion`<br/>_string_ | |
| `scriptRunnerVersion`<br/>_string_ | |
| `setupRunnerVersion`<br/>_string_ | |
| `terraformRunner`<br/>_string_ | |
| `scriptRunner`<br/>_string_ | |
| `setupRunner`<br/>_string_ | |
| `terraformRunnerPullPolicy`<br/>_string_ | |
| `scriptRunnerPullPolicy`<br/>_string_ | |
| `setupRunnerPullPolicy`<br/>_string_ | |
| `resourceDownloads`<br/>_[ResourceDownload](#resourcedownload-v1alpha1-tfisaaguilarcom) array_ | |
| `env`<br/>_[EnvVar](#envvar-v1-core) array_ | |
| `serviceAccount`<br/>_string_ | |
| `credentials`<br/>_[Credentials](#credentials-v1alpha1-tfisaaguilarcom) array_ | |
| `ignoreDelete`<br/>_boolean_ | |
| `customBackend`<br/>_string_ | |
| `exportRepo`<br/>_[ExportRepo](#exportrepo-v1alpha1-tfisaaguilarcom)_ | |
| `preInitScript`<br/>_string_ | |
| `postInitScript`<br/>_string_ | |
| `prePlanScript`<br/>_string_ | |
| `postPlanScript`<br/>_string_ | |
| `preApplyScript`<br/>_string_ | |
| `postApplyScript`<br/>_string_ | |
| `preInitDeleteScript`<br/>_string_ | |
| `postInitDeleteScript`<br/>_string_ | |
| `prePlanDeleteScript`<br/>_string_ | |
| `postPlanDeleteScript`<br/>_string_ | |
| `preApplyDeleteScript`<br/>_string_ | |
| `postApplyDeleteScript`<br/>_string_ | |
| `sshTunnel`<br/>_[ProxyOpts](#proxyopts-v1alpha1-tfisaaguilarcom)_ | |
| `scmAuthMethods`<br/>_[SCMAuthMethod](#scmauthmethod-v1alpha1-tfisaaguilarcom) array_ | |


## ResourceDownload v1alpha1 tf.isaaguilar.com
| Field | Description |
| --- | --- |

## Credentials v1alpha1 tf.isaaguilar.com
| Field | Description |
| --- | --- |

## ExportRepo v1alpha1 tf.isaaguilar.com
| Field | Description |
| --- | --- |

## ProxyOpts v1alpha1 tf.isaaguilar.com
| Field | Description |
| --- | --- |

## SCMAuthMethod v1alpha1 tf.isaaguilar.com
| Field | Description |
| --- | --- |

## ConfigMapSelector v1alpha1 tf.isaaguilar.com

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a ConfigMap |
| `key`<br/>_string_ | The key to select |

## TerraformStatus v1alpha1 tf.isaaguilar.com

## EnvVar v1 core

| Field | Description |
| --- | --- |
`name`<br/>_string_ | Name of the environment variable. Must be a C_IDENTIFIER. |
`value`<br/>_string_ | Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to "". |
`valueFrom`<br/>_[EnvVarSource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#envvarsource-v1-core)_ | Source for the environment variable's value. Cannot be used if value is not empty. |

## ConfigMapKeySelector v1 core

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a ConfigMap |
| `key`<br/>_string_ | The key to select |

## PolicyRule v1 rbac.authorization.k8s.io

| Field | Description |
| --- | --- |
| `apiGroups`<br/>_string array_ | APIGroups is the name of the APIGroup that contains the resources. If multiple API groups are specified, any action requested against one of the enumerated resources in any API group will be allowed. |
| `nonResourceURLs`<br/>_string array_ | NonResourceURLs is a set of partial urls that a user should have access to. *s are allowed, but only as the full, final step in the path Since non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding. Rules can either apply to API resources (such as "pods" or "secrets") or non-resource URL paths (such as "/api"), but not both. |
| `resourceNames`<br/>_string array_ | ResourceNames is an optional white list of names that the rule applies to. An empty set means that everything is allowed. |
| `resources`<br/>_string array_ | Resources is a list of resources this rule applies to. ResourceAll represents all resources.
| `verbs`<br/>_string array_ | Verbs is a list of Verbs that apply to ALL the ResourceKinds and AttributeRestrictions contained in this rule. VerbAll represents all kinds. |

