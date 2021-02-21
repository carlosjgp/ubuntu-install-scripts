#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh


if ! cliExists kubectl; then
  echo Install kubectl
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
fi

echo"Install Garden.io CLI"
curl -sL https://get.garden.io/install.sh | bash

echo"Install kubectx and kubens required for k9s"
if ! cliExists kubectx; then
  getLatestGithubTarGZ() ahmetb/kubectx kubectx_*_linux_arm64.tar.gz kubectx
fi
if ! cliExists kubens; then
  getLatestGithubTarGZ() ahmetb/kubectx kubens_*_linux_arm64.tar.gz kubens
fi
if ! cliExists k9s; then
  getLatestGithubTarGZ() derailed/k9s k9s_Linux_x86_64.tar.gz k9s
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
  mv ./kind $HOME/kind
  mkdir -p $ZSH/completions/
  kind completion zsh > $ZSH/completions/_kind
fi

if ! cliExists dive; then
  echo Install Dive
  getLatestGithubDeb wagoodman/dive linux_amd64.deb
  # dive_deb=$(curl -sL https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[].browser_download_url' | grep linux_amd64.deb)
  # wget -O ./dive.deb $dive_deb
  # sudo apt install ./dive.deb
  # rm ./dive.deb
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
