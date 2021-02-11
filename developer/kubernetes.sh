#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

if ! cliExists docker; then
  echo Install Docker CE
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  # Edge is required for Ubuntu 18.04
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     edge"
  sudo apt update
  sudo apt install -y docker-ce
  sudo usermod -aG docker $USER
fi

if ! cliExists kubectl; then
  echo Install kubectl
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
fi

if ! cliExists minikube; then
  echo Install Minikube
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  chmod +x minikube
  sudo mv minikube /usr/local/bin/
  minikube start --memory=8g
  minikube stop
fi

echo Kubectl aliases
mkdir -p ~/aliases
curl -s https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases > ~/aliases/kubectl_aliases

if ! cliExists helm; then
  echo Install Helm
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

if ! cliExists kind; then
  echo Install KinD
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/$(curl -u $GITHUB_USER:$GITHUB_TOKEN -sL https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq -r '.tag_name')/kind-$(uname)-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/bin/kind
  mkdir -p $ZSH/completions/
  kind completion zsh > $ZSH/completions/_kind
fi

if ! cliExists dive; then
  echo Install Dive
  dive_deb=$(curl -sL https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[].browser_download_url' | grep linux_amd64.deb)
  wget -O ./dive.deb $dive_deb
  sudo apt install ./dive.deb
  rm ./dive.deb
fi

if ! cliExists dockle; then
  echo Install Dockle
  dockle_deb=$(curl -sL https://api.github.com/repos/goodwithtech/dockle/releases/latest | jq -r '.assets[].browser_download_url' | grep -i Linux-64bit.deb)
  wget -O ./dockle.deb $dockle_deb
  sudo apt install ./dockle.deb
  rm ./dockle.deb
fi


if ! cliExists kubectl-krew; then
(
  cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" &&
  "$KREW" install krew
)
fi

if ! rg KREW_ROOT ~/.zshrc &>/dev/null ; then
  echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc
fi


if ! rg KUBE_EDITOR ~/.zshrc &>/dev/null; then
  echo 'export KUBE_EDITOR=vim' >> ~/.zshrc
fi
