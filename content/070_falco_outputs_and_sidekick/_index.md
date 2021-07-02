---
title: "5. Falcosidekick"
weight: 070
chapter: true
---

# Falco Output & Response Engine with Falcosidekick
![Home Security](/images/falcosidekick_color.png)


You have learned that Falco can detect and alert about a wide variety of events in your infrastructure: single hosts on EC2, k8s clusters on EKS and even Fargate! But **how can you use this information out of the single host or cluster where it is captured?**

Falcosidekick can help you in two ways:

1. In this module you'll be using Falcosidekick to export the alerts coming from Falco to one of the supported platforms, where this information can be useful for you and your team. In particular, you'll be using its **Dashboard WebUI** to observe the events coming from Falco.


2. A **Response Engine** is the tooling responsible to apply a particular measure to security events in order to mitigate the security threat. Wouldn't it be great to define a particular response to a security thread detected by Falco? Falcosidekick provides a way to respond to different Falco alerts, in conjuction with other tools. In this module you'll learn how to configure Falco + Falcosidekick + Kubeless to respond to the custom rule that you created (shell in container) and kill the pod where the event happened.
<!-- For this workshop it would be great to have it integrated with AWS Landa!!! -->



## Falco default Outputs

![Falco Extended Architecture](../images/flaco_extended_arch.png)

By default, Falco has 5 outputs for its events: 

- System Logs
- File 
- stdout 
- Shell 
- webHook (http) 
- gRPC

You have already tested some of them during all this practice. As you get to the end of the workshop, it is important to understand how can you integrate/export Falco's output with other components. `Falcosidekick` extends the available outputs to (this is not a complete list, review the [full list](https://github.com/falcosecurity/falcosidekick) for an updated version): 

- Slack
- Microsoft Teams
- OpenFasS
- Kubeless
- AWS S3
- Prometheus
- a Webhook
- its own WebUI
- and many others! 

And the best part of it is that this list is growing! In particular, these are the AWS Resources with which Falcosidekick integrates:

- AWS Landa
- AWS SQS
- AWS SNS
- AWS CloudWatchLogs
- AWS S3

In the next step you'll review Falco events from your EKS cluster on a Dashboard panel.