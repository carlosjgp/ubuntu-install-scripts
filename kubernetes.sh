#!/bin/bash

echo Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

echo Kubectl aliases
mkdir -p ~/aliases
curl -s https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases > ~/aliases/kubectl_aliases

echo Create Minikube with K8s
minikube start --memory 8192 --cpus 2

echo Install Helm
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

echo Install Istioctl
wget https://github.com/istio/istio/releases/download/1.0.6/istio-1.0.6-linux.tar.gz
tar -xvzf istio-1.0.6-linux.tar.gz
sudo mv istio-1.0.6/bin/istioctl /usr/local/bin/

echo Install fluxctl
sudo curl https://github.com/weaveworks/flux/releases/download/1.10.1/fluxctl_linux_amd64 -o /usr/local/bin/fluxctl
