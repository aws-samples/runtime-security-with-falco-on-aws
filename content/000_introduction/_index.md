+++
title = "Introduction"
chapter = true
weight = 001
+++

# Workshop Overview

![Home Security](/images/00_introduction/homesec.jpg)

## Home Security

<!-- **DEVEL NOTE: Shorten this.**
https://docs.google.com/presentation/d/12f8rUg3mtZBu2h3cq71CSrvImE7fyChHGMsOHvRZzcY/edit#slide=id.g4f34a36f9c_0_48
**DEVEL NOTE: John included this slides, not sure if we want to include them. All the required information is available in Hugo and the formatting of the slides is sysdig (and outdated)** -->

Many people will secure their property to **prevent** or **deter intrusion** using means such as:

 - Door locks
 - Window locks
 - Bars on ground floor windows
 - Exterior cameras

However, no matter how secure a property is, with sufficient force that security may be breached. If this happens, then you need a means of **intrusion detection**, e.g.:

 - Internal motion sensors
 - Window sensors
 - Interior cameras

You may also take some **actions** or **alerts**, e.g. send a message to your email, activate an audible alarm, or alert the police. Police may visit the scene after the event to gather some **forensics** and attempt to determine the extent of the breach, and help track down the culprit. But don't worry, you won't be learning about Home Security: this is just an analogy to introduce the different approaches to security that you can implement today to protect your workloads.


## Securing your workloads

In a similar way, you can proactively secure your applications and infrastructure to **prevent intrusion** with:

 - Passwords
 - Two-Factor Authentication
 - Container Image Scanning
 - Admission Controllers
 - Network Policy

But, if this security layer is breached, then you can **detect intrusion** with tools such as:

 - Kubernetes Audit Logging
 - System Call Instrumentation

You may also want to alert the intrusion somehow, for example, send an alert to Slack or an email, and you may want to do some forensics to see what damage was done, if a bot was installed, or private information accessed. You might also want to automatically trigger specified actions based on the intrusion detected (Response Engine) like, for example, killing a Pod running on EKS if the container is running in privileged mode.

## Enter Falco!

**Falco** is a runtime security tool that allows you to monitor kernel system calls and Kubernetes audit log commands to detect risky and malicious behaviour. It comes with a complete set of detection rules created and curated by Falco’s developers that cover many use-cases to help you strengthen your infrastructure security posture.
You can find more information about Falco at the [Falco website](https://falco.org/), [GitHub repo](https://github.com/falcosecurity/falco), and follow on Twitter ([@falco_org](https://twitter.com/falco_org)).

