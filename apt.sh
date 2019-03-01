#!/bin/bash

# Dependency to be able to add repositories
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git-core \
  zsh \
  jq \
  libgit2-dev \
  cmake \
  httpie \
  virtualbox \
  virtualbox-ext-pack \
  terminator \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  cargo

# Install AWS CLI
pip install --upgrade awscli

# https://github.com/BurntSushi/ripgrep#installation
echo Install fancy search commands
sudo snap install rg

echo Install exa
git clone  https://github.com/ogham/exa /tmp/exa
cd /tmp/exa
sudo su
make install
exit
pushd

echo Install Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# Edege is required for Ubuntu 18.04
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER

echo Clean up packages
sudo apt autoremove -y
