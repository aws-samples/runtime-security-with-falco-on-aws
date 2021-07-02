# Secure DevOps with AWS & Sysdig

In this workshop, you will learn how to securely run cloud applications in production by automating AWS Fargate and ECR image scanning directly in your AWS environment. You will also discover how to improve the security of your cloud infrastructure using AWS CloudTrail and Sysdig CloudConnector.


## Building the Website locally

This page is built with Hugo, so you'll need it [installed](https://gohugo.io/getting-started/quick-start/#step-1-install-hugo)

First, clone this repo:
```bash
git clone git@github.com:draios/training.git
```

and navigate to the particular workshop you want to use. In this case, 

```bash
cd workshops/falco-aws-workshop
```



As a reference, you might want to check out the first workshop published [here](https://github.com/aws-samples/aws-modernization-with-sysdig)

<!-- ```bash
git clone git@github.com:aws-samples/aws-modernization-with-sysdig.git
``` -->

Ensure you've also cloned the submodules:

```bash
git submodule init
git submodule update
```

Then serve the website with hugo:

```bash
hugo server
```

This will launch a local copy of the content accessible from your [browser](http://localhost:1313/). 


## Building the Website in public S3 bucket

You might want to make this public for review. An S3 bucket is available for this.

Requirements: aws-cli tool with a valid session

Uncomment the docker MFA AWS command if required and run with `push-to-s3.sh`. 

### Learning Objectives
- Amazon ECR image scanning
- Amazon Fargate automated image scanning
- Amazon CloudTrail runtime security

