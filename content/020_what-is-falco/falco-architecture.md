---
title: "Falco Architecture"
weight: 021
chapter: false
---

<!-- https://falco.org/docs/getting-started/
https://docs.google.com/presentation/d/12f8rUg3mtZBu2h3cq71CSrvImE7fyChHGMsOHvRZzcY/edit#slide=id.g4d0cd7c627_0_489

https://docs.google.com/presentation/d/12f8rUg3mtZBu2h3cq71CSrvImE7fyChHGMsOHvRZzcY/edit#slide=id.g4d0cd7c627_0_509 -->


Falco can detect and alert on any behavior that involves making Linux system calls. Falco alerts are triggered based on specific system calls, arguments, and properties of the calling process. Falco operates at the user space and kernel space, and the system calls are interpreted by the Falco kernel module. The syscalls are then analyzed using the libraries in the userspace, and the events are then filtered using a Falco rules engine. Suspicious events are alerted to outputs, such as Syslog, files, Standard Output, and others.

![Falco Architecture](../images/falco_architecture.png)

<!-- Source - https://docs.google.com/presentation/d/1WX2PdjC9wqYyrFNmHmInahH6KtfOE2_ooOp6hq68-04/edit#slide=id.g74a76850e6_0_194 -->

On a linux node, Falco reads all Kernel level system calls. Since all containers in all pods running on particular host use a shared kernel, then all activity accross all containers can be monitored from this one location

![Falco Architecture](../images/falco_architecture2.png)

Similarily, since all Kublet traffic on a Kubernetes cluster is handled on the master, all Kublet activity can be monitored by Falco running the Master node.

![Falco Architecture](../images/falco_architecture1.png)

Before we explain more about the Falco concepts and syntax, lets get it installed on our workstation.

<!-- ## What are the Components of Falco?

**DEVEL NOTE - IS THIS TMI????**

Falco is composed of three main components:

 - Userspace program - is the CLI tool `falco` that you can use to interact with Falco. The userspace program handles signals, parses information from a Falco driver, and sends alerts.

 - Configuration - defines how Falco is run, what rules to assert, and how to perform alerts. For more information, see [Configuration](configuration).

 - Driver - is a software that adheres to the Falco driver specification and sends a stream of system call information. You cannot run Falco without installing a driver.
Currently, Falco supports the following drivers:

    - (Default) Kernel module built on `libscap` and `libsinsp` C++ libraries
    - BPF probe built from the same modules
    - Userspace instrumentation

    For more information, see [Falco Drivers](https://falco.org/docs/event-sources/drivers/). -->
