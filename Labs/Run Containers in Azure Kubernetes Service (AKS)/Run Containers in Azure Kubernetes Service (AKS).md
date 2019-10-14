# Run Containers in Azure Kubernetes Service

## Objectives

In this lab, we will take the containers we created earlier and deploy them to Kubernetes running in Azure Kubernetes Service (AKS).

In this module, you will:

- Create an Azure Kubernetes Service cluster
- Create a service manifest that describes the application we will deploy

## Prerequisites

This lab has some additional requirements from the prior labs because AKS needs to be able to provision Azure resources
on its own.

### Azure AD Service Principal 
In Azure, services and applications can be permitted to run provisioning and management operations through Azure AD
[Service Principal Names (SPNs)](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). SPNs are basically user accounts for applications. The application authenticates
to the Azure Resource Manager using this SPN Azure AD account, then uses permissions assigned to that account to perform
actions in Azure.

During its deployment, AKS can create a SPN that is then assigned to the service and granted the appropriate permissions.
If your Azure account is connected with an Azure AD instance managed by your organization, you may not have the permissions
to create SPNs in the organization Azure AD. A SPN can be created in advance by an authorized Azure AD administrator then
used for the AKS deployment. The steps for deploying this way are slightly different, but once deployed, the AKS cluster will
run the same way. 

## Concepts

### Kubernetes

Kubernetes is an open-source container orchestrator, automating the processes required to keep complicated container-based
healthy, up-to-date, and running at scale.

_Do I need a container orchestrator?_ This is a good question to ask before embarking on the journey to learn and implement Kubernetes. As with any other technology, there is effort required to successfully use a complicated technology like Kubernetes
so it may not be necessary for every project. If you are running individual containers and simply need monitoring, scale-out and deployment automation, Azure App Service is a great choice and with less to learn and deploy.

### Azure Kubernetes Service (AKS)

Azure Kubernetes Service (AKS) is a managed deployment of Kuberentes, based on upstream open-source Kubernetes. AKS itself
is open-source under the [AKS-Engine](https://github.com/Azure/aks-engine) project.

While it is possibly (and not entirely uncommon) to run a Kubernetes cluster on Azure IaaS, AKS provides managed services
for the Kubernetes master nodes and customers are only charged for the worker nodes that run the container workloads. There
is no charge for AKS beyond the compute and other infrastructure resources the services use.

## Exercise 1 - Create an AKS Cluster

### 1. Create a Resource Group for AKS

First, we'll create a new Resource Group where we will deploy AKS. Using the Cloud Shell as in prior steps, create a 
Resource Group.

```console
$ az group create --name learn-aks --location <choose-a-location>
```

### 2. Create the AKS Cluster

The `az aks create` command has many optional parameters that are useful for creating production clusters. For this
lab we will keep it simple and use defaults and automatic settings for most. (This operation will take about 5 minutes.)

```console
$ az aks create --resource-group learn-aks --name myAKSCluster --node-count 1 --enable-addons monitoring --generate-ssh-keys
```

When this operation completes, the result is some cluster information including a cluster FQDN, the Kubernetes version deployed
and the status of the cluster:

```json
{
 ...
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "count": 1,
      "enableAutoScaling": null,
      "enableNodePublicIp": null,
      "maxCount": null,
      "maxPods": 110,
      "minCount": null,
      "name": "nodepool1",
      "nodeTaints": null,
      "orchestratorVersion": "1.13.10",
      "osDiskSizeGb": 100,
      "osType": "Linux",
      "provisioningState": "Succeeded",
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "type": "AvailabilitySet",
      "vmSize": "Standard_DS2_v2",
      "vnetSubnetId": null
    }
  ],
  "apiServerAccessProfile": null,
  "dnsPrefix": "<your-cluster>-<your-rg>-<random>",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "fqdn": "<your-cluster-name>.hcp.eastus.azmk8s.io",
  "id": "...",
  "identity": null,
  "kubernetesVersion": "1.13.10",
  "location": "eastus",
  "maxAgentPools": 1,
  "name": "<your-cluster-name",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "loadBalancerProfile": null,
    "loadBalancerSku": "Basic",
    "networkPlugin": "kubenet",
    "networkPolicy": null,
    "podCidr": "10.244.0.0/16",
    "serviceCidr": "10.0.0.0/16"
  },
  "nodeResourceGroup": "MC_<your-resource-group>_myAKSCluster_eastus",
  "provisioningState": "Succeeded",
  "resourceGroup": "learn-aks",
  ...
}
```

If you go back to your subscription, you'll notice another new Resource Group starting with 'MC_' followed by your AKS resource group name then the region name. This is the Resource Group that AKS will manage and use to deploy VMs, networking and other
IaaS resource for your cluster. Take a look in that Resource Group and explore what it created.

### 3. Set up the Kuberntes CLI and connect to your cluster

Our Kubernetes cluster is now running but we don't have a way to communicate with it yet. The Kubernetes CLI (called `kubectl`) is already installed in Cloud Shell. If you need to install it in case you're running locally or on a VM, the following command 
will install it: 

```console
# not needed if using Azure Cloud Shell (kubectl is pre-installed there)
$ az aks install-cli
```

Now that we have kubectl, we can get our cluster credentials using the cluster name used when creating the cluster: 

```console
$ az aks get-credentials --resource-group learn-aks --name <your-cluster-name>
Merged "myAKSCluster" as current context in /home/andrej/.kube/config
```

Next we can use kubectl to see ur worker nodes:

```console
$ kubectl get nodes
NAME                       STATUS   ROLES   AGE   VERSION
aks-nodepool1-26513128-0   Ready    agent   14m   v1.13.10
```

We have one node that's ready to go. Let's get some code deployed!

## Exercise 2 - Add a manifests to control the application deployment


## Exercise 3 - Deploy the application to AKS

## Exercise 4 - Scale the application

## Exercise 5 - Deploy a rolling update
