---
title: "Events Dashboard"
weight: 071
chapter: true
---

# Output: Falcosidekick UI

When you deployed Falco on your cluster, you already included all the required options to deploy Falcosidekick and its web Dashboard. It displays events from Falco and a detailed view per event with all its metadata.

<!-- This is how we exposed the service before Jonah proposed to use a C9 built-in feature, used below
To access it, you just need to expose the service with a **k8s LoadBalancer**:

```bash
kubectl expose deployment falco-falcosidekick-ui --type=LoadBalancer --name=falcosidekick-service -n falco
kubectl get service/falcosidekick-service -n falco
 
```

Copy the **EXTERNAL-IP** value and append to its end the Dashboard's port and path (_**:2802/ui**_). You'll get something similar to:

```url
http://<your_exposed_domain_here>-<random_nums>.us-east-1.elb.amazonaws.com:2802/ui/
```

Use this URL to access the Falcosidekick-ui Dashboard from your browser.  -->

To access it, you are going to use one built-in function from AWS Cloud9. There's no need to create a LoadBalancer service for your Deployment. To do so, just execute:

```
kubectl port-forward svc/falcosidekick-ui 2802:2802
```

Then, go to `Tools` > `Preview` > `Preview Running Application`. It will open a new tab on the forwarded port with Falcosidekick Dashboard.


## Dashboard

From here, you are presented with a summary of the events in your cluster. Remember that falcosidekick can work as a gateway for other Falco instances, showing in one dashboard the data comming from different nodes. In this case, you are just getting all the information coming from your EKS cluster. You can filter by rule, priority or time scope.

<!-- general dashboard screenshot -->

![Dashboard](/images/sidekickUI.png)


## Event detail

Let's trigger again the `Launch Privileged Container` rule. In the `Timeline` chart you can observe the new events coming into your Dashboard (reload if this is not the case!). Select the last available event or just any of the available rules to observe all the fields and its values for this event!

<!-- event detail screenshot -->
![Event Detail](/images/sidekickUIdetail.png)

--- 

In the next step you'll learn how to use falcosidekick as a Response Engine for your cluster. This means that you'll be able to automatically respond to security threads based on Falco detections!
