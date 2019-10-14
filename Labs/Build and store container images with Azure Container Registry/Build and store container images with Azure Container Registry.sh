
#Create a Resource Group
az group create --name gsc-learn-deploy-acr-rg --location eastus

#Get a list of the different regions and their names
az account list-locations -o table

#Create ACR
ACR_NAME=gscnewacr
az acr create --resource-group gsc-learn-deploy-acr-rg --name $ACR_NAME --sku Premium

#Create new Docker file
FROM    node:9-alpine
ADD     https://raw.githubusercontent.com/Azure-Samples/acr-build-helloworld-node/master/package.json /
ADD     https://raw.githubusercontent.com/Azure-Samples/acr-build-helloworld-node/master/server.js /
RUN     npm install
EXPOSE  80
CMD     ["node", "server.js"]

#Build Container Image from Docker file
az acr build --registry $ACR_NAME --image helloacrtasks:v1 .

#Verify Image
az acr repository list --name $ACR_NAME --output table

#Enable Registry Admin Account
az acr update -n $ACR_NAME --admin-enabled true

#Retrieve Username and Password for Admin Account
az acr credential show --name $ACR_NAME

#Example output for Username and Password
{
  "passwords": [
    {
      "name": "password",
      "value": "wVHcyz1plDdxS6D6YRilJ6UYwbYNRU=f"
    },
    {
      "name": "password2",
      "value": "=gGYoEqv1Fy49VyqvhjqeAdbeiWYv79z"
    }
  ],
  "username": "gscnewacr"
}


#Deploy Container
az container create \
    --resource-group gsc-learn-deploy-acr-rg \
    --name acr-tasks \
    --image $ACR_NAME.azurecr.io/helloacrtasks:v1 \
    --registry-login-server $ACR_NAME.azurecr.io \
    --ip-address Public \
    --location eastus \
    --registry-username gscnewacr \
    --registry-password wVHcyz1plDdxS6D6YRilJ6UYwbYNRU=f

#Get IP Address of Container Instance
az container show --resource-group  gsc-learn-deploy-acr-rg --name acr-tasks --query ipAddress.ip --output table

#Create an ACR replica in another region
az acr replication create --registry $ACR_NAME --location westus

#Retrieve Container Image Replicas
az acr replication list --registry $ACR_NAME --output table

#Delete Resource Group
az group delete --name gsc-learn-deploy-acr-rg




