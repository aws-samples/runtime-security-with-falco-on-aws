---
title: "Cleanup"
weight: 073
chapter: true
---


## Cleanup

You can remove the cluster now. If you are running this in your own AWS account, you might want to remove all resources created:

```
helm uninstall falco -n falco
# just if we are not using the EKS Cluster for the falcosidekick module!
eksctl delete cluster --name $CLUSTERNAME
```