---
title: "3. How the rule was triggered"
weight: 030
chapter: true
---

## What happened in the previous step?

Well, Falco uses a set of rules to decide what kernel activity to report on. In this step you are going to take a closer look at these rules. You can find here the rule and the macro that detected the security event in the previous step. Check it out, but don't worry about its syntax too much yet, you'll learn later the details!

### The rule

```yaml

- rule: Write below binary dir
  desc: an attempt to write to any file below a set of binary directories
  condition: >
    bin_dir and evt.dir = < and open_write
    and not package_mgmt_procs
    and not exe_running_docker_save
    and not python_running_get_pip
    and not python_running_ms_oms
    and not user_known_write_below_binary_dir_activities
  output: >
    File below a known binary directory opened for writing (user=%user.name user_loginuid=%user.loginuid
    command=%proc.cmdline file=%fd.name parent=%proc.pname pcmdline=%proc.pcmdline gparent=%proc.aname[2] container_id=%container.id image=%container.image.repository)
  priority: ERROR
  tags: [filesystem, mitre_persistence]

- macro: bin_dir
condition: fd.directory in (/bin, /sbin, /usr/bin, /usr/sbin)
```

### The explanation

*This rule it's triggered any time a file is written in one of the directories with binaries in the system. These directories are defined in the macro `bin_dir`.*

It was easy, right? This is one of the strengths of *Falco*: you do not really need to understand or tweak it a lot in order to secure the most common use-cases. Most nefarious activities are observed *out-of-the-box* with the set of default rules for single hosts or Kubernetes workloads. But of course, although it is not required, you can configure custom rules for your specific use cases! This will increase your detection scope and hereby grant greater levels of security.


## Summary and next steps

In this example, you practised how to enable runtime security for your AWS EC2 single host instances. But there is much more you can do:

- Customize rules to match your use-cases: you'll be learning how to build your first rule, macro, and list!
- Trigger alerts based on *Falco* security events
- Use containers (*Docker*) and orchestrators (*Kubernetes*) metadata to enrich your rules
- Secure your *AWS EKS* instances
- Secure your *CaaS* workloads in *AWS Fargate*
- Enable a response engine with *Falcosidekick* to take actions based on *Falco* detections (for example, killing pods running privileged containers)

Keep going to learn and practice all of them!