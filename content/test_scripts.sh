# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License


#!/bin/bash

# Need a `./credentials.txt` file with all student keys in this format
# [student1]
# aws_access_key_id = 11112222333344445555
# aws_secret_access_key = aaaabbbbccccddddeeeeffffgggghhhhiiiijjjj
#
# [student2]
# aws_access_key_id = 11112222333344445555
# aws_secret_access_key = aaaabbbbccccddddeeeeffffgggghhhhiiiijjjj

AWS_CONFIG_FILE='credentials.txt'

NUMBEROFSTUDENTS=$(grep student -c $AWS_CONFIG_FILE)
for i in $(seq 1 $NUMBEROFSTUDENTS)
do
PROFILE=student$i
echo Running script for $PROFILE

# PROFILE=default

    # MODULE 1: ECR AUTOMATED IMAGE SCANNING
    ## SETUP AMAZON ECR REGISTRY
    COMMAND="aws --profile $PROFILE ecr list-images --repository-name aws-workshop"
    if  $(echo $COMMAND) > /dev/null ; then
      echo "'aws-workshop' repository created"
    else
      echo "'aws-workshop' repository NOT created"
    fi

    ## DEPLOY THE AMAZON ECR INTEGRATION
    COMMAND="aws --profile $PROFILE cloudformation describe-stacks --stack-name ECRImageScanning"
    if  $(echo $COMMAND) > /dev/null  ; then
      echo "'ECRImageScanning' stack created"
    else
      echo "'ECRImageScanning' stack NOT created"
    fi


    # MODULE 2: FARGATE & ECS AUTOMATED IMAGE SCANNING

    ## INSTALL AMAZON ECS CLI
    COMMAND="aws --profile $PROFILE iam get-role  --role-name ecsTaskExecutionRole"
    if  $(echo $COMMAND) > /dev/null  ; then
      echo "'ecsTaskExecutionRole' role attached"
    else
      echo "'ecsTaskExecutionRole' role NOT attached"
    fi

    ## DEPLOY SYSDIG SECURE AUTOMATED IMAGE SCANNER FOR FARGATE
    COMMAND="aws --profile $PROFILE cloudformation describe-stacks --stack-name ECSImageScanning"
    if  $(echo $COMMAND) > /dev/null  ; then
      echo "'ECSImageScanning' stack created"
    else
      echo "'ECSImageScanning' stack NOT created"
    fi


    ## DEPLOY AN ECS CLUSTER USING FARGATE
    # COMMAND="aws --profile $PROFILE ecs describe-clusters --cluster tutorial" #always returns exit code '0'
    COMMAND="aws --profile $PROFILE ecs list-clusters | grep tutorial"
    if  $( echo $COMMAND) > /dev/null ; then
      echo "Cluster 'tutorial' created"
    else
      echo "Cluster 'tutorial' NOT created"
    fi

    ## INITIATE CODEBUILD PIPELINES BUILD AND SCAN
    COMMAND="aws --profile $PROFILE codebuild list-projects | grep ECSInlineSecureScanning"
    if  $(echo $COMMAND) > /dev/null ; then
      echo "CodeBuild Pipeline 'ECSInlineSecureScanning' created"
    else
      echo "CodeBuild Pipeline 'ECSInlineSecureScanning' NOT created"
    fi

done
