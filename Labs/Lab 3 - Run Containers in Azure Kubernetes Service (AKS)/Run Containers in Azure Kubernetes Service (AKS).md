# Run Containers in Azure Kubernetes Service

## Objectives

In this lab, we will take the containers we created earlier and deploy them to Kubernetes running in Azure Kubernetes Service (AKS).

In this module, you will:

- Create an Azure Kubernetes Service cluster
- Create a service manifest that describes the application we will deploy

## Concepts

### Kubernetes

Kubernetes is an open-source container orchestrator, automating the processes required to keep complicated container-based
healthy, up-to-date, and running at scale.

_Do I need a container orchestrator?_ This is a good question to ask before embarking on the journey to learn and implement Kubernetes. As with any other technology, there is effort required to successfully use a complicated technology like Kubernetes
so it may not be necessary for every project. If you are running individual containers and simply need monitoring, scale-out and deployment automation, Azure App Service is a great choice and with less to learn and deploy.

### Azure Kubernetes Service (AKS)

Azure Kubernetes Service (AKS) is a managed deployment of Kuberentes, based on upstream open-source Kubernetes. AKS itself
is open-source under the [AKS-Engine](https://github.com/Azure/aks-engine) project.

While it is possibly (and not entirely uncommon) to run a Kubernetes cluster on Azure IaaS, AKS provides managed services for the
Kubernetes master nodes and customers are only charged for the worker nodes that run the conatiner workloads. There is no charge
for AKS beyond the compute and other infrastructure resources the services use.

## Exercise 1 - Create an AKS Cluster

## Exercise 2 - Add a manifests to control the application deployment

## Exercise 3 - Deploy the application to AKS

## Exercise 4 - Scale the application

## Exercise 5 - Deploy a rolling update
