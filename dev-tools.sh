#!/bin/bash

NODEJS_VERSION=14
NVM_VERSION=0.36.0
GOSS_VERSION=v0.3.13
PACKER_VERSION=1.5.5
PACKER_GOSS_VERSION=v2.0.0
RUN_VERSION=0.7.1
TERRAFORM_VERSION=0.12.28
TERRAGRUNT_VERSION=0.22.3
TFSEC_VERSION=v0.25.0
TRIVY_VERSION=v0.9.2

# NodeJS
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

# NodeJS version management
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

npm install -g avn avn-nvm avn-n
avn setup

# PreCommit checks
pip install --upgrade --no-cache-dir \
  pre-commit

# Install Packer
curl -sLo /tmp/packer.zip \
  https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
sudo unzip -d /usr/local/bin/ /tmp/packer.zip
rm /tmp/packer.zip

# Install terraenv
curl -sLo terraenv_linux_x64.tar.gz https://github.com/aaratn/terraenv/releases/latest/download/terraenv_linux_x64.tar.gz
    tar -xvzf terraenv_linux_x64.tar.gz
sudo mv terraenv /usr/local/bin/terraenv
rm terraenv_linux_x64.tar.gz

# Install tfenv
git clone https://github.com/tfutils/tfenv.git --depth=1 $TFENV_ROOT
rm -rf $TFENV_ROOT/.git

# Install Terraform
terraenv terraform install ${TERRAFORM_VERSION}

# Install Terragrunt
terraenv terragrunt install ${TERRAGRUNT_VERSION}

# Install tfsec
sudo curl -sLo /usr/local/bin/tfsec https://github.com/liamg/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64
sudo chmod +x /usr/local/bin/tfsec

# Install TFLint
curl -sL "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip
unzip tflint.zip
sudo mv tflint /usr/local/bin
rm tflint.zip

# Install goss
sudo curl -sLo /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64
sudo chmod +x /usr/local/bin/goss

# Install packer-goss
curl -sLo packer-provisioner-goss.tar.gz https://github.com/YaleUniversity/packer-provisioner-goss/releases/download/${PACKER_GOSS_VERSION}/packer-provisioner-goss-${PACKER_GOSS_VERSION}-linux-amd64.tar.gz
tar -xvzf packer-provisioner-goss.tar.gz
mkdir -p ~/.packer.d/plugins
mv packer-provisioner-goss ~/.packer.d/plugins
rm packer-provisioner-goss.tar.gz

# Install run
curl -sLo /tmp/run.tar.gz \
https://github.com/TekWizely/run/releases/download/v${RUN_VERSION}/run_${RUN_VERSION}_linux_amd64.tar.gz
sudo tar -C /usr/local/bin/ -xzf /tmp/run.tar.gz

# Install yq
sudo curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64
sudo chmod 755 /usr/local/bin/yq

# Install sops
sudo curl -sLo /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux
sudo chmod 755 /usr/local/bin/sops

# Install trivy
sudo curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin ${TRIVY_VERSION}
