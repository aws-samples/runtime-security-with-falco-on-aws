---
title: "2. Test installation"
weight: 020
chapter: true
---

## Test your setup

To test the installation, you could simulate a malware binary file being written in */bin*. Actually, it does not need to be malware or even a binary! Any change detected in */bin* will trigger this Falco rule: *Write below binary dir* (see [below]({{< ref "#falco-rules-in-this-example" >}}) for more details).

<!-- too big, it takes time to load, we better use another example
$ git clone https://github.com/MalwareSamples/Linux-Malware-Samples
$ cd Linux-Malware-Samples
$ sudo mv 00ae07c9fe63b080181b8a6d59c6b3b6f9913938858829e5a42ab90fb72edf7a /bin/pwd 
-->

1. Rename an existing tool *pwd* to *old_pwd* and create a new file under */bin* executing the next commands in your right-sided Terminal in your *Cloud9* instance:

  ```
$ sudo mv /bin/pwd /bin/old_pwd
$ sudo mv /bin/old_pwd /bin/pwd
$ sudo touch /bin/also_triggers_the_rule
 
```

2. Now, in the left Terminal, **observe how the Falco log informs** you about this malicious activity as soon as it is detected. *Remember that there's not malicious activity by itself, but just rules targeting specific activities identified as pernicious for a particular system and use-case. You could also create a rule to be alerted when your BitTorrent client downloads a file or when you receive an e-mail, but this is not the goal of this tool.*

    You should see the output of three alerts similar to the following when executing in your left Terminal:

  ```bash
$ cat /var/log/falco_events.log
 
```

    <img src=/images/triggerAlert.gif width="100%" >

3. Someone doing bad things at your system might even think: *all right, I can delete the logs and get away with it without being noticed!*:

```bash
$ sudo -i
echo "" > /var/log/falco_events.log
exit

```

    But Falco got you covered, there's also a rule (*Clear Log Activities*) to detect this action:

  ```log
$ cat /var/log/falco_events.log 
12:30:35.923510082: Warning Log files were tampered (user=root user_loginuid=1000 command=bash file=/var/log/falco_events.log container_id=host image=<NA>)
```
<!-- 
  
  ```log
    12:18:43.261692148: Error File below a known binary directory opened for writing (user=root user_loginuid=1000 command=cp /bin/pwd /bin/old_pwd file=/bin/old_pwd parent=sudo pcmdline=sudo cp /bin/pwd /bin/old_pwd gparent=bash container_id=host image=<NA>)

12:18:59.506227693: Error File below known binary directory renamed/removed (user=root user_loginuid=1000 command=mv 0(...)f0c3d2 /bin/pwd pcmdline=sudo mv 0(...)f0c3d2 /bin/pwd operation=renameat2 file=<NA> res=0 olddirfd=-100(AT_FDCWD) oldpath=0(...)f0c3d2(/home/ec2-user/environment/Linux-Malware-Samples/0(...)f0c3d2) newdirfd=-100(AT_FDCWD) newpath=/bin/pwd flags=0  container_id=host image=<NA>)

12:19:05.416010725: Error File below a known binary directory opened for writing (user=root user_loginuid=1000 command=touch /bin/also_triggers_the_rule file=/bin/also_triggers_the_rule parent=sudo pcmdline=sudo touch /bin/also_triggers_the_rule gparent=bash container_id=host image=<NA>)
    ``` -->

Awesome, right? Keep going to learn how it worked!

## Falco rules in this example

In case you are curious, here are the two rules that were triggered before. But don't worry about its syntax yet.

### Write below binary dir

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
```

### Clear Log Activities

```yaml
- rule: Clear Log Activities
  desc: Detect clearing of critical log files
  condition: >
    open_write and
    access_log_files and
    evt.arg.flags contains "O_TRUNC" and
    not trusted_logging_images and
    not allowed_clear_log_files
  output: >
    Log files were tampered (user=%user.name user_loginuid=%user.loginuid command=%proc.cmdline file=%fd.name container_id=%container.id image=%container.image.repository)
  priority:
    WARNING
  tags: [file, mitre_defense_evasion]
```

You can also preview them directly from your Falco instance rule files with:

```bash
$ cat /etc/falco/falco_rules.yaml | grep -A 8 "rule: Modify binary dirs"
$ cat /etc/falco/falco_rules.yaml | grep -A 13 "rule: Clear Log Activities"
 
```

