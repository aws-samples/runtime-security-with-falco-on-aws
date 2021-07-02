---
title: "Additional Components"
weight: 035
chapter: false
---

There are other options that you can include when defining a new rule:

 - **exceptions**: A set of exceptions that, when meet, disable the alert.
 - **enabled**:	If set to false, a rule is neither loaded nor matched against any events.
 - **tags**:	A list of tags applied to the rule.
 - **warn_evttypes**: If set to false, Falco suppresses warnings related to a rule not having an event type.
 - **skip-if-unknown-filter**: If set to true and a rule condition contains a *filtercheck*, e.g. `fd.some_new_field` that is not known to this version of Falco, Falco silently accepts the rule but does not execute it.

## Exceptions

Most rules might find a particular use-case where an exception is required. Starting in 0.28.0, Falco supports an optional exceptions property to rules. The exceptions key is a list of identifier plus list of tuples of filtercheck fields. 

When is it recommended to apply an exception? This is not easy to define, but whenever you start to think that a rule is being to noise and being triggered by false positives, an exception is something you might try to solve it. Aply exceptions to existing rules with the `append` syntax you learned before.

There are four kinds of exceptions you can define:

- `proc_writer`: uses a combination of proc.name and fd.directory.
- `container_writer`: uses a combination of container.image.repository and fd.directory.
- `proc_filenames`: uses a combination of process and list of filenames.
- `filenames`: uses a list of filenames.

Here you can find an example:

```
- rule: <existing_rule>
  exceptions:
  - name: proc_writer
    values:
    - [proc_name, /usual/dir]
  - name: container_writer
    values:
    - [<registry>/<image>, /usual/dir]
  - name: proc_filenames
    values:
    - [apt, apt_files]
    - [rpm, [/bin/cp, /bin/pwd]]
  - name: filenames
    values: [python, go]
  append: true
```

Of course, you could define this logic with existing conditions. The exceptions are effectively syntatic sugar that allows expressing sets of exceptions in a concise way.

## Disabling Conditions

Sometimes exceptions might just be not enough. You can disable a rule enabled by default using a combination of the `append: true` and `enabled: false` rule properties:

```
- rule: <existing_rule>
  append: true
  enabled: false
```