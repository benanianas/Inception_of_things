#! /bin/bash

ip addr add 10.12.12.69/16 dev enp0s3

# install docker
echo "installing docker"

apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
apt-get install -y docker-ce


# install k3d
echo "installing k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#install kubectl
echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#create k8s cluster
k3d cluster create --api-port 10.12.12.69:6443 -p "80:80@loadbalancer" abenani

k3d kubeconfig get abenani > config

#playground
kubectl create namespace dev
kubectl apply -f playground.yaml -n dev
kubectl apply -f ingress.yaml -n dev



# argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd.yaml