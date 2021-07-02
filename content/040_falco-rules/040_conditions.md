---
title: "More about Conditions"
weight: 034
chapter: false
---

<!-- 
guys, this step should be the central part of this workshop
I do not know a lot about Falco but I can tell that being able to know which fields are available
and, from there, use them in conditions to create useful rules is the final step we want to achieve!

we need to think of some real examples and a procedure to analyce a particular app and define rules
based on its behaviour. I am open to suggestions here. Right now this is going to be the final version
before we release it, but I am open to resume this and improve this step.

Please share any feedback or ideas you might have! -> pablo.lopezzaldivar@sysdig.com
 -->
You may have already realized that the key part of a rule is its condition. It defines which events you target in your hosts and containers! And, inside of conditions, [`fields`](https://falco.org/docs/rules/supported-fields/) are the key element!

## A small bit of history

Let's take a little breack. Falco was created by Sysdig in 2016 and it shares the same foundation that defines the core functionality of its [open-source tool](https://github.com/draios/sysdig): capturing system calls and other OS events. From each syscall or event captured, a set of key identifiers is extracted. Some examples of available fields are here:

- CPU number where the event was captured
- User name executing the process
- Name of the process that generated the event
- Environment variables associated with the process
- Name and path when a file is readen/written
- Client/Server IPs for networking events (sockets are considered )
- Container ID
- and much more... you name it!

Each of these small nuances of a system call (or other sources as container runtime or orchestrator) allow building a profile of what is going on in your system. But Sysdig was designed as a universal system visibility tool, not for alerting. With Falco, you don't need to be there 24/7 monitoring what's going on. You can specify with great detail which events should light a warning red light.

A condition is simply a Boolean predicate on Sysdig events. Any Sysdig filter is a valid Falco condition (with certain exceptions) and they may also contain macros.

## Condition building blocks

### Field Classes

The following [Field Classes](https://falco.org/docs/rules/supported-fields/) are supported in Falco rules. Find here all the fields relative to System Calls:

  - `fd`: Fields for File Descriptors. Includes networking as well as file/directory fields.
  - `proc`: Fields for running or spawned processes.
  - `thread`: Same with threads.
  - `evt`: Fields for system call events. For example, use `evt.type` to specify the system call name.
  - `user`: Fields related to the user executing the event.
  - `group`: Fields related to the group of the user executing the event.
  - `syslog`: Fields related to messages sent to syslog. Allows rules to be created based on syslog messages.
  
  <!--
   - `span`: 
  - `evtin`:
  - `fdlist`:
   -->


And those extracted from containers, Kubernetes, Mesos, and JSON sources:

  - `container`: Fields related to container runtime metadata.
  - `k8s`: Same for Kubernetes.
  - `ka`: Used for K8s Audit Log Events.
  - `mesos`: Same for Mesosphere.
  - `jevt`: Use it to access json events. 

Each of these classes includes a myriad of different fields that you can use to build your own rules or extend the existing ones. Let's see which operators are available to build conditions with the existing fields.

As you can see, Falco can consume events from different sources, and apply rules to all of these events to detect abnormal behaviour. Currently, Falco supports the following event sources. You can list associated event fields for each of these as follows:

```bash
falco --list=syscall
falco --list=k8s_audit
```

### Operators

Here you can find a list of the operators available:

- `A contains B`: string A contains string B, case matter, returns bool.
- `A in B`: is element A in list B? Returns a bool. Also used to compare two lists.
- `A exists`: string A is defined and not empty, returns bool.
- `A icontains B`: string A contains string B, case insensitive, returns bool.
- `A startswith B`: string A starts with string B, returns bool.
- `A pmatch B`: A partial match any element in list B, returns bool.
- `A endswith B`: string A ends with string B, returns bool.
- `A intersects B`: elements of A that also are in B, returns list.
- `not A`: negation of bool value A.
- `glob`: glob patterns specify sets of values with wildcard characters.
- For numeric comparison: 
  - `a > b`: a greater than b.
  - `b < c`: b smaller than c.
  - `a >= c`: a greater or equal to c.
  - `c <= a`: c smaller or equal to c.
  - `a != b`: a different than b.
  - `a  = c`: a equals to c.


## Practice

Here are proposed some ideas to practice with the fields and operators explained above. *Taking this step is not required to have a basic user-level of Falco, as the default rules scope covers most use-cases. But, if you want to master Falco and be proficient creating rules, some practice here is required. And most importantly, practice with your own application is required. At the end it is not just Falco, but a combination of it and a deep knowledge of what your app should or shouldn't be doing!*

Some of these exercises might not fit real use cases, but are good practice. 

## With conditions

- Imagine that you want to modify your previous rule to be alerted just when the container image where the event is generated is different to the current one (e.g. to be alerted just when it changes). **How would you modify the condition so the rule alerts you just when the image changes (and the previous conditions are met?** *Tip: use the `container.image.id` field.*

- Finally, create a rule that alerts you whenever a container with the latest image tag is run. Which conditions do you need to specify? 

## With outputs
Fields are also used in the output of a rule. When creating new rules, it is recommended to include all related fields in the output to have more information available to tune the rule. This way you can avoid false positives. The custom rule we provided for the previous steps is a little bit sloppy (each action we execute triggers more than one alert). Are you able to discover which fields are responsible for this situation? 

{{% notice tip %}}
Although it is not part of this workshop, using sysdig oss might be a good way to debug this kind of behavior. With sysdig, you can create a capture file of all the system calls within a time range and later run different filters through it to retrieve all the information available with a particular event/incident.
{{% /notice %}}




<!-- and container.image.id != <current_id> -->
<!-- not time to develop this part, but some examples with real practice are required in order to make this a real workshop... -->

<!-- ## Other Best Practices

To allow for grouping rules by event type, which improves performance, Falco prefers rule conditions that have at least one `evt.type=` operator, at the beginning of the condition, before any negative operators (i.e. `not` or `!=`).

Rules may need to contain special characters like (, spaces, etc. For example, you may need to look for a proc.name of (`systemd`), including the surrounding parentheses. Use double quotes like: `proc.name="(systemd)"`

When including items in lists, ensure that the double quotes are not interpreted from your YAML file by surrounding the quoted string with single quotes:

```
- list: systemd_procs
  items: [systemd, '"(systemd)"']
``` -->