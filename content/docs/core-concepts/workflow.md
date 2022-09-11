---
title: Workflow
weight: 2
seo:
  title: Workflow
  description: This is the workflow page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Workflow
      keyName: property
    - name: 'og:description'
      value: This is the workflow page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Workflow
    - name: 'twitter:description'
      value: This is the workflow page
layout: docs
---

Terraform Operator, when boiled down to it's core, is a workflow runner. The
Controller takes a config and orchestrates pods to execute in a workflow. Take
a look at this diagram to see the basic workflow:

<p align="center"><a href="https://s3.amazonaws.com/classic.isaaguilar.com/tfo-workflow-diagramv2.png" border="0">
<img src="https://s3.amazonaws.com/classic.isaaguilar.com/tfo-workflow-diagramv2.png" alt="Terraform Operator Workflow Diagram"></img>
</a></p>