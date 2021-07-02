---
title: "3. Anatomy of Falco Rules"
weight: 040
chapter: true
---

# 3. Anatomy of Falco Rules

In this section you will learn about:

{{% children showhidden="false" %}}

Before you dive into the details of each of those, you need to know the structure of the *Falco* config files. You are familiar with some of them from the previous installation step.


## Falco config files

By default, rules are located under `/etc/falco/`.

```bash
$ tree /etc/falco/
/etc/falco/
├── falco_rules.local.yaml
├── falco_rules.yaml
├── falco.yaml
├── k8s_audit_rules.yaml
├── rules.available
│   └── application_rules.yaml
└── rules.d
2 directories, 5 files
```

The purpose of each of these files is:

 - **falco_rules.yaml**: Community updated Falco rules for general hosts and containers, overwritten on Falco upgrade.
 - **falco_rules.local.yaml**: Your own rules, preserved when upgrading Falco version, put your rules here.
 - **k8s_audit_rules.yaml**: Community updated Falco rules for Kubernetes audit, overwritten on Falco upgrade.
 - **falco.yaml**: General Falco configuration.
 - **rules.available/application_rules.yaml**: Move to rules.d to activate.
 - **rules.d/**: files in this directory will be processed as rules in alphabetical order.

The [Cloud Native Security Hub](https://securityhub.dev/) is a source for Community updated Falco rules for many applications and environments.


## Falco Rules Linting

You will touch on a number of these files as you progress through the workshop. So it is a good practice to know how to check its syntax:

```BASH
$ falco -L
Tue Jun  1 10:34:50 2021: Falco version 0.28.2 (driver version 13ec67ebd23417273275296813066e07cb85bc91)
Tue Jun  1 10:34:50 2021: Falco initialized with configuration file /etc/falco/falco.yaml
Tue Jun  1 10:34:50 2021: Loading rules from file /etc/falco/falco_rules.yaml:
Tue Jun  1 10:34:50 2021: Loading rules from file /etc/falco/falco_rules.local.yaml:
Tue Jun  1 10:34:50 2021: Loading rules from file /etc/falco/k8s_audit_rules.yaml:

Rule                                               Description
----                                               -----------
Outbound or Inbound Traffic not to Authorized Server Process and Port Detect traffic that is not to authorized server process and port.
(...)
```

Here you can see information in your current instance of Falco:

- Falco and driver versiones
- Configuration and rule files
- A list with all the rules defined and their descriptions.

If any syntax errors were made to any of your rule files, you'll be notified:

```log
Tue Jun  1 10:37:03 2021: Runtime error: Could not load rules file /etc/falco/falco_rules.yaml: 1 errors:
```

It is recommended to use the linter any time you edit any of the rule files during this workshop.


## Rules versioning

Rule files include a `required_engine_version: N` that specifies the minimum engine version required (if not included, no check is performed). This identifier is useful to know when a `falco_rules` definition file is compatible with your current version of *Falco*.
