---
title: API Reference v0.5.0
excerpt: In this section you'll find docs related to Terraform Operator's API and other features.
seo:
  title: API Reference v0.5.0
  description: This is a configuration overview of Terraform Operator
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: References
      keyName: property
    - name: 'og:description'
      value: This is the references page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: References
    - name: 'twitter:description'
      value: This is the references page
layout: docs
hidden: true
weight: 1020
---

The following is a list of configurable parameters of the `Terraform` CRD. A brief description about each parameter will be defined here. Fore more in-depth details about the features, see [Core Concepts](../../core-concepts).

## TerraformSpec v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `terraformModule`<br/>_string_ | A remote URL to fetch the Terraform module. The URL uses a variation of Terraform's "[Module Source](https://www.terraform.io/language/modules/sources#module-sources)" URL-like syntax. This value will be parsed into all the components of an address, like `host`, `port`, `path`, `scheme`, etc. See [ParsedAddress](#tbd) for a detailed explanation the parser. |
| `terraformModuleConfigMap`<br/>_[ConfigMapSelector](#configmapselector-v1alpha1-tf)_ | Mount a ConfigMap as the Terraform module. |
| `terraformModuleInline`<br/>_string_ | Write the terraform module as a string. |
| `terraformVersion`<br/>_string_ | the Terraform version to use for the module. Defaults to `1.1.3` |
| `terraformRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Terraform Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `scriptRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Script Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `setupRunnerExecutionScriptConfigMap`<br/>_[ConfigMapKeySelector](#configmapkeyselector-v1-core)_ | Allows the user to define a custom script for the [Setup Runner](#tbd) pod. The custom-script replaces the default script executed by the image. |
| `keepCompletedPods`<br/>_boolean_ | When `true` will keep completed pods. Default is `false` and completed pods are removed. |
| `runnerRules`<br/>_[PolicyRule](#policyrule-v1-rbacauthorizationk8sio)_ | RunnerRules are RBAC rules that will be added to all runner pods. |
| `runnerAnnotations`<br/>_object_ |  RunnerAnnotations is an unstructured key value map of annotations that will be added to all runner pods. |
| `outputsSecret`<br/>_string_ | OutputsSecret will create a secret with the outputs from the terraform module. All outputs from the module will be written to the secret unless the user defines "outputsToInclude" or "outputsToOmit". |
| `outputsToInclude`<br/>_string array_ | A whitelist of the terraform module's outputs to save to the `OutputsSecret` or [`TerraformStatus`](#terraformstatus-v1alpha1-tf) |
| `outputsToOmit`<br/>_string array_ | A blacklist of the terraform module's outputs to omit when writing the to the `OutputsSecret` or [`TerraformStatus`](#terraformstatus-v1alpha1-tf) |
| `writeOutputsToStatus`<br/>_boolean_ | When `true` the terraform module's outputs get written to the [`TerraformStatus`](#terraformstatus-v1alpha1-tf) |
| `scriptRunnerVersion`<br/>_string_ | The tag of the [Script Runner](#tbd) image. |
| `setupRunnerVersion`<br/>_string_ | The tag of the [Setup Runner](#tbd) image. |
| `terraformRunner`<br/>_string_ | The repo of the [Terraform Runner](#tbd) image. |
| `scriptRunner`<br/>_string_ | The repo of the [Script Runner](#tbd) image. |
| `setupRunner`<br/>_string_ | The repo of the [Setup Runner](#tbd) image. |
| `terraformRunnerPullPolicy`<br/>_string_ | The `pullPolicy` for the [Terraform Runner](#tbd) pod. |
| `scriptRunnerPullPolicy`<br/>_string_ | The `pullPolicy` for the [Script Runner](#tbd) pod. |
| `setupRunnerPullPolicy`<br/>_string_ | The `pullPolicy` for the [Setup Runner](#tbd) pod. |
| `resourceDownloads`<br/>_[ResourceDownload](#resourcedownload-v1alpha1-tf) array_ | ResourceDownloads defines other files to download into a path relative to the terraform module's directory.  The `tfvar` type is a special file that does not get added into the terraform module's directory. The `tfvar` type gets added to a special directory and gets utilized when making the "terraform plan". The `tfvar` special directory is also used by the [Export Repo](#tbd) feature. |
| `env`<br/>_[EnvVar](#envvar-v1-core) array_ | Define environment variables used by all workflow runners. A common use case is the `TF_VAR_` prefixed variables that get consumed in the "terraform plan". `TF_VAR_` prefixed variables are also utilized by the [Export Repo](#tbd) feature. |
| `serviceAccount`<br/>_string_ | Use a specific kubernetes ServiceAccount for workflow runner pods. If not specified, a new ServiceAccount is created per [generation](#tbd). |
| `credentials`<br/>_[Credentials](#credentials-v1alpha1-tf) array_ | Credentials generally used for Terraform providers |
| `ignoreDelete`<br/>_boolean_ | Bypass the finalization process in order to remove the Terraform resource from kubernetes without running any delete jobs. |
| `customBackend`<br/>_string_ | Configure the terraform backend by writing an inline Terraform [Backend Configuration](https://www.terraform.io/language/settings/backends/configuration). If this field is omitted, a default consul backend configuration will be used, which will require a consul installation into the cluster. |
| `exportRepo`<br/>_[ExportRepo](#exportrepo-v1alpha1-tf)_ | Consolidate and save the "tfvar"s to a single file, then export the file to a remote github repo. Specify the repo and the path and the [Export Runner](#tbd) will run after the setup phase. |
| `preInitScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform init". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow.  |
| `postInitScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform init". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `prePlanScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform plan". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `postPlanScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform plan". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `preApplyScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform apply". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `postApplyScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform apply". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `preInitDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform init". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `postInitDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform init". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `prePlanDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform plan -destroy". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `postPlanDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform plan -destroy". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `preApplyDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run before "terraform apply". "`pre*`" scripts run as [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) in a [Terraform Runner](#tbd) pod. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `postApplyDeleteScript`<br/>_string_ | A script, written as an inline yaml string, that will run after "terraform apply". "`post*`" scripts run as standalone pods in the workflow. All scripts get executed from within the root of the terraform module's directory. Therefore, files created, changed, or removed from this directory, or anywhere in the user's `$HOME` directory, will persist for the next stage in the workflow. |
| `sshTunnel`<br/>_[ProxyOpts](#proxyopts-v1alpha1-tf)_ | SSHTunnel can be defined for pulling from scm sources that cannot be accessed by the network the operator/runner runs in. An example is trying to reach an Enterprise Github server running on a private network. |
| `scmAuthMethods`<br/>_[SCMAuthMethod](#scmauthmethod-v1alpha1-tf) array_ | A SCMAuthMethod is used to select the kubernetes secrets that provide the passwords, tokens or ssh-keys required to access private servers and repos. The actual creation of the kubernetes secret is not handled by Terraform Operator. |


## ResourceDownload v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `address`<br/>_string_ | Source url of resources to fetch. The URL uses a variation of Terraform's "[Module Source](https://www.terraform.io/language/modules/sources#module-sources)" URL-like syntax. This value will be parsed into all the components of an address, like `host`, `port`, `path`, `scheme`, etc. See [ParsedAddress](#tbd) for a detailed explanation the parser. |
| `useAsVar`<br/>_boolean_ | Add the downloaded resource file as a tfvar via the `-var-file` flag of the "terraform plan" command. The downloaded resource must not be a directory. |

## Credentials v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `secretNameRef`<br/>_[SecretNameRef](#secretnameref-v1alpha1-tf)_ | Load environment variables into the workflow runner pods from a kubernetes Secret. |
| `awsCredentials`<br/>_[AWSCredentials](#awscredentials-v1alpha1-tf)_ | Methods to load AWS-specific credentials into the workflow runner pods. If using `AWS_ACCESS_KEY_ID` and/or environment variables for credentials, use the `secretNameRef` instead. For IRSA, using the `serviceAccountAnnotations` to add the expected `eks.amazonaws.com/role-arn` is effectively the same thing. |
| `serviceAccountAnnotations`<br/>_object_ | ServiceAccountAnnotations is an unstructured key value map of annotations that is added to the kubernetes ServiceAccount that gets mounted by the workflow runner pods. Cloud IAM roles, such as Workload Identity on GCP and IRSA on AWS use this method of providing credentials to pods without haven't to manage secrets on the cluster. |

## ExportRepo v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `address`<br/>_string_ | Destination url of the repo to push `tfvar` and `config` files. The URL uses a variation of Terraform's "[Module Source](https://www.terraform.io/language/modules/sources#module-sources)" URL-like syntax. This value will be parsed into all the components of an address, like `host`, `port`, `path`, `scheme`, etc. See [ParsedAddress](#tbd) for a detailed explanation the parser. |
| `tfvarsFile`<br/>_string_ | The full path, including the directories and filename, relative to the root of the repo. The suffix of the file is not automatically added, so manually include the `.tfvars` file if desired. |
| `confFile`<br/>_string_ | The full path, including the directories and filename, relative to the root of the repo. The suffix of the file is not automatically added, so manually include the `.conf` file if desired. |

## ProxyOpts v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `host`<br/>_string_ | The host name or ip-address of the ssh tunnel host. |
| `user`<br/>_string_ | The username that can access the ssh tunnel host for the configured secret. |
| `sshKeySecretRef`<br/>_[SSHKeySecretRef](#sshkeysecretref-v1alpha1-tf)_ | Specifies the kubernetes Secret where a SSH key is stored. |

## SCMAuthMethod v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `host`<br/>_string_ | The host where private repos or servers are stored. |
| `git`<br/>_[GitSCM](#gitscm-v1alpha1-tf)_ | Configuration options for auth methods of git. |

## GitSCM v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `ssh`<br/>_[GitSSH](#gitssh-v1alpha1-tf)_ | SSH options for accessing git over ssh. |
| `https`<br/>_[GitHTTPS](#githttps-v1alpha1-tf)_ | HTTPS options for access git over https. |

## GitSSH v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `requireProxy`<br/>_boolean_ | Specifies if the target host of the [SCMAuthMethod](#scmauthmethod-v1alpha1-tf) requires a proxy to access. If true, the configured [SSHTunnel](#proxyopts-v1alpha1-tf) is the proxy used. |
| `sshKeySecretRef`<br/>_[SSHKeySecretRef](#sshkeysecretref-v1alpha1-tf)_ | Specifies the kubernetes Secret where a SSH key is stored. |

## GitHTTPS v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `requireProxy`<br/>_boolean_ | Specifies if the target host of the [SCMAuthMethod](#scmauthmethod-v1alpha1-tf) requires a proxy to access. If true, the configured [SSHTunnel](#proxyopts-v1alpha1-tf) is the proxy used. |
| `tokenSecretRef`<br/>_[TokenSecretRef](#tokensecretref-v1alpha1-tf)_ | Specifies the kubernetes Secret where a token key is stored. |

## ConfigMapSelector v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a ConfigMap |
| `key`<br/>_string_ | The key to select |

## SecretNameRef v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a kubernetes Secret |
| `namespace`<br/>_string_ | The namespace the secret is in. Omitting will select the same namespace as the resource |
| `key`<br/>_string_ | The key to select |

## SSHKeySecretRef v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a kubernetes Secret |
| `namespace`<br/>_string_ | The namespace the secret is in. Omitting will select the same namespace as the resource |
| `key`<br/>_string_ | The key to select |

## TokenSecretRef v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a kubernetes Secret |
| `namespace`<br/>_string_ | The namespace the secret is in. Omitting will select the same namespace as the resource |
| `key`<br/>_string_ | The key to select |

## AWSCredentials v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `irsa`<br/>_string_ | When defined will add the special IRSA annotation to the kubernetes ServiceAccount that get added to workflow runner pods. Using the [serviceAccountAnnotations](#credentials-v1alpha1-tf) to add the expected `eks.amazonaws.com/role-arn` is effectively the same thing.  |
| `kiam`<br/>_string_ | When defined will add the special KIAM annotation to the workflow runner pods. Using `runnerAnnotations` to add the expected `iam.amazonaws.com/role` is effectively the same thing. |

## TerraformStatus v1alpha1 tf
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |


# Kubernetes APIs

Some APIs used by Terraform Operator are adopted from Kubernetes itself. Below are the relevant APIs used by the Terraform CRD.

## EnvVar v1 core
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
`name`<br/>_string_ | Name of the environment variable. Must be a C_IDENTIFIER. |
`value`<br/>_string_ | Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to "". |
`valueFrom`<br/>_[EnvVarSource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.20/#envvarsource-v1-core)_ | Source for the environment variable's value. Cannot be used if value is not empty. |

## ConfigMapKeySelector v1 core
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `name`<br/>_string_ | Name of a ConfigMap |
| `key`<br/>_string_ | The key to select |

## PolicyRule v1 rbac.authorization.k8s.io
<hr style="border-top: 4px solid #8c8b8b;margin-top: 0px;"/>

| Field | Description |
| --- | --- |
| `apiGroups`<br/>_string array_ | APIGroups is the name of the APIGroup that contains the resources. If multiple API groups are specified, any action requested against one of the enumerated resources in any API group will be allowed. |
| `nonResourceURLs`<br/>_string array_ | NonResourceURLs is a set of partial urls that a user should have access to. *s are allowed, but only as the full, final step in the path Since non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding. Rules can either apply to API resources (such as "pods" or "secrets") or non-resource URL paths (such as "/api"), but not both. |
| `resourceNames`<br/>_string array_ | ResourceNames is an optional white list of names that the rule applies to. An empty set means that everything is allowed. |
| `resources`<br/>_string array_ | Resources is a list of resources this rule applies to. ResourceAll represents all resources.
| `verbs`<br/>_string array_ | Verbs is a list of Verbs that apply to ALL the ResourceKinds and AttributeRestrictions contained in this rule. VerbAll represents all kinds. |



***

Other articles in this section:
