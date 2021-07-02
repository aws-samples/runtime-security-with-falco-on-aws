---
title: "Check EKS Cluster status"
weight: 052
chapter: false
---

<!-- See https://eksctl.io/  -->

The EKS cluster creation might take up to 20 minutes to complete. If you created it at the begining of the workshop in the prerequisites section ([EKS deployment]({{< ref "010_prerequisites/18_configure_workstation/26_eks" >}})), the [cluster's status](https://us-west-1.console.aws.amazon.com/ecs/home?region=us-west-1#/clusters) should be **ACTIVE** by now and the worker nodes should have been deployed. Switch to the first Terminal you created and check the last output available in stdout. You'll know that it is ready when you see something like this:

```log
2021-06-02 09:30:35 [✔]  EKS cluster "falco-workshop-<your_id>" in "us-east-1" region is ready
```

#### Test the cluster

Once completed, you can check the EKS cluster and nodes are available as follows:

  ```bash
  kubectl get nodes # if we see our 3 nodes, we know we have authenticated correctly
  aws eks --region $AWS_REGION describe-cluster --name $CLUSTERNAME --query cluster.status
  eksctl get nodegroup --cluster $CLUSTERNAME
   
  ```

You should see three nodes, *"ACTIVE"* and a description of the nodegroup: 

```log
NAME                             STATUS   ROLES    AGE     VERSION
ip-192-168-12-239.ec2.internal   Ready    <none>   5h10m   v1.18.9-eks-d1db3c
ip-192-168-57-151.ec2.internal   Ready    <none>   5h10m   v1.18.9-eks-d1db3c
ip-192-168-94-158.ec2.internal   Ready    <none>   5h10m   v1.18.9-eks-d1db3c

"ACTIVE"

2021-06-02 14:40:15 [ℹ]  eksctl version 0.52.0
2021-06-02 14:40:15 [ℹ]  using region us-east-1
CLUSTER                 NODEGROUP       STATUS  CREATED                 MIN SIZE        MAX SIZE      DESIRED CAPACITY INSTANCE TYPE   IMAGE ID        ASG NAME
falco-workshop-<your_id>     nodegroup       ACTIVE  2021-06-02T09:27:26Z    3               3             3t3.small        AL2_x86_64      eks-20bce606-448b-8a1b-9631-a679ff0df72c
```

You now have a fully working *Amazon EKS Cluster* that is ready to use!