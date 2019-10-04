
#Create a Resource Group
az group create --name gsc-learn-deploy-aci-rg --location eastus

#Create Container Instance
DNS_NAME_LABEL=aci-demo-$RANDOM
az container create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name mycontainer \
  --image microsoft/aci-helloworld \
  --ports 80 \
  --dns-name-label $DNS_NAME_LABEL \
  --location eastus

#Check Container Status
az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name mycontainer \
  --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
  --out table



#Create and Start Container to assess Restart Behavior
az container create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name mycontainer-restart-demo \
  --image microsoft/aci-wordcount:latest \
  --restart-policy OnFailure \
  --location eastus

#Check Container Status
  az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name mycontainer-restart-demo \
  --query containers[0].instanceView.currentState.state

#View Container Logs
az container logs \
  --resource-group gsc-learn-deploy-aci-rg \
  --name mycontainer-restart-demo


#Deploy CosmosDB Instance
COSMOS_DB_NAME=aci-cosmos-db-$RANDOM
COSMOS_DB_ENDPOINT=$(az cosmosdb create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name $COSMOS_DB_NAME \
  --query documentEndpoint \
  --output tsv)

#Get CosmosDB Connection Key
COSMOS_DB_MASTERKEY=$(az cosmosdb keys list \
  --resource-group gsc-learn-deploy-aci-rg \
  --name $COSMOS_DB_NAME \
  --query primaryMasterKey \
  --output tsv)

#Deploy Container that uses CosmosDB
az container create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo \
  --image microsoft/azure-vote-front:cosmosdb \
  --ip-address Public \
  --location eastus \
  --environment-variables \
    COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
    COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY

#Get Container IP Address
az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo \
  --query ipAddress.ip \
  --output tsv


#Display Container Environment Variables
az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo \
  --query containers[0].environmentVariables


#Create Second Container using Secure Environment Variables
az container create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo-secure \
  --image microsoft/azure-vote-front:cosmosdb \
  --ip-address Public \
  --location eastus \
  --secure-environment-variables \
    COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
    COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY

#Display Environment Variables
az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo-secure \
  --query containers[0].environmentVariables




#Create Storage Account
STORAGE_ACCOUNT_NAME=mystorageaccount$RANDOM
az storage account create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --location eastus

#Place Stroage Account Connection String into Environment Variable
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
  --resource-group gsc-learn-deploy-aci-rg \
  --name $STORAGE_ACCOUNT_NAME \
  --output tsv)

#Create File Share
az storage share create --name aci-share-demo

#Get Storage Account Key
STORAGE_KEY=$(az storage account keys list \
  --resource-group gsc-learn-deploy-aci-rg \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query "[0].value" \
  --output tsv)

#Create Container and Mount File Share
az container create \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo-files \
  --image microsoft/aci-hellofiles \
  --location eastus \
  --ports 80 \
  --ip-address Public \
  --azure-file-volume-account-name $STORAGE_ACCOUNT_NAME \
  --azure-file-volume-account-key $STORAGE_KEY \
  --azure-file-volume-share-name aci-share-demo \
  --azure-file-volume-mount-path /aci/logs/

#Get Container IP Address
az container show \
  --resource-group gsc-learn-deploy-aci-rg \
  --name aci-demo-files \
  --query ipAddress.ip \
  --output tsv

#Display Files
az storage file list -s aci-share-demo -o table

#Download File
az storage file download -s aci-share-demo -p 1570120172754.txt


#Delete Resource Group
az group delete --name gsc-learn-deploy-aci-rg




