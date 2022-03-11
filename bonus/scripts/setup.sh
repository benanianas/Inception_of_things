#! /bin/bash

echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" >/dev/null 2>&1
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl >/dev/null 2>&1
mkdir .kube
apt-get update
apt-get install sshpass
sshpass -p "anas" scp -o StrictHostKeyChecking=accept-new anas@10.12.12.69:/home/anas/config . >/dev/null 2>&1
mv config .kube