RESOURCEGROUP:=CLIGroupForArm
LOCATION:=Central US
ARMSCRIPTPATH:=armDeployment
STORAGE_ACCOUNT_NAME:=armstoragetestsifter
CONTAINER_NAME:=arm-container-test-sifter

DEPLOYMENT_NAME:=TestDeployment

TF_BACKEND_PATH:=terraform-backend
STORAGE_KEY:=terraform.tfstate

create-resource-group:
	echo Create Resource Group...
	az group create --name "$(RESOURCEGROUP)" --location "$(LOCATION)"

create-deployment:
	echo creating deployment...
	cd $(ARMSCRIPTPATH) && \
	az group deployment create \
		--name $(DEPLOYMENT_NAME)  \
		--resource-group "CLIGroupForArm" \
		--template-file armExample.json \
		--parameters storageAccountName='$(STORAGE_ACCOUNT_NAME)' containerName='$(CONTAINER_NAME)'

set-terraform-backend:
	cd $(TF_BACKEND_PATH) && \
	python backendCreator.py $(RESOURCEGROUP) $(STORAGE_ACCOUNT_NAME) $(CONTAINER_NAME) $(STORAGE_KEY) && \
	terraform init && \
	terraform apply -auto-approve 

terraform-deploy:
	terraform apply -var resource_group_name=$(RESOURCEGROUP) -var storage_account_name=$(STORAGE_ACCOUNT_NAME)


create-infrastructure: create-resource-group create-deployment set-terraform-backend terraform-deploy
	echo Created infrastructure ...

delete-deployment:
	az group delete --name $(RESOURCEGROUP) --yes

# delete-project:
