---
title: "Trigger a rule and observe results"
weight: 055
chapter: false
---

## Triggering an event

To test that everything is working fine, you are going to trigger an event for one of the rules defined [here](https://github.com/falcosecurity/falco/blob/master/rules/k8s_audit_rules.yaml).

For example, let's trigger the [*Create Privileged Pod*](https://github.com/falcosecurity/falco/blob/59831b077e61dd4179db4be5d9a520232546d72b/rules/k8s_audit_rules.yaml#L132) rule.

```yaml
- rule: Create Privileged Pod
  desc: >
    Detect an attempt to start a pod with a privileged container
  condition: kevt and pod and kcreate and ka.req.pod.containers.privileged intersects (true) and not ka.req.pod.containers.image.repository in (falco_privileged_images)
  output: Pod started with privileged container (user=%ka.user.name pod=%ka.resp.name ns=%ka.target.namespace images=%ka.req.pod.containers.image)
  priority: WARNING
  source: k8s_audit
  tags: [k8s]
```

{{% notice tip %}}
This rule is triggered whenever a pod with a privileged container is deployed. Be aware that in this use case you are not taking any action to stop this behaviour, but just detecting and alerting. If you want to deploy a **Response Engine** to define actions triggered by Falco (for example, killing pods deployed with a privileged container), check the next module about [Falcosidekick](https://falco.org/blog/falcosidekick-reponse-engine-part-1-kubeless/)!
{{% /notice %}}

1. Create and deploy a pod with a privileged container:

  ```bash
kubectl create -f- <<EOF
apiVersion: v1
kind: Pod
metadata:
      name: privileged
spec:
      containers:
        - name: pause
          image: k8s.gcr.io/pause
          securityContext:
            privileged: true
EOF
```

2. Check the logs

    Let's see if the security event was detected. Check the Falco pods logs with:

    ```
    for pod in $(kubectl get pods -n falco |grep falco|grep -v sidekick | awk '{print $1}') ; do
      echo ---logs for pod $pod--- >> eksalert.log
      kubectl logs -n falco $pod >> eksalert.log
    done

    cat eksalert.log | grep "Notice Privileged"
    ```

3. **Runtime Security Alert detected!** Indeed, you should find an alert about a privileged pod deployed:

    ```yaml
{
  "output": "11:11:02.802573887: Notice Privileged container started (user=root user_loginuid=0 command=container:780340823db8 k8s.ns=<NA> k8s.pod=<NA> container=780340823db8 image=k8s.gcr.io/pause:latest) k8s.ns=<NA> k8s.pod=<NA> container=780340823db8 k8s.ns=<NA> k8s.pod=<NA> container=780340823db8",
  "priority": "Notice",
  "rule": "Launch Privileged Container",
  "time": "2021-05-19T11:11:02.802573887Z",
  "output_fields":
    {
      "container.id": "780340823db8",
      "container.image.repository": "k8s.gcr.io/pause",
      "container.image.tag": "latest",
      "evt.time": 1621422662802573887,
      "k8s.ns.name": null,
      "k8s.pod.name": null,
      "proc.cmdline": "container:780340823db8",
      "user.loginuid": 0,
      "user.name": "root",
    },
}
```


## Event generator

If you want to see more examples, you can deploy the [sample-events](https://falco.org/docs/event-sources/sample-events/) app from Falco. It triggers some of the rules defined in the *k8s_audit_rules* definition file. It is recommended to execute the next command for the last step. You'll be using the falcosidekick-ui and this way its dashboard will be populated with multiple alerts.

You just need to run again the Helm chart we deployed with the flag *fakeEventGenerator* enabled. Upgrade it with:

```bash
$ helm install falco \
  --namespace falco \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true \
  --set falco.jsonOutput=true \
  --set falco.httpOutput.enabled=true \
  --set falco.httpOutput.url=http://falcosidekick:2801 \
  --set auditLog.enabled=true \
  --set fakeEventGenerator.enabled=true \
falcosecurity/falco
```


## Finish

And that's all! In this module you learned how to implement threat detection in EKS. New rules are constantly created by the community, check the community channel (#falco) at [Kubernetes Slack](www.slack.kubernetes.com) to stay tunned! 

{{% notice tip %}}
Do not remove the cluster yet, as you will be using it in the last module to learn about Falco Response Engine with Falcosidekick.
{{% /notice %}}