---
title: "Extending existing resources"
weight: 033
chapter: false
---

Imagine that you need to extend an existing rule, list, or macro. In Falco, this is call appendingTo keep it compatible with existing resources, you can create the same resource with the new information and with the `append: true` directive. For example, for the list:

```
- list: shell_binaries
  items: [bash, csh, ksh, sh]
```

Edit it to match this:

```
- list: shell_binaries
  items: [bash, csh, ksh, sh]

- list: shell_binaries
  append: true
  items: [tcsh, zsh, dash]
```

If you edit you custom rules file as follow, the result should be the same as the previous step (as you are including the same shell binary names):

```
sudo -i
sudo cp /etc/falco/falco_rules.local.yaml.BAK /etc/falco/falco_rules.local.yaml
sudo cat  <<EOF >> /etc/falco/falco_rules.local.yaml
- list: shell_binaries
  items: [bash, csh, ksh, sh]

- list: shell_binaries
  append: true
  items: [tcsh, zsh, dash]

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

Trigger the same event that you used in the previous step and observe the results. They should be the same. 

---

Be aware that you can also apply this to macros or to extend the condition of a rule:

```
- rule: <rule_to_be_extended>
  append: true
  condition: and <field>=<value>
```
