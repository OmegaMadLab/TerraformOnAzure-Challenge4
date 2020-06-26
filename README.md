# #TerraformOnAzure Challenge - episode 4

The fourth challenge of the [Terraform On Azure](https://github.com/Terraform-On-Azure-Workshop/terraform-azure-hashiconf2020) asks you to provision an AKS cluster, and to deploy the sample application on it.

We need to create an AKS cluster via Terraform. Then, we have to prepair a container for our sample app, publish it to an Azure Container Registry and deploy it to the AKS cluster via Helm.
You can read more about the challenge [here](https://github.com/Terraform-On-Azure-Workshop/terraform-azure-hashiconf2020/blob/main/challenges/challenge4/Readme.md).



I used **init.sh** to:
- create the storage account and show its keys
- create a service principal and show its credentials

Then, I saved them as environment variables in GitHub Actions, and setup a YAML pipeline to deploy the TF infrastructure.

You can find init.sh in the */setup folder*, while the YAML pipeline is in *.github/workflows/*.  