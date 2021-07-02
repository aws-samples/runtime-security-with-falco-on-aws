---
title: "Main Page"
chapter: true
weight: 1
---

![Falco](/images/falco.jpg)


# Runtime Security with Falco in AWS  


## Welcome

Welcome to the **Falco Workshop on AWS** hands-on workshop. Falco, the cloud-native runtime security project, is the *de facto* Kubernetes threat detection engine. It is currently run independently by the Falco community and under the umbrella of the CNCF since 2018.


This workshop is provided by Sysdig. Sysdig has a large history contributing to the OSS community: 

- [sysdig](https://github.com/draios/sysdig) (the Linux kernel tracing tool)
- [Sysdig Inspect](https://github.com/draios/sysdig-inspect), 
- Falco, 
- [eBPF](https://sysdig.com/blog/sysdig-contributes-falco-kernel-ebpf-cncf/) 
- and it is also a Prometheus contributor. 

We do love  open source! This workshop is part of this commitment and we hope you enjoy it. If you want to know more about Security and Monitoring for Cloud, please check out our [blog](https://sysdig.com/blog/) and stay tuned to the last news. 

![Sysdig](/images/logo.png)

Here you can find a list of topics you will learn about during this workshop:

<!-- {{% children showhidden="false" %}} -->


## About this Workshop

Expected Duration:

 * 2-3 Hours

### Learning Objectives

The main goal of this workshop is to familiarize you with the installation, configuration, and usage of Falco in AWS resources. There’s a lot of content available about Falco installation, configuration, and use-cases, but none specifically targets workloads running in AWS resources.


### Who should take this workshop?

Have you ever wondered what happens when a security control fails for your workloads and infrastructure? Falco is the last line of defence. Hopefully, you will never really get to need it, but it will be critical when you need it. These are some of the problems that Falco solves:

- Are my hosts and containers doing something they shouldn't?
- Spawned processes: Did my PostgreSQL container spawn an unexpected process?
- File system reads/writes: Did someone install a new package or change configuration in a running container?
- Network activity: Did my Nginx container open a new listening port or an unexpected outgoing connection?
- User or orchestration activity: Did any K8s user spawn a shell into a privileged container?
- I need to meet compliance standards: PCI, FIM, NIST, etc. Where can I start?

This is not an exhaustive list, but if you are in one of the next positions, you might be interested in this workshop:
<!-- TODO probably some of those are overlaped, reduce! -->

 - Infrastructure Engineers
 - DevOps Engineers
 - Cloud Architects
 - Security Architects
 - SysAdmins
 - Software Developers
 - Solutions Architects 
 - Site Reliability Engineers (SREs)
 - Technical leads


### Prerequisites

 Some experience/knowledge with AWS is helpful, but the workshop will provide instructions to run through it with no issues. No experience with Falco is required. Some knowledge about the Linux operative system is desirable.
 

### Feedback

Please, share any question or feedback about the content in this workshop. If you are attending one of our live workshop sessions, you'll find live support. In any other case, you can get in touch with [training-team@sysdig.com](mailto:training-team@sysdig.com).
