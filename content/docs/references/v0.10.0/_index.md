---
title: Release v0.10.0
excerpt: In this section you'll find docs related to Terraform Operator's API and other features.
seo:
  title: Release v0.10.0
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
weight: 1004
showJumpToSection: false
aliases:
- /docs/references/latest
---


<div class="note">
This doc is good for Terraform Operator release v0.10.0 and covers the resource apiVersion: <code>v1alpha2</code>
</div>

The following is a list of configurable parameters of the `Terraform` CRD. A brief description about each parameter will be defined here. Fore more in-depth details about the features, see [Core Concepts](../../architecture).



# Terraform v1alpha2 tf.isaaguilar.com



<table class="apitable">
<tr><th>Kind</th><th>Group</th><th>Version</th></tr>
<tr><td>Terraform</td><td>tf.isaaguilar.com</td><td>v1alpha2</td></tr>
</table>



<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">apiVersion</code><br/><i>string</i></td><td> APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources </td></tr>
<tr><td><code class="field">kind</code><br/><i>string</i></td><td> Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds </td></tr>
<tr><td><code class="field">metadata</code><br/><i><a href="https://pkg.go.dev/k8s.io/apimachinery/pkg/apis/meta/v1#ObjectMeta">k8s.io/apimachinery/pkg/apis/meta/v1.ObjectMeta</a></i></td><td>  </td></tr>
<tr><td><code class="field">spec</code><br/><i><a href="#TerraformSpec_v1alpha2_tf.isaaguilar.com">TerraformSpec</a></i></td><td>  </td></tr>
<tr><td><code class="field">status</code><br/><i><a href="#TerraformStatus_v1alpha2_tf.isaaguilar.com">TerraformStatus</a></i></td><td>  </td></tr>
</table>



<h2 id="TerraformSpec_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#TerraformSpec_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  TerraformSpec v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">backend</code><br/><i>string</i></td><td> Backend is mandatory terraform backend configuration. Must use a valid terraform backend block. For more information see https://www.terraform.io/language/settings/backends/configuration

Example usage of the kubernetes cluster as a backend:

```hcl
  terraform {
   backend "kubernetes" {
    secret_suffix     = "all-task-types"
    namespace         = "default"
    in_cluster_config = true
   }
  }
```

Example of a remote backend:

```hcl
  terraform {
   backend "remote" {
    organization = "example_corp"
    workspaces {
      name = "my-app-prod"
    }
   }
  }
```

Usage of the kubernetes backend is only available as of terraform v0.13+. </td></tr>
<tr><td><code class="field">credentials</code><br/><i>array[<a href="#Credentials_v1alpha2_tf.isaaguilar.com">Credentials</a>]</i></td><td> Credentials is an array of credentials generally used for Terraform providers </td></tr>
<tr><td><code class="field">ignoreDelete</code><br/><i>boolean</i></td><td> IgnoreDelete will bypass the finalization process and remove the tf resource without running any delete jobs. </td></tr>
<tr><td><code class="field">images</code><br/><i><a href="#Images_v1alpha2_tf.isaaguilar.com">Images</a></i></td><td> Images describes the container images used by task classes. </td></tr>
<tr><td><code class="field">keepCompletedPods</code><br/><i>boolean</i></td><td> KeepCompletedPods when true will keep completed pods. Default is false and completed pods are removed. </td></tr>
<tr><td><code class="field">keepLatestPodsOnly</code><br/><i>boolean</i></td><td> KeepLatestPodsOnly when true will keep only the pods that match the current generation of the terraform k8s-resource. This overrides the behavior of `keepCompletedPods`. </td></tr>
<tr><td><code class="field">outputsSecret</code><br/><i>string</i></td><td> OutputsSecret will create a secret with the outputs from the module. All outputs from the module will be written to the secret unless the user defines "outputsToInclude" or "outputsToOmit". </td></tr>
<tr><td><code class="field">outputsToInclude</code><br/><i>array[string]</i></td><td> OutputsToInclude is a whitelist of outputs to write when writing the outputs to kubernetes. </td></tr>
<tr><td><code class="field">outputsToOmit</code><br/><i>array[string]</i></td><td> OutputsToOmit is a blacklist of outputs to omit when writing the outputs to kubernetes. </td></tr>
<tr><td><code class="field">persistentVolumeSize</code><br/><i><a href="https://pkg.go.dev/k8s.io/apimachinery/pkg/api/resource#Quantity">k8s.io/apimachinery/pkg/api/resource.Quantity</a></i></td><td> PersistentVolumeSize define the size of the disk used to store terraform run data. If not defined, a default of "2Gi" is used. </td></tr>
<tr><td><code class="field">plugins</code><br/><i>object</i></td><td> Plugins are tasks that run during a workflow but are not part of the main workflow. Plugins can be treated as just another task, however, plugins do not have completion or failure detection.

Example definition of a plugin:

```yaml
  plugins:
    monitor:
      image: ghcr.io/galleybytes/monitor:latest
      imagePullPolicy: IfNotPresent
      when: After
      task: setup
```

The above plugin task will run after the setup task has completed.

Alternatively, a plugin can be triggered to start at the same time of another task. For example:

```yaml
  plugins:
    monitor:
      image: ghcr.io/galleybytes/monitor:latest
      imagePullPolicy: IfNotPresent
      when: At
      task: setup
```

Each plugin is run once per generation. Plugins that are older than the current generation are automatically reaped. </td></tr>
<tr><td><code class="field">requireApproval</code><br/><i>boolean</i></td><td> RequireApproval will place a hold after completing a plan that prevents the workflow from continuing. However, the implementation of the hold takes place in the tf.sh script.

(See https://github.com/GalleyBytes/terraform-operator-tasks/blob/master/tf.sh)

Depending on the script that executes during the workflow, this field may be ignored if not implemented by the user properly. To approve a workflow using the official galleybytes implementation, a file needs to be placed on the workflow's persistent-volume:

- <code>$TFO_GENERATION_PATH/\_approved\_\<uuid-of-plan-pod></code> - to approve the workflow

- <code>$TFO_GENERATION_PATH/\_canceled\_\<uuid-of-plan-pod></code> - to deny and cancel the workflow

Deleting the plan that is holding will spawn a new plan and a new approval will be required. </td></tr>
<tr><td><code class="field">scmAuthMethods</code><br/><i>array[<a href="#SCMAuthMethod_v1alpha2_tf.isaaguilar.com">SCMAuthMethod</a>]</i></td><td> SCMAuthMethods define multiple SCMs that require tokens/keys </td></tr>
<tr><td><code class="field">serviceAccount</code><br/><i>string</i></td><td> ServiceAccount use a specific kubernetes ServiceAccount for running the create + destroy pods. If not specified we create a new ServiceAccount per Terraform </td></tr>
<tr><td><code class="field">setup</code><br/><i><a href="#Setup_v1alpha2_tf.isaaguilar.com">Setup</a></i></td><td> Setup is configuration generally used once in the setup task </td></tr>
<tr><td><code class="field">sshTunnel</code><br/><i><a href="#ProxyOpts_v1alpha2_tf.isaaguilar.com">ProxyOpts</a></i></td><td> SSHTunnel can be defined for pulling from scm sources that cannot be accessed by the network the operator/runner runs in. An example is enterprise-Github servers running on a private network. </td></tr>
<tr><td><code class="field">taskOptions</code><br/><i>array[<a href="#TaskOption_v1alpha2_tf.isaaguilar.com">TaskOption</a>]</i></td><td> TaskOptions are a list of configuration options to be injected into task pods. </td></tr>
<tr><td><code class="field">terraformModule</code><br/><i><a href="#Module_v1alpha2_tf.isaaguilar.com">Module</a></i></td><td> TerraformModule is used to configure the source of the terraform module. </td></tr>
<tr><td><code class="field">terraformVersion</code><br/><i>string</i></td><td> TerraformVersion is the version of terraform which is used to run the module. The terraform version is used as the tag of the terraform image  regardless if images.terraform.image is defined with a tag. In that case, the tag is stripped and replace with this value. </td></tr>
<tr><td><code class="field">writeOutputsToStatus</code><br/><i>boolean</i></td><td> WriteOutputsToStatus will add the outputs from the module to the status of the Terraform CustomResource. </td></tr>
</table>



<h2 id="TerraformStatus_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#TerraformStatus_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  TerraformStatus v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">lastCompletedGeneration</code><br/><i>integer</i></td><td>  </td></tr>
<tr><td><code class="field">outputs</code><br/><i>object</i></td><td>  </td></tr>
<tr><td><code class="field">phase</code><br/><i>string</i></td><td>  </td></tr>
<tr><td><code class="field">plugins</code><br/><i>array[string]</i></td><td> Plugins is a list of plugins that have been executed by the controller. Will get refreshed each generation. </td></tr>
<tr><td><code class="field">podNamePrefix</code><br/><i>string</i></td><td> PodNamePrefix is used to identify this installation of the resource. For very long resource names, like those greater than 220 characters, the prefix ensures resource uniqueness for runners and other resources used by the runner. Another case for the pod name prefix is when rapidly deleteing a resource and recreating it, the chance of recycling existing resources is reduced to virtually nil. </td></tr>
<tr><td><code class="field">stage</code><br/><i><a href="#Stage_v1alpha2_tf.isaaguilar.com">Stage</a></i></td><td>  </td></tr>
<tr><td><code class="field">stages</code><br/><i>array[<a href="#Stage_v1alpha2_tf.isaaguilar.com">Stage</a>]</i></td><td>  </td></tr>
</table>



<h2 id="Credentials_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Credentials_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Credentials v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">aws</code><br/><i><a href="#AWSCredentials_v1alpha2_tf.isaaguilar.com">AWSCredentials</a></i></td><td> AWSCredentials contains the different methods to load AWS credentials for the Terraform AWS Provider. If using AWS_ACCESS_KEY_ID and/or environment variables for credentials, use fromEnvs. </td></tr>
<tr><td><code class="field">secretNameRef</code><br/><i><a href="#SecretNameRef_v1alpha2_tf.isaaguilar.com">SecretNameRef</a></i></td><td> SecretNameRef will load environment variables into the terraform runner from a kubernetes secret </td></tr>
<tr><td><code class="field">serviceAccountAnnotations</code><br/><i>object</i></td><td> ServiceAccountAnnotations allows the service account to be annotated with cloud IAM roles such as Workload Identity on GCP </td></tr>
</table>



<h2 id="Images_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Images_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Images v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">script</code><br/><i><a href="#ImageConfig_v1alpha2_tf.isaaguilar.com">ImageConfig</a></i></td><td> Script task type container image definition </td></tr>
<tr><td><code class="field">setup</code><br/><i><a href="#ImageConfig_v1alpha2_tf.isaaguilar.com">ImageConfig</a></i></td><td> Setup task type container image definition </td></tr>
<tr><td><code class="field">terraform</code><br/><i><a href="#ImageConfig_v1alpha2_tf.isaaguilar.com">ImageConfig</a></i></td><td> Terraform task type container image definition </td></tr>
</table>



<h2 id="Module_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Module_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Module v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">configMapSeclector</code><br/><i><a href="#ConfigMapSelector_v1alpha2_tf.isaaguilar.com">ConfigMapSelector</a></i></td><td> ConfigMapSelector is an option that points to an existing configmap on the executing cluster. The configmap is expected to contains has the terraform module (ie keys ending with .tf). The configmap would need to live in the same namespace as the tfo resource.

The configmap is mounted as a volume and put into the TFO_MAIN_MODULE path by the setup task.

If a key is defined, the value is used as the module else the entirety of the data objects will be loaded as files. </td></tr>
<tr><td><code class="field">inline</code><br/><i>string</i></td><td> Inline used to define an entire terraform module inline and then mounted in the TFO_MAIN_MODULE path. </td></tr>
<tr><td><code class="field">source</code><br/><i>string</i></td><td> Source accepts a subset of the terraform "Module Source" ways of defining a module. Terraform Operator prefers modules that are defined in a git repo as opposed to other scm types. Refer to https://www.terraform.io/language/modules/sources#module-sources for more details. </td></tr>
<tr><td><code class="field">version</code><br/><i>string</i></td><td> Version to select from a terraform registry. For version to be used, source must be defined. Refer to https://www.terraform.io/language/modules/sources#module-sources for more details </td></tr>
</table>



<h2 id="Plugin_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Plugin_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Plugin v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">image</code><br/><i>string</i></td><td> The container image from the registry; tags must be omitted </td></tr>
<tr><td><code class="field">imagePullPolicy</code><br/><i>string</i></td><td> Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images </td></tr>
<tr><td><code class="field">task</code><br/><i>string</i></td><td> Task is the second part of a two-part selector of when the plugin gets run in the workflow. This should correspond to one of the tfo task names. </td></tr>
<tr><td><code class="field">when</code><br/><i>string</i></td><td> When is a keyword of a two-part selector of when the plugin gets run in the workflow. The value must be one of

- <code>At</code> to run at the same time as the defined task

- <code>After</code> to run after the defined task has completed. </td></tr>
</table>



<h2 id="ProxyOpts_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#ProxyOpts_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  ProxyOpts v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">host</code><br/><i>string</i></td><td>  </td></tr>
<tr><td><code class="field">sshKeySecretRef</code><br/><i><a href="#SSHKeySecretRef_v1alpha2_tf.isaaguilar.com">SSHKeySecretRef</a></i></td><td>  </td></tr>
<tr><td><code class="field">user</code><br/><i>string</i></td><td>  </td></tr>
</table>



<h2 id="SCMAuthMethod_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#SCMAuthMethod_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  SCMAuthMethod v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">git</code><br/><i><a href="#GitSCM_v1alpha2_tf.isaaguilar.com">GitSCM</a></i></td><td> Git configuration options for auth methods of git </td></tr>
<tr><td><code class="field">host</code><br/><i>string</i></td><td>  </td></tr>
</table>



<h2 id="Setup_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Setup_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Setup v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">cleanupDisk</code><br/><i>boolean</i></td><td> CleanupDisk will clear out previous terraform run data from the persistent volume. </td></tr>
<tr><td><code class="field">resourceDownloads</code><br/><i>array[<a href="#ResourceDownload_v1alpha2_tf.isaaguilar.com">ResourceDownload</a>]</i></td><td> ResourceDownloads defines other files to download into the module directory that can be used by the terraform workflow runners. The `tfvar` type will also be fetched by the `exportRepo` option (if defined) to aggregate the set of tfvars to save to an scm system. </td></tr>
</table>



<h2 id="TaskOption_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#TaskOption_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  TaskOption v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">annotations</code><br/><i>object</i></td><td> Annotaitons extra annotaitons to add the task pods </td></tr>
<tr><td><code class="field">env</code><br/><i>array[<a href="https://pkg.go.dev/k8s.io/api/core/v1#EnvVar">k8s.io/api/core/v1.EnvVar</a>]</i></td><td> List of environment variables to set in the task pods. </td></tr>
<tr><td><code class="field">envFrom</code><br/><i>array[<a href="https://pkg.go.dev/k8s.io/api/core/v1#EnvFromSource">k8s.io/api/core/v1.EnvFromSource</a>]</i></td><td> List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated. </td></tr>
<tr><td><code class="field">for</code><br/><i>array[string]</i></td><td> For is a list of tasks these options will get applied to. </td></tr>
<tr><td><code class="field">labels</code><br/><i>object</i></td><td> Labels extra labels to add task pods. </td></tr>
<tr><td><code class="field">policyRules</code><br/><i>array[<a href="https://pkg.go.dev/k8s.io/api/rbac/v1#PolicyRule">k8s.io/api/rbac/v1.PolicyRule</a>]</i></td><td> RunnerRules are RBAC rules that will be added to all runner pods. </td></tr>
<tr><td><code class="field">resources</code><br/><i><a href="https://pkg.go.dev/k8s.io/api/core/v1#ResourceRequirements">k8s.io/api/core/v1.ResourceRequirements</a></i></td><td> Compute Resources required by the task pods. </td></tr>
<tr><td><code class="field">restartPolicy</code><br/><i>string</i></td><td> RestartPolicy describes how the task should be restarted. Only one of the following restart policies may be specified.

```go
  const (
    RestartPolicyAlways    RestartPolicy = "Always"
    RestartPolicyOnFailure RestartPolicy = "OnFailure"
    RestartPolicyNever     RestartPolicy = "Never"
  )
```

If no policy is specified, the restart policy is set to "Never". </td></tr>
<tr><td><code class="field">script</code><br/><i><a href="#StageScript_v1alpha2_tf.isaaguilar.com">StageScript</a></i></td><td> Script is used to configure the source of the task's executable script. </td></tr>
</table>



<h2 id="Stage_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#Stage_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  Stage v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">generation</code><br/><i>integer</i></td><td> Generation is the generation of the resource when the task got started. </td></tr>
<tr><td><code class="field">interruptible</code><br/><i>boolean</i></td><td> Interruptible is set to false when the pod should not be terminated such as when doing a terraform apply. </td></tr>
<tr><td><code class="field">message</code><br/><i>string</i></td><td> Message stores the last message displayed in the logs. It is stored and checked by the controller to reduce the noise in the logs by only displying the message once. </td></tr>
<tr><td><code class="field">podName</code><br/><i>string</i></td><td> PodName is the pod assigned to execute the stage. </td></tr>
<tr><td><code class="field">podType</code><br/><i>string</i></td><td> TaskType is which task is currently running. </td></tr>
<tr><td><code class="field">podUID</code><br/><i>string</i></td><td> PodUID is the pod uid of the pod assigned to execute the stage. </td></tr>
<tr><td><code class="field">reason</code><br/><i>string</i></td><td> Reason is a message of what is happening with the pod. The controller uses this field when certain reasons occur to make scheduling decisions. </td></tr>
<tr><td><code class="field">startTime</code><br/><i><a href="https://pkg.go.dev/k8s.io/apimachinery/pkg/apis/meta/v1#Time">k8s.io/apimachinery/pkg/apis/meta/v1.Time</a></i></td><td> StartTime is when the task got created by the controller, not when a pod got started. </td></tr>
<tr><td><code class="field">state</code><br/><i>string</i></td><td> State is the phase of the task pod. </td></tr>
<tr><td><code class="field">stopTime</code><br/><i><a href="https://pkg.go.dev/k8s.io/apimachinery/pkg/apis/meta/v1#Time">k8s.io/apimachinery/pkg/apis/meta/v1.Time</a></i></td><td> StopTime is when the task went into a stopped phase. </td></tr>
</table>



<h2 id="AWSCredentials_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#AWSCredentials_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  AWSCredentials v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">irsa</code><br/><i>string</i></td><td> IRSA requires the irsa role-arn as the string input. This will create a serice account named tf-<resource-name>. In order for the pod to be able to use this role, the "Trusted Entity" of the IAM role must allow this serice account name and namespace.

Using a TrustEntity policy that includes "StringEquals" setting it as the serivce account name is the most secure way to use IRSA.

However, for a reusable policy consider "StringLike" with a few wildcards to make the irsa role usable by pods created by terraform-operator. The example below is pretty liberal, but will work for any pod created by the terraform-operator.

```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${OIDC_ARN}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            "${OIDC_URL}:sub": "system:serviceaccount:*:tf-*"
          }
        }
      }
    ]
  }
```

<note>This option is just a specialized version of Credentials.ServiceAccountAnnotations and will be a candidate of removal in the future.</note> </td></tr>
<tr><td><code class="field">kiam</code><br/><i>string</i></td><td> KIAM requires the kiam role-name as the string input. This will add the correct annotation to the terraform execution pod

<note>This option is just a specialized version of Credentials.ServiceAccountAnnotations and will be a candidate of removal in the future.</note> </td></tr>
</table>



<h2 id="SecretNameRef_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#SecretNameRef_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  SecretNameRef v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">key</code><br/><i>string</i></td><td> Key of the secret </td></tr>
<tr><td><code class="field">name</code><br/><i>string</i></td><td> Name of the secret </td></tr>
<tr><td><code class="field">namespace</code><br/><i>string</i></td><td> Namespace of the secret; Defaults to namespace of the tf resource </td></tr>
</table>



<h2 id="ImageConfig_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#ImageConfig_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  ImageConfig v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">image</code><br/><i>string</i></td><td> The container image from the registry; tags must be omitted </td></tr>
<tr><td><code class="field">imagePullPolicy</code><br/><i>string</i></td><td> Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images </td></tr>
</table>



<h2 id="ConfigMapSelector_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#ConfigMapSelector_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  ConfigMapSelector v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">key</code><br/><i>string</i></td><td>  </td></tr>
<tr><td><code class="field">name</code><br/><i>string</i></td><td>  </td></tr>
</table>



<h2 id="SSHKeySecretRef_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#SSHKeySecretRef_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  SSHKeySecretRef v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">key</code><br/><i>string</i></td><td> Key in the secret ref. Default to `id_rsa` </td></tr>
<tr><td><code class="field">name</code><br/><i>string</i></td><td> Name the secret name that has the SSH key </td></tr>
<tr><td><code class="field">namespace</code><br/><i>string</i></td><td> Namespace of the secret; Default is the namespace of the terraform resource </td></tr>
</table>



<h2 id="GitSCM_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#GitSCM_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  GitSCM v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">https</code><br/><i><a href="#GitHTTPS_v1alpha2_tf.isaaguilar.com">GitHTTPS</a></i></td><td>  </td></tr>
<tr><td><code class="field">ssh</code><br/><i><a href="#GitSSH_v1alpha2_tf.isaaguilar.com">GitSSH</a></i></td><td>  </td></tr>
</table>



<h2 id="ResourceDownload_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#ResourceDownload_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  ResourceDownload v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">address</code><br/><i>string</i></td><td> Address defines the source address resources to fetch. </td></tr>
<tr><td><code class="field">path</code><br/><i>string</i></td><td> Path will download the resources into this path which is relative to the main module directory. </td></tr>
<tr><td><code class="field">useAsVar</code><br/><i>boolean</i></td><td> UseAsVar will add the file as a tfvar via the -var-file flag of the terraform plan command. The downloaded resource must not be a directory. </td></tr>
</table>



<h2 id="StageScript_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#StageScript_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  StageScript v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">configMapSelector</code><br/><i><a href="#ConfigMapSelector_v1alpha2_tf.isaaguilar.com">ConfigMapSelector</a></i></td><td> ConfigMapSelector reads a in a script from a configmap name+key </td></tr>
<tr><td><code class="field">inline</code><br/><i>string</i></td><td> Inline is used to write the entire task execution script in the tfo resource. </td></tr>
<tr><td><code class="field">source</code><br/><i>string</i></td><td> Source is an http source that the task container will fetch and then execute. </td></tr>
</table>



<h2 id="GitHTTPS_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#GitHTTPS_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  GitHTTPS v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">requireProxy</code><br/><i>boolean</i></td><td>  </td></tr>
<tr><td><code class="field">tokenSecretRef</code><br/><i><a href="#TokenSecretRef_v1alpha2_tf.isaaguilar.com">TokenSecretRef</a></i></td><td>  </td></tr>
</table>



<h2 id="GitSSH_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#GitSSH_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  GitSSH v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">requireProxy</code><br/><i>boolean</i></td><td>  </td></tr>
<tr><td><code class="field">sshKeySecretRef</code><br/><i><a href="#SSHKeySecretRef_v1alpha2_tf.isaaguilar.com">SSHKeySecretRef</a></i></td><td>  </td></tr>
</table>



<h2 id="TokenSecretRef_v1alpha2_tf.isaaguilar.com">
  <a class="hash-link" data-scroll href="#TokenSecretRef_v1alpha2_tf.isaaguilar.com">
    <span class="screen-reader-text">Copy</span>
  </a>
  TokenSecretRef v1alpha2 tf.isaaguilar.com
</h2>


<table class="apitable">
<tr><th>Field</th><th>Description</th></tr>
<tr><td><code class="field">key</code><br/><i>string</i></td><td> Key in the secret ref. Default to `token` </td></tr>
<tr><td><code class="field">name</code><br/><i>string</i></td><td> Name the secret name that has the token or password </td></tr>
<tr><td><code class="field">namespace</code><br/><i>string</i></td><td> Namespace of the secret; Default is the namespace of the terraform resource </td></tr>
</table>

