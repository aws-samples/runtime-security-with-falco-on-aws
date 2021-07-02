---
title: "Install Falco on EKS Cluster"
weight: 053
chapter: false
---

First, let's install *Falco* on the *EKS cluster*. From your *Cloud9* instance, execute:

  ```bash
$ helm repo add falcosecurity https://falcosecurity.github.io/charts
$ helm repo update
$ helm install falco \
  --namespace falco \
  --create-namespace \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true \
  --set auditLog.enabled=true \
falcosecurity/falco
 
```

In one of the next modules, you'll be practicing with the **Falco Response Engine (*falcosidekick*)**, so the options to deploy it with *Falco* have been included in the previous command!

*Please, note that you do not need to include the options:

```
  --set falco.jsonOutput=true
  --set falco.httpOutput.enabled=true
  --set falco.httpOutput.url=http://falcosidekick:2801
```

as long as you set:

```
--set falcosidekick.enabled=true
```

You can check the progress of the install by running:

```bash
$ kubectl get pods -n falco
$ kubectl get services --namespace falco
 
```

This is the expected output if everything worked:

```bash
NAMESPACE     NAME                                      READY   STATUS              RESTARTS   AGE
falco         falco-2p4sw                               0/1     ContainerCreating   0          12s
falco         falco-falcosidekick-554b8859d5-f6r7m      0/1     Running             0          12s
falco         falco-falcosidekick-554b8859d5-n8nc7      0/1     Running             0          12s
falco         falco-falcosidekick-ui-5d747688f9-qtd9j   0/1     ContainerCreating   0          12s
falco         falco-p5ksr                               0/1     ContainerCreating   0          12s
```

You can see that falcosidekick was also deployed along with *Falco*. You'll be using it in the next module. Once all the pods are in 'Running' state, you can proceed to the next step. 

Falcosidekick should return the next logs:

```log
$ kubectl logs deployment/falco-falcosidekick --namespace falco
Found 2 pods, using pod/falco-falcosidekick-fb6f8b856-wjvzx
2021/05/22 15:46:58 [INFO]  : Enabled Outputs : [WebUI]
2021/05/22 15:46:58 [INFO]  : Falco Sidekick is up and listening on :2801
```