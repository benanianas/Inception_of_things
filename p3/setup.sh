#!/vin/bash

# install k3d
echo "installing k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


#install kubectl
echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#create k8s cluster
k3d cluster create abenani 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml\



# k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "8080:80@loadbalancer" --agents 2 abenani

kubectl create namespace dev

kubectl apply -f playground.yaml -n dev

kubectl apply -f ingress.yaml -n dev

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
