RESOURCEGROUP:=CLIGroupForArm
LOCATION:=Central US
ARMSCRIPTPATH:=armDeployment
STORAGE_ACCOUNT_NAME:=armStorageTestSifter
CONTAINER_NAME:=arm-container-test-sifter

create-resource-group:
	echo Create Resource Group...
	az group create --name "$(RESOURCEGROUP)" --location "$(LOCATION)"

create-deployment:
	echo creating deployment...
	cd $(ARMSCRIPTPATH) && \
	az group deployment create \
		--name TestDeployment  \
		--resource-group "CLIGroupForArm" \
		--template-file armExample.json \
		--parameters storageAccountName='$(STORAGE_ACCOUNT_NAME)' containerName='$(CONTAINER_NAME)'

create-infrastructure: create-resource-group create-deployment
	echo creating infrastructe prior to Terraform Script...
