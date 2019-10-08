#Use the az acr login command to authenticate and cache the credentials for your registry.
az acr login --name gsccontainerreg

#Clone sample to local repository
git clone https://github.com/Azure-Samples/acr-helloworld.git
cd acr-helloworld

#get the registry's login server with the az acr show command.
az acr show --name gsccontainerreg --query "{acrLoginServer:loginServer}" --output table

#update the ENV DOCKER_REGISTRY line with the FQDN of your registry's login server
ENV DOCKER_REGISTRY gsccontainerreg.azurecr.io

#Use docker build to create the container image after Dockerfile has been updated
docker build . -f ./AcrHelloworld/Dockerfile -t gsccontainerreg.azurecr.io/acr-helloworld:v1

#Use docker images to see the built and tagged image
docker images

#use the docker push command to push the acr-helloworld image to your registry
docker push gsccontainerreg.azurecr.io/acr-helloworld:v1
