---
title: "3.5 Deploying an EKS cluster"
chapter: false
weight: 22
---

If you are going to take [Module 4. Using Falco on EKS]({{< ref "050_using-falco-on-eks" >}}), execute the next script on your Cloud9 instance. **It takes around 20 minutes to complete, so it should be ready when you get to it**. 

This script deploys a EKS Cluster. We're going to use *eksctl* to instantiate an EKS cluster. *eksctl* is a simple CLI tool for creating and managing clusters on EKS - Amazon's managed Kubernetes service for EC2.

Before creating the cluster, set your initials or any other identifier (lowercase, enter when prompted) in the environment variable. This will be used to identify assets later, and helps making it unique. Copy and run in your *Cloud9* instance:

```sh
# set identifier
read -p "Enter your initials: " INITIALS
```

And then copy and run the script in your Cloud9 instance:

{{% notice tip %}}
Do not wait for it to be done and proceed to the next step of the workshop while this script is executed. Your EKS should be ready by the time you get to the module where it is used. When required, open a new Terminal and let this one run in the background.
{{% /notice %}}

```sh
# install eksctl commandline tool
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Create an AWS Key Management Service (KMS) Custom Managed Key (CMK) for the EKS cluster to use when encrypting your Kubernetes secrets:
aws kms create-alias --alias-name alias/eksworkshop --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)

# Set the MASTER_ARN environment variable to make it easier to refer to the KMS key later:
export MASTER_ARN=$(aws kms describe-key --key-id alias/eksworkshop --query KeyMetadata.Arn --output text)
export INITIALS
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export AZS=($(aws ec2 describe-availability-zones --query 'AvailabilityZones[].ZoneName' --output text --region $AWS_REGION))
export CLUSTERNAME=falco-workshop-${INITIALS,,}

# save in bash_profile:
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
echo "export INITIALS=${INITIALS}" | tee -a ~/.bash_profile
echo "export AZS=(${AZS[@]})" | tee -a ~/.bash_profile
echo "export CLUSTERNAME=falco-workshop-${INITIALS,,}" | tee -a ~/.bash_profile
echo "export MASTER_ARN=${MASTER_ARN}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region

# Create an eksctl deployment file (eksworkshop.yaml) use in creating your cluster using the following syntax:
# we keep the AMI version fixed so we know that this is going to need little maintenance
cat << EOF > eksworkshop.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ${CLUSTERNAME}
  region: ${AWS_REGION}
  version: "1.20"

availabilityZones: ["${AZS[0]}", "${AZS[1]}", "${AZS[2]}"]

managedNodeGroups:
  - name: nodegroup
    ami: ami-0e8862f0fcf9952e8
    desiredCapacity: 3
    instanceType: t3.small
    overrideBootstrapCommand: |
      #!/bin/bash
      /etc/eks/bootstrap.sh ${CLUSTERNAME}

# To enable all of the control plane logs, uncomment below:
cloudWatch:
  clusterLogging:
    enableTypes: ["*"]

secretsEncryption:
  keyARN: ${MASTER_ARN}
EOF

#Next, use the file you created as the input for the eksctl cluster creation.
eksctl create cluster -f eksworkshop.yaml
 
```


