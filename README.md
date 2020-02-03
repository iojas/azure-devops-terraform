# Automating Infrastructure deployment for Azure and Azure Devops

This repo is a IaC for deploying infrastructure required for CI/CD pipeline in Azure. In a nuteshell, It authenticates your specific github repo with a spe ifazure devops project, runs build, creates docker image and uploads it to ACR. 

## Prerequisites:

Following packages needs to be installed.
- Terraform
- Azure cli
- Azure devops plugin for Azure CLI
- jq
- Python 3.X

IN order for this automation to work there are also following environment variables you are expected to set. 
- TF_VAR_GITHUB_TOKEN - Personal Access GITHUB Token (PAT)
- AZDO_PERSONAL_ACCESS_TOKEN - Azure devops Personal Access Token
- AZDO_ORG_SERVICE_URL - Azure Organization URL

Steps:

1. Create resource group in a specific Azure region
2. Use *az cli* to create storage account and storage container. we primararilly wanted to use Terraform but you need to store terraform backend in azure storage, which needs to be setup prior to using terraform,.
3. Once prerequisites for terraform backend are in place we can configure terraform backend in azure storage using the command
```set-terraform-backend```
4. Next, we run terraform deploy which creates cointainer registry and storage container in azure portal. This command also creates azure devops project, a github service connection and a build for running the pipeline which has reference to this service connection. 
5. Then it creates a service principle and assigns it owner role on the ACR container registry. 
6. along with github service connection we also need a service connection that can push built images into ACR. ```create-service-connection``` command does that. 

To run all above steps there is a wrapping steps whih internally runs above tasks in order. to initiate that just run
```create-infrastructure```


### Making Deploy Pipeline work

To make the deploy pipeline work you have to configure three things (one timer setup). 
1. Enable continuous integration trigger 
2. add resources to environment. make sure name matches to what is specified in azure-pipelines.yaml. (currently only kubernetes.)
3. authorize resources when asked for.

### deleting the deployment

first you have to ask terraform to undo its changes and then deleting the whole resource group does the work. changing the order of these will crash terraform script as resources created by terraform are deleted without its knowledge. 
