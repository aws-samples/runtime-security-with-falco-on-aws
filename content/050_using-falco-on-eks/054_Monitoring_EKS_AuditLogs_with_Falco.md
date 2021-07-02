---
title: "Installing ekscloudwatch"
weight: 054
chapter: false
---

<!-- https://medium.com/faun/analyze-aws-eks-audit-logs-with-falco-95202167f2e -->
<!-- https://github.com/sysdiglabs/ekscloudwatch -->


## Defining a policy

First, you need to define a policy to provide read permissions and the *CloudWatch* logs:

```bash
# create policy
eksctl utils associate-iam-oidc-provider --cluster=${CLUSTERNAME} --approve
eksctl create iamserviceaccount --cluster=${CLUSTERNAME} --name=ekscloudwatch --namespace=falco --attach-policy-arn=arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess  --override-existing-serviceaccounts --approve
 
```


## Deploying *ekscloudwatch*

  You'll be using the same namespace (*falco*) for the required tools in this step. To deploy *ekscloudwatch* you need to:

  1. Create manifests for *ekscloudwatch* configmap and deployment.
  2. Configure with custom clustername.
  3. And deploy the tool.

  Copy and run the next script in your *Cloud9* instance to execute the three actions:

```bash
cat << 'EOF' > ./ekscloudwatch.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ekscloudwatch-config
  namespace: falco
data:
  # Required: Endpoint to forward audit events to, such as Sysdig Secure agent
  # The agent must expose a k8s audit server (k8s_audit_server_port must be configured in the agent as well)
  endpoint: "http://falco:8765/k8s-audit"
  # Required: Cloudwatch polling interval
  cw_polling: "5m"
  # Required: CloudWatch query filter
  cw_filter: '{ $.sourceIPs[0] != "::1" && $.sourceIPs[0] != "127.0.0.1" }'
  # Optional: the EKS cluster name
  # This can be omitted if the EC2 instance can perform the ec2:DescribeInstances action
  cluster_name: ""
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eks-cloudwatch
  namespace: falco
spec:
  minReadySeconds: 5
  replicas: 1
  selector:
    matchLabels:
      app: eks-cloudwatch
  template:
    metadata:
      labels:
        app: eks-cloudwatch
    spec:
      serviceAccountName: ekscloudwatch
      securityContext:
        fsGroup: 65534 # to be able to read Kubernetes and AWS token files
      containers:
        - image: sysdiglabs/k8sauditlogforwarder:ekscloudwatch-0.2
          imagePullPolicy: Always
          name: eks-cloudwatch-container
          env:
            - name: ENDPOINT
              valueFrom:
                configMapKeyRef:
                  name: ekscloudwatch-config
                  key: endpoint
            - name: CLUSTER_NAME
              valueFrom:
                configMapKeyRef:
                  name: ekscloudwatch-config
                  key: cluster_name
            - name: CW_POLLING
              valueFrom:
                configMapKeyRef:
                  name: ekscloudwatch-config
                  key: cw_polling
            - name: CW_FILTER
              valueFrom:
                configMapKeyRef:
                  name: ekscloudwatch-config
                  key: cw_filter
EOF

sed -i "s/cluster_name: \"\"/cluster_name: \"$CLUSTERNAME\"/g" ekscloudwatch.yaml

kubectl --namespace falco apply -f ekscloudwatch.yaml
 
```

Check that the pod is *Running* status and that the logs shows something like this:

```bash
$ kubectl get pods -n falco
NAME                                      READY   STATUS    RESTARTS   AGE
eks-cloudwatch-585578f4ff-85pv4           1/1     Running   0          20s
falco-dw76v                               1/1     Running   0          3m40s
falco-falcosidekick-54bb64d5f5-m88s6      1/1     Running   0          3m40s
falco-falcosidekick-54bb64d5f5-szv75      1/1     Running   0          3m40s
falco-falcosidekick-ui-5d7fdf5ffc-xscvh   1/1     Running   0          3m40s
falco-gzkql                               1/1     Running   0          3m40s
falco-tpfn4                               1/1     Running   0          3m40s

$ kubectl logs eks-cloudwatch-585578f4ff-85pv4 -n falco
2021/05/19 10:59:12 Cloudwatch EKS log started
2021/05/19 10:59:12 AWS Instance ID: i-029040e373aee5cef
2021/05/19 10:59:15 1024 logs sent to the agent (1024 total)
2021/05/19 10:59:17 638 logs sent to the agent (1662 total)
2021/05/19 10:59:20 1038 logs sent to the agent (2700 total)
2021/05/19 10:59:21 273 logs sent to the agent (2973 total)
2021/05/19 10:59:21 0 logs sent to the agent (2973 total)
2021/05/19 10:59:21 2973 total logs
```
---

And you are done! You have configured Falco to **Detect Runtime Security incidents in your EKS cluster**. 

In the final step of this module, you'll be triggering one of the default rules for k8s to check that Falco is detecting runtime threads.


<!-- current status, bug:
https://github.com/falcosecurity/charts/issues/234

this is the log I get...

---logs for pod falco-w6nkx---
* Setting up /usr/src links from host
* Running falco-driver-loader for: falco version=0.28.1, driver version=5c0b863ddade7a45568c0ac97d037422c9efb750
* Running falco-driver-loader with: driver=module, compile=yes, download=yes
* Unloading falco module, if present
* Trying to load a system falco module, if present
* Looking for a falco module locally (kernel 4.14.232-176.381.amzn2.x86_64)
* Trying to download a prebuilt falco module from https://download.falco.org/driver/5c0b863ddade7a45568c0ac97d037422c9efb750/falco_amazonlinux2_4.14.232-176.381.amzn2.x86_64_1.ko
curl: (22) The requested URL returned error: 404 
Unable to find a prebuilt falco module
* Trying to dkms install falco module with GCC /usr/bin/gcc
DIRECTIVE: MAKE="'/tmp/falco-dkms-make'"
* Running dkms build failed, couldn't find /var/lib/dkms/falco/5c0b863ddade7a45568c0ac97d037422c9efb750/build/make.log (with GCC /usr/bin/gcc)
* Trying to dkms install falco module with GCC /usr/bin/gcc-8
DIRECTIVE: MAKE="'/tmp/falco-dkms-make'"
* Running dkms build failed, couldn't find /var/lib/dkms/falco/5c0b863ddade7a45568c0ac97d037422c9efb750/build/make.log (with GCC /usr/bin/gcc-8)
* Trying to dkms install falco module with GCC /usr/bin/gcc-6
DIRECTIVE: MAKE="'/tmp/falco-dkms-make'"
* Running dkms build failed, couldn't find /var/lib/dkms/falco/5c0b863ddade7a45568c0ac97d037422c9efb750/build/make.log (with GCC /usr/bin/gcc-6)
* Trying to dkms install falco module with GCC /usr/bin/gcc-5
DIRECTIVE: MAKE="'/tmp/falco-dkms-make'"
* Running dkms build failed, couldn't find /var/lib/dkms/falco/5c0b863ddade7a45568c0ac97d037422c9efb750/build/make.log (with GCC /usr/bin/gcc-5)
Consider compiling your own falco driver and loading it or getting in touch with the Falco community
Wed Jun  2 21:35:27 2021: Falco version 0.28.1 (driver version 5c0b863ddade7a45568c0ac97d037422c9efb750)
Wed Jun  2 21:35:27 2021: Falco initialized with configuration file /etc/falco/falco.yaml
Wed Jun  2 21:35:27 2021: Loading rules from file /etc/falco/falco_rules.yaml:
Wed Jun  2 21:35:27 2021: Loading rules from file /etc/falco/falco_rules.local.yaml:
Wed Jun  2 21:35:27 2021: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Wed Jun  2 21:35:27 2021: Unable to load the driver.
Wed Jun  2 21:35:27 2021: Runtime error: error opening device /host/dev/falco0. Make sure you have root credentials and that the falco module is loaded.. Exiting.

 -->