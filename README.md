# #TerraformOnAzure Challenge - episode 4

The fourth challenge of the [Terraform On Azure](https://github.com/Terraform-On-Azure-Workshop/terraform-azure-hashiconf2020) asks you to provision an AKS cluster, and to deploy the sample application on it.

We need to create an AKS cluster via Terraform. Then, we have to prepair a container for our sample app, publish it to an Azure Container Registry and deploy it to the AKS cluster via Helm.
You can read more about the challenge [here](https://github.com/Terraform-On-Azure-Workshop/terraform-azure-hashiconf2020/blob/main/challenges/challenge4/Readme.md).

I used Terraform to deploy a resource group with an AKS and an ACR.

Locally, I used **init.sh** to:
- install kubectl
- install helm
- install docker

Then, I used **build-and-deploy.sh** inside the folder where I cloned the repo to:
- build the image and tag it
- push the image to ACR
- connect to AKS and federate it with ACR
- deploy the app with Helm

I executed all the steps above on Ubuntu 18.04 WSL2.