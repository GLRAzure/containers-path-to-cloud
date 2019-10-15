# get a list of all API object types
kubectl api-resources

kubectl get nodes 
kubectl get no 

kubectl get namespace

kubectl get pods

kubectl get deployment

kubectl get 

# deploy deployment
kubectl apply -f ./deployment.yaml --record



# set a default namespace
kubectl config set-context --current --namespace=<your-namespace>