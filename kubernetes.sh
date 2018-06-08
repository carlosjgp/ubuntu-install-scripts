#!/bin/bash

K8S_VERSION=v1.9.6
HELM_VERSION=v2.8.2

echo Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

echo Kubectl aliases
mkdir -p ~/aliases
curl -s https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases > ~/aliases/kubectl_aliases

echo Create Minikube with K8s 1.9.6
minikube start --memory 8192 --cpus 2 --kubernetes-version "$K8S_VERSION"

echo Install Helm
export DESIRED_VERSION="$HELM_VERSION"
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
