#!/bin/bash

# Dependency to be able to add repositories
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo Add more APT repos
# Oracle JDK 8
sudo add-apt-repository ppa:webupd8team/java -y
# Neovim
sudo apt-add-repository ppa:neovim-ppa/stable -y

echo Refresh repos
sudo apt update

echo Upgrade packages first
sudo apt upgrade -y

echo Install a lot of packages
sudo apt install -y \
  git-core \
  zsh \
  jq \
  libgit2-dev \
  cmake \
  httpie \
  virtualbox \
  virtualbox-ext-pack \
  terminator

echo Install NeoVim
sudo apt install -y \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  neovim

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

echo Install Java 8
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt install oracle-java8-installer oracle-java8-set-default -y

# https://github.com/BurntSushi/ripgrep#installation
echo Install fancy search commands
sudo snap install rg

# Ubuntu 18.04
# https://github.com/ogham/exa#installation
#echo "Install cargo & exa"
#sudo snap install cargo
#cargo install exa

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
sudo apt-get install docker-ce

echo Clean up packages
sudo apt autoremove -y
