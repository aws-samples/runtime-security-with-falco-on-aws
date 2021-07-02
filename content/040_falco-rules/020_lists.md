---
title: "Lists"
weight: 032
chapter: false
---

In the same way as macros, lists are all about making it easier to work with rules. Lists are named collections of items that you can include in rules, macros, or even other lists. The format of lists is as follows

```
- list: list_name
  items: [list, of, items]
```

Lists can contain individual items, or other lists, for example:

```
- list: shell_binaries
  items: [bash, csh, ksh, sh, tcsh, zsh, dash]

- list: userexec_binaries
  items: [sudo, su]

- list: known_binaries
  items: [shell_binaries, userexec_binaries]
```

With these lists defined, you can then extend your **shell in a container** example further as follows:

```
- list: shell_binaries
  items: [bash, csh, ksh, sh, tcsh, zsh, dash]

- list: userexec_binaries
  items: [sudo, su]

- list: known_binaries
  items: [shell_binaries, userexec_binaries]

- macro: is_shell
  condition: proc.name in (known_binaries)

- rule: workshop_shell_in_container
  desc: notice shell activity within a container
  condition: container.id != host and is_shell and evt.type=openat
  output: falco_AWS_workshop shell in a container (user=%user.name container_id=%container.id container_name=%container.name shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
  priority: WARNING
```


#### Try It!

1. Again, let's copy the original `falco_rules.local` back into place. And then, implement the new rule and macro with the new lists:

```
sudo -i
sudo cp /etc/falco/falco_rules.local.yaml.BAK /etc/falco/falco_rules.local.yaml
sudo cat  <<EOF >> /etc/falco/falco_rules.local.yaml
- list: shell_binaries
      items: [bash, csh, ksh, sh, tcsh, zsh, dash]

- list: userexec_binaries
      items: [sudo, su]

- list: known_binaries
      items: [shell_binaries, userexec_binaries]

- macro: is_shell
      condition: proc.name in (known_binaries)

- rule: shell_in_container
      desc: notice shell activity within a container
      condition: container.id != host and is_shell and evt.type=openat
      output: falco_AWS_workshop shell in a container (user=%user.name container_id=%container.id container_name=%container.name shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
      priority: WARNING
EOF
exit
sudo systemctl restart falco
 
```

1. You know the drill. In the first terminal, create a shell in that container, then immediately log out

  ```
  docker exec -it web /bin/dash
  exit
   
  ```

2. You should see the same message in the log file in terminal 2. Test it with any of the other processes defined in your list, the result will be the same!


### Summary: Rules, Macros and Lists

Remember: a Falco rules file may contain three kinds of elements:

- **Macros**: are simply rule condition snippets that can be re-used inside rules and other macros, providing a way to factor out and name common patterns.
- **Lists**: are (surprise!) lists of items that can be included in rules, macros, or other lists. Unlike rules/macros, they can not be parsed as sysdig filtering expressions.
- **Rules**: consist of a condition under which an alert should be generated and an output string to send with the alert.


#### Food for thought

Think about it: you can use the conditions in a rule to **generalize** it to a wider set of elements, based on any particular dimension of the event (process name, file descriptors, port number, destination IP, etc.). For example, instead of asserting a condition like: `proc.name=vi` you could define a *macro* and *list*:

```
- list: program_ide
  items: [vi, nano, pico, msword]

- macro: editing_proc
  condition: proc.name in (program_ide)
```

and then change the condition to `proc.name=editing_proc`. This way, it is "easier" for the rule to be triggered, as it scopes a wider range of elements.

But you could also make the condition more specific, and hence more restrictive! For example, one of the available fields is `evt.buffer`. This field is particularly interesting because it stores the binary data buffer for events that have this metadata associated, like:

- *read()* 
- *recvfrom()*

Use this field in filters with *contains* to search into I/O data buffers. For example, including a new condition like: `and evt.buffer contains promcat` would filter out any event not reading from a file the string *promcat*.
