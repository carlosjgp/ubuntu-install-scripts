#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

# Terraform and Terrqgrunt
## terraenv
if ! cliExists terraenv; then
  wget https://github.com/aaratn/terraenv/releases/latest/download/terraenv_linux_x64.tar.gz
  tar -xvzf terraenv_linux_x64.tar.gz
  rm terraenv_linux_x64.tar.gz
  sudo mv terraenv /usr/local/bin/terraenv
fi
if ! rg TERRA_PATH ~/.zshrc &>/dev/null; then
  echo 'export TERRA_PATH="$HOME/.terraenv"' >> ~/.zshrc
fi
## TODO: needs to be fixed with a PR
## Install Terraform
if ! cliExists terraform; then
  sudo TERRA_PATH="/home/carlosjgp/.terraenv" terraenv terraform install $(terraenv terraform list remote | tail -1)
fi
if ! cliExists terragrunt; then
  ## Install
  sudo TERRA_PATH="/home/carlosjgp/.terraenv" terraenv terragrunt install $(terraenv terragrunt list remote | tail -1)
fi

# Install tfsec
if ! cliExists tfsec; then
  downloadBinary $(latestGithubReleaseURI liamg/tfsec tfsec-linux-amd64) tfsec
  downloadBinary $(latestGithubReleaseURI liamg/tfsec tfsec-checkgen-linux-amd64) tfsec-checkgen
fi

# Install TFLint
if ! cliExists tflint; then
  tflintUri=$(latestGithubReleaseURI terraform-linters/tflint _linux_amd64.zip)
  folder=$(download $tflintUri tflint.zip)
  unzip $folder/tflint.zip -d $folder
  sudo mv $folder/tflint /usr/local/bin
fi

# Install run
if ! cliExists run; then
  runUri=$(latestGithubReleaseURI TekWizely/run _linux_amd64.tar.gz)
  folder=$(download $runUri run.tar.gz)
  sudo tar -C /usr/local/bin/ -xzf $folder/run.tar.gz
fi

# Install sops
if ! cliExits sops; then
  downloadBinary $(latestGithubReleaseURI mozilla/sops linux) sops
fi

# Install trivy
if ! cliExists trivy; then
  sudo apt-get install wget apt-transport-https gnupg lsb-release
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
  echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
  sudo apt-get update
  sudo apt-get install trivy
fi

if ! cliExists pre-commit; then
  # Install pre-commit git hook
  pip install --upgrade pre-commit
fi

if ! cliExists aws; then
  info Install AWS CLI
  # https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  rm awscliv2.zip
  sudo ./aws/install
fi

if ! cliExists aws-vault; then
  downloadBinary $(latestGithubReleaseURI 99designs/aws-vault aws-vault-linux-amd64) aws-vault
fi
