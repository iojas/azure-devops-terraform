RESOURCEGROUP:=CLIGroupForArm
LOCATION:=Central US
ARMSCRIPTPATH:=armDeployment
STORAGE_ACCOUNT_NAME:=armstoragetestsifter
CONTAINER_NAME:=armcontainertestsifter

STORAGE_CONTAINER:=armstoragecontainer

DEPLOYMENT_NAME:=TestDeployment

TF_BACKEND_PATH:=terraform-backend
STORAGE_KEY:=terraform.tfstate
PROJECT_NAME:=ARM Test Project

SUBSCRIPTION_ID = $(shell az account show | jq -r '.id')
SUBSCRIPTION_NAME = $(shell az account show | jq -r '.name')
TENANT_ID = $(shell az account get-access-token --query tenant --output tsv)
PROJECT_ID = $(shell az devops project show --project  "$(PROJECT_NAME)" --organization ${AZDO_ORG_SERVICE_URL} | jq -r '.id' )


# Creates resource group in Azure region
create-resource-group:
	echo Create Resource Group...
	az group create --name "$(RESOURCEGROUP)" --location "$(LOCATION)"

# creates a storage account within a resource group and create a storage container within it. 
create-deployment:
	echo creating deployment...
	cd $(ARMSCRIPTPATH) && \
	az group deployment create \
		--name $(DEPLOYMENT_NAME)  \
		--resource-group "$(RESOURCEGROUP)" \
		--template-file armExample.json \
		--parameters storageAccountName='$(STORAGE_ACCOUNT_NAME)' containerName='$(STORAGE_CONTAINER)'

# Once storage account and container is set, We can leverage them to set as a backend for Terraform scripts
set-terraform-backend:
	cd $(TF_BACKEND_PATH) && \
	python backendCreator.py $(RESOURCEGROUP) $(STORAGE_ACCOUNT_NAME) $(STORAGE_CONTAINER) $(STORAGE_KEY) && \
	terraform init && \
	terraform apply -auto-approve 

# Now that terraform backend has been set we can go ahead and run rest of terraform deployment.
terraform-deploy:
	terraform apply -var resource_group_name=$(RESOURCEGROUP) -var storage_account_name=$(STORAGE_ACCOUNT_NAME) -var container_name=$(CONTAINER_NAME) -auto-approve 

create-service-principle:
	@echo creating service principle and assigning roles
	sh spcreate.sh $(CONTAINER_NAME)

create-service-connection:
	@echo creating config file
	python configCreator.py $(CONTAINER_NAME) $(SUBSCRIPTION_ID) $(RESOURCEGROUP) $(TENANT_ID) $(SP_APP_ID) $(PROJECT_ID) $(PROJECT_NAME) $(SUBSCRIPTION_NAME)
	@echo now deploying
	az devops service-endpoint create --service-endpoint-configuration config.json --organization ${AZDO_ORG_SERVICE_URL} --project "$(PROJECT_NAME)"

# runs different make targets in sequence.
create-infrastructure: create-resource-group create-deployment set-terraform-backend terraform-deploy create-service-principle create-service-connection
	echo Created infrastructure ...

delete-deployment:
	terraform destroy -var resource_group_name=$(RESOURCEGROUP) -var storage_account_name=$(STORAGE_ACCOUNT_NAME) -var container_name=$(CONTAINER_NAME)  -auto-approve 
	az group delete --name $(RESOURCEGROUP) --yes

