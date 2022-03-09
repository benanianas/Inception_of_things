#! /bin/bash

sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install -y docker-ce

sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# install k3d
echo "installing k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#install kubectl
echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#create k8s cluster
sudo k3d cluster create -p "80:80@loadbalancer" abenani

#playground
kubectl create namespace dev
kubectl apply -f /vagrant/confs/playground.yaml -n dev
kubectl apply -f /vagrant/confs/ingress.yaml -n dev



# argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f /vagrant/confs/argocd.yaml



