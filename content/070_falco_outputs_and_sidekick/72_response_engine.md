---
title: "Response Engine with Kubeless"
weight: 072
chapter: true
---

# Response Engine with Kubeless

In this step you'll configure Falco to trigger automated reactions to events. You can configure security playbooks to be applied as FaaS based on Falco events. This might include:

- Taint a node NoSchedule
- Isolate pod via Network Policy
- Delete offending pod
- Scale down deployment to 0 pods
- Trigger a Sysdig capture
- Send notifications


To proceed, first install Kubeless:

```bash
export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
kubectl create ns kubeless
kubectl create -f https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless-$RELEASE.yaml
 
```

You need to specify a new output for Falcosidekick (check the two last options provided):

```bash
helm upgrade falco \
  --namespace falco \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true \
  --set falco.jsonOutput=true \
  --set falco.httpOutput.enabled=true \
  --set falco.httpOutput.url=http://falcosidekick:2801 \
  --set auditLog.enabled=true \
  --set falcosidekick.config.kubeless.namespace=kubeless \
  --set falcosidekick.config.kubeless.function=delete-pod \
falcosecurity/falco
 
```

Finally, check that Kubeless is enabled as output:

```bash
kubectl logs deployment/falco-falcosidekick -n falco
 
```

All the squeletoon is prepared, now you just need to provide permissions to execture the action and define the action (function).

## RBAC permissions

In order for the serverless function to be able to delete a pod in any namespace, create a ServiceAccount with required permissions:

```
cat <<EOF | kubectl apply -n kubeless -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: falco-pod-delete
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: falco-pod-delete-cluster-role
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "delete"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: falco-pod-delete-cluster-role-binding
roleRef:
  kind: ClusterRole
  name: falco-pod-delete-cluster-role
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: falco-pod-delete
    namespace: kubeless
EOF
 
```

## Kubeless function: kill privileged pod

And then install the function:

```
cat <<EOF | kubectl apply -n kubeless -f -
apiVersion: kubeless.io/v1beta1
kind: Function
metadata:
  finalizers:
    - kubeless.io/function
  generation: 1
  labels:
    created-by: kubeless
    function: delete-pod
  name: delete-pod
spec:
  checksum: sha256:a68bf570ea30e578e392eab18ca70dbece27bce850a8dbef2586eff55c5c7aa0
  deps: |
    kubernetes>=12.0.1
  function-content-type: text
  function: |-
    from kubernetes import client,config

    config.load_incluster_config()

    def delete_pod(event, context):
        rule = event['data']['rule'] or None
        output_fields = event['data']['output_fields'] or None

        if rule and rule == "Terminal shell in container" and output_fields:
            if output_fields['k8s.ns.name'] and output_fields['k8s.pod.name']:
                pod = output_fields['k8s.pod.name']
                namespace = output_fields['k8s.ns.name']
                print (f"Deleting pod \"{pod}\" in namespace \"{namespace}\"")
                client.CoreV1Api().delete_namespaced_pod(name=pod, namespace=namespace, body=client.V1DeleteOptions())
  handler: delete-pod.delete_pod
  runtime: python3.7
  deployment:
    spec:
      template:
        spec:
          serviceAccountName: falco-pod-delete
EOF
 
```

Now you should see the Kubeless function running with the service delete-pod available on port 8080:

```bash
kubectl get svc -n kubeless
```


## Try it!

Create a pod:

```
kubectl run alpine \
  -n default \
  --image=alpine \
  --restart='Never' \
  -- sh -c "sleep 600"
```

and run a shell inside it:

```
kubectl exec -i --tty alpine -n default -- sh -c "uptime"
```

You should see that its status now is `Terminating`.



<!-- 
UPGRADE TO LAMBDA

example falco + AWS SNS but using NATS
https://aws.amazon.com/blogs/opensource/securing-amazon-eks-lambda-falco/


helm upgrade falco \
  --namespace falco \
  --set config.aws.s3.bucket="cloud9-pablo2-bucket" \
  --set config.aws.s3.prefix="pableras" \
  --set config.aws.s3.functionname="pablo-lambda" \
  --set config.aws.s3.minimumpriority="" \
falcosecurity/falco


aws:
  # accesskeyid: "" # aws access key (optional if you use EC2 Instance Profile)
  # secretaccesskey: "" # aws secret access key (optional if you use EC2 Instance Profile)
  # region : "" # aws region (optional if you use EC2 Instance Profile)
  lambda:
    # functionname : "" # Lambda function name, if not empty, AWS Lambda output is enabled
    # minimumpriority: "" # minimum priority of event for using this output, order is emergency|alert|critical|error|warning|notice|informational|debug or "" (default)
  sqs:
    # url : "" # SQS Queue URL, if not empty, AWS SQS output is enabled
    # minimumpriority: "" # minimum priority of event for using this output, order is emergency|alert|critical|error|warning|notice|informational|debug or "" (default)
  sns:
    # topicarn : "" # SNS TopicArn, if not empty, AWS SNS output is enabled
    rawjson: false # Send Raw JSON or parse it (default: false)
    # minimumpriority: "" # minimum priority of event for using this output, order is emergency|alert|critical|error|warning|notice|informational|debug or "" (default)
  cloudwatchlogs:
    # loggroup : "" #  AWS CloudWatch Logs Group name, if not empty, CloudWatch Logs output is enabled
    # logstream : "" # AWS CloudWatch Logs Stream name, if empty, Falcosidekick will try to create a log stream
    # minimumpriority: "" # minimum priority of event for using this output, order is emergency|alert|critical|error|warning|notice|informational|debug or "" (default)
  s3:
    # bucket: "falcosidekick" # AWS S3, bucket name
    # prefix : "" # name of prefix, keys will have format: s3://<bucket>/<prefix>/YYYY-MM-DD/YYYY-MM-DDTHH:mm:ss.s+01:00.json
    # minimumpriority: "" # minimum priority of event for using this output, order is emergency|alert|critical|error|warning|notice|informational|debug or "" (default)
-->

---

You have completed the last step!
