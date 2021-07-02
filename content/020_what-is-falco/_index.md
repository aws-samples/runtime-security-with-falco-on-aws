---
title: "1. What is Falco"
weight: 020
chapter: true
---


## What is Falco?

The Falco Project is an open-source runtime security tool originally built by [Sysdig, Inc](https://sysdig.com), and donated to the CNCF. Currently, it is a [CNCF incubating project](https://www.cncf.io/blog/2020/01/08/toc-votes-to-move-falco-into-cncf-incubator/).

Falco uses system calls to secure and monitor a system, by:

 - Parsing the Linux system calls from the kernel at runtime
 - Asserting the stream against a powerful rules engine
 - Alerting when a rule is violated

From a high-level perspective, you can find two main components: 

- Falco Rules
- Falco Alerts

A **rule** is a definition against which the stream of events from the kernel is observed. It defines which conditions an event has to meet to trigger the alert. An **alert** is the output of a rule. Whenever one rule is triggered, Falco notifies you about it using channels defined by you. 

## Falco Rules

Falco ships with a default set of rules that check the *kernel* for unusual behaviour such as:

 - Privilege escalation using privileged containers
 - Namespace changes using tools like *setns*
 - Read/Writes to well-known directories such as */etc*, */usr/bin*, */usr/sbin*, etc
 - Creating symlinks
 - Ownership and Mode changes
 - Unexpected network connections or socket mutations
 - Spawned processes using *execve*
 - Executing shells such as *sh*, *bash*, *csh*, *zsh*, etc
 - Executing SSH binaries such as *ssh*, *scp*, *sftp*, etc
 - Mutating Linux *coreutils* executables
 - Mutating login binaries
 - Mutating *shadowutil* or *passwd* executables such as *shadowconfig*, *pwck*, *chpasswd*, *getpasswd*, *change*, *useradd*, *etc*, and others.

You can also find a great repository with security best practices and configurations for Falco, supported by the community in [SecurityHub.dev](www.securityhub.dev).

<!-- ## What are Falco alerts? -->

## Falco Alerts

Alerts are configurable downstream actions that can be as simple as logging to *STDOUT* or as complex as delivering a gRPC call to a client. Falco can send alerts to different **channels**:

- Standard Output
- A file
- Syslog
- A spawned program
- An HTTP[s] end-point
- A client through the gRPC API

For example, in the next step, you'll be configuring Falco to log all the alerts to a file.