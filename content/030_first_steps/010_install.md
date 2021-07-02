---
title: "1. Install Falco in an EC2 host"
weight: 010
chapter: true
---

{{% notice tip %}}
If you deployed an EKS cluster during the Prerequisites section, it is probably still in progress. Open a **new Terminal tab** on the left side of your Cloud9 instance to proceed with this section as illustrated below:
![New Terminal](../images/new_terminal.png)
{{% /notice %}}

## Installing Falco on your AWS Instance

1. Run the following commands to install Falco on your Cloud9 Workstation. You can find [installation instructions](https://falco.org/docs/getting-started/installation/) for most package managers and platforms:

  ```BASH
$ sudo rpm --import https://falco.org/repo/falcosecurity-3672BA8F.asc
$ sudo curl -s -o /etc/yum.repos.d/falcosecurity.repo https://falco.org/repo/falcosecurity-rpm.repo
$ sudo yum -y install kernel-devel-$(uname -r)
$ sudo yum -y install falco
 
```

    And you are done with the installation! Now let's review that everything is working as expected.

2. In this workshop, you are going to run Falco as a service. To do so, first instantiate the log file. And then, update **_/etc/falco/falco.yaml_** to enable logging:

  ```BASH
$ sudo touch /var/log/falco_events.log
$ sudo vi /etc/falco/falco.yaml   # or your favourite editor
 
```

    Update the **_file\_output_** section as follows:

  ```YAML
file_output:
      enabled: true
      keep_alive: true
      filename: /var/log/falco_events.log
```
  
    And then, start the service executing:

  ```BASH
$ sudo systemctl start falco
 
```

    Now Falco is running. In the next step, you'll be executing actions in the right-sided terminal and observing the Falco logs in the left one. 



<!-- screenshot here -->

Below you can find different alternatives to run Falco in your host. **You do not need to execute them to continue with this module**, so you can proceed to the next step.

---

## Alternative Methods

### Run manually

For this module of the workshop, you are going to run Falco manually in your terminal. That means you'd be watching its feed alert directly from *stdout*. This is not the common approach, but might be convenient for this workshop. Remember to relaunch it any time you modify any of its configuration or rule files. 

```bash
$ sudo falco
```

### Docker

To install Falco on your host using docker, first install the kernel headers:

  ```
$ sudo yum -y install linux-headers-$(uname -r)
```

    Then run the following commands:

  ```
  $ docker pull falcosecurity/falco
  $ docker run -i -t \
      --name falco \
      --privileged \
      -v /var/run/docker.sock:/host/var/run/docker.sock \
      -v /dev:/host/dev \
      -v /proc:/host/proc:ro \
      -v /boot:/host/boot:ro \
      -v /lib/modules:/host/lib/modules:ro \
      -v /usr:/host/usr:ro \
      falcosecurity/falco
  ```

For detailed information on Falco daemon configuration, please refer to the [Falco documentation](https://falco.org/docs/configuration/)
