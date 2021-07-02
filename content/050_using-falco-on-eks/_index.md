---
title: "4. Using Falco on EKS"
weight: 050
chapter: true
---

![EKS](/images/50_module_3/amazon-eks-icon.png)

## Using Falco on k8s

Falco can also work as a [Kubernetes threat detection](https://falco.org/docs/event-sources/kubernetes-audit/) engine. The community maintains a set of [rules](https://github.com/falcosecurity/falco/blob/master/rules/k8s_audit_rules.yaml) directly targetting at critical events from the Audit Events logs of your Kubernetes cluster. 

For example, here you can find some of the available rules:

- Detect any new [pod created](https://github.com/falcosecurity/falco/blob/0f36ff030e269008f99cd280a62d4dfbd58aadad/rules/k8s_audit_rules.yaml#L293) in the kube-system namespace
- Detect any k8s operation by a user name that may be an [administrator with full access](https://github.com/falcosecurity/falco/blob/0f36ff030e269008f99cd280a62d4dfbd58aadad/rules/k8s_audit_rules.yaml#L546).
- Or Create/Modify [Configmap With Private Credentials](https://github.com/falcosecurity/falco/blob/0f36ff030e269008f99cd280a62d4dfbd58aadad/rules/k8s_audit_rules.yaml#L185)

Note that the rules are updated on a regular basis and new ones might appear. 

## Using Falco on EKS

What happens when the k8s cluster is a managed k8s service like AWS EKS? *You have no direct access to the Audit logs, so there is no direct way to inspect the EKS Audit Logs with Falco!*

Luckily, there is an alternative: you can choose to forward the Audit Logs from [EKS to CloudWatch](https://docs.aws.amazon.com/eks/latest/userguide/logging-monitoring.html). This service provides access from CloudWatch to a record of actions taken by a user, role, or an AWS service in Amazon EKS. Once the logs are sent to CloudWatch, you can use [*ekscloudwatch*](https://github.com/sysdiglabs/ekscloudwatch) to read EKS Kubernetes audit logs and forward them to Falco.

---

In this Module you'll learn and practice configuring *ekscloudwatch* on EKS. A EKS cluster was deployed in the Prerequisites section of this workshop (please, take [this step]({{< ref "010_prerequisites/18_configure_workstation/26_eks" >}})) if you haven't done it yet). 


**Flow of the module:**


{{% children showhidden="false" %}}

 <!-- - Installing Falco in your cluster
 - Enabling Audit Logs in EKS cluster
 - Configuring and deploying *ekscloudwatch*
 - Triggering a security event
 - Observing the logs -->


 <!-- Optional:
 - trigger a rule for syscall violation and a rule for audit log
 - see output in sidekick ui (or we can have it out to some other amazon centric place) -->
