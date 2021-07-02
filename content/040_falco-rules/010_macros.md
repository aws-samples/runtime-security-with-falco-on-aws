---
title: "Macros"
weight: 031
chapter: false
---

Suppose that you need to make the detection scope of your rule wider. Right now, it just detects the intrusion when *bash* is used. But what happens if you log into the container using *sh* (you can test it following the same step at the end of the previous step. No alert is triggered! 

This can be solved with macros. Macros provide a way to define common sub-portions of rules in a reusable way. Of course, you could make the condition more complex, but macros provide a way to keep your rules organized and easy to read/maintain. And also, you reuse portions of your rule definitions. The basic format of a macro is:

```YAML
- macro: macro_name
  condition: filter expression
```

As a very simple example, if you have many rules for events happening in containers, you might want to define a `is_shell` macro:

```YAML
- macro: is_shell
  condition: proc.name in (bash, csh, ksh, sh, tcsh, zsh, dash)
```

Using macros, you could extend the previous **shell in a container** example as follows:

```YAML
- macro: is_shell
  condition: proc.name in (bash, csh, ksh, sh, tcsh, zsh, dash)

- rule: workshop_shell_in_container
  desc: notice shell activity within a container
  condition: container.id != host and is_shell and evt.type=openat
  output: falco_AWS_workshop shell in a container (user=%user.name container_id=%container.id container_name=%container.name shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
  priority: WARNING
```


#### Try It!

1. Let's copy the original *falco_rules.local* back into place (wiping the previous version), and implement the new version of the rule with a macro:

```
sudo -i
sudo cp /etc/falco/falco_rules.local.yaml.BAK /etc/falco/falco_rules.local.yaml
sudo cat  <<EOF >> /etc/falco/falco_rules.local.yaml
- macro: is_shell
      condition: proc.name in (bash, csh, ksh, sh, tcsh, zsh, dash)

- rule: workshop_shell_in_container
      desc: notice shell activity within a container
      condition: container.id != host and is_shell and evt.type=openat
      output: falco_AWS_workshop shell in a container (user=%user.name container_id=%container.id container_name=%container.name shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
      priority: WARNING
EOF
exit
sudo systemctl restart falco
 
```

    Check your changes! Do you remember how to lint the new changes to the rules file?

2. In your right-side terminal, create a shell in that container. But this time, let's use *sh* too (in the first example, you used *bash*):

  ```BASH
docker exec -it web /bin/sh
exit  
docker exec -it web /bin/bash
exit  
 
```

3. You should see the same message in the log file in terminal 2 after reviewing the logs:

  ```log
$ cat /var/log/falco_events.log 
 
```

    But note that the value of the shell (displaying the *proc.name* field) differs. Now the detection power of this rule is higher.

    


The default Falco rule set defines a number of **macros** that makes it easier to start writing further rules - see [here](https://falco.org/docs/rules/default-macros/). These macros provide shortcuts for a number of common scenarios and can be used in any user-defined rule sets. Reusing the code using macros is a good practice.
