#! /bin/bash

echo "installing kubectl"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" >/dev/null 2>&1
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl > /dev/null 2>&1
mkdir .kube
sudo apt-get update
sudo apt-get install sshpass
sudo sshpass -p "anas" scp -o StrictHostKeyChecking=accept-new anas@10.12.12.69:/home/anas/config . >/dev/null 2>&1
mv config .kube
kubectl create namespace gitlab
kubectl apply -f /vagrant/confs/gitlab.yaml -n gitlab