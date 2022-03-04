#!/bin/sh
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - \
kubectl create -f /vagrant/app-one.yaml \
kubectl create -f /vagrant/service-one.yaml