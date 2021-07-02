---
title: "3.1 Create a new Cloud9 IDE environment"
chapter: false
weight: 18
---

We will use Amazon Cloud9 to access our AWS account via the AWS CLI in this Workshop.  There are a few steps to complete to set this up:

### Creating a new instance

1. Within the AWS console, use the region drop list to select **us-east-1 (N. Virginia)**.  This will ensure the workshop script provisions the resources in this same region..

2. Navigate to the [cloud9 console](https://console.aws.amazon.com/cloud9/home) or just search for it under the **AWS console services** menu.

3. Click the **Create environment** button

4. For the name use `falco-workshop`, then click **Next step**

6. Select the default instance type **t3.medium**

5. Select **Amazon Linux 2**.

7. Leave all the other settings as default and click **Next step** followed by **Create environment**

<img src=/images/10_prerequisites/cloud9_2.gif width="75%" height="57%">

{{% notice info %}}
This will take about 1-2 minutes to provision
{{% /notice %}}

### Configuring Cloud9 IDE environment

When the environment comes up, customize the environment by:

1. Close the **welcome page** tab

2. Close the **lower work area** tab

3. Click *View*, *Layout*, and select **Horizontal Split**. You'll be using this layout to execute actions in the right-sided terminal and observe Falco alerts on the left-sided one.

4. Open two new **terminal** tabs, one on each side of the main work area.

5. Hide the left hand environment explorer by clicking on the left side **environment** tab, you won't be using it.

<img src=/images/10_prerequisites/cloud9config.gif width="75%" height="57%">

{{% notice tip %}}
If you don't like this dark theme, you can change it from the **View / Themes** Cloud9 workspace menu.
{{% /notice %}}

{{% notice tip %}}
Cloud9 requires third-party-cookies. You can whitelist the [specific domains]( https://docs.aws.amazon.com/cloud9/latest/user-guide/troubleshooting.html#troubleshooting-env-loading).  You are having issues with this, Ad blockers, javascript disablers, and tracking blockers should be disabled for the cloud9 domain, or connecting to the workspace might be impacted.
{{% /notice %}}
