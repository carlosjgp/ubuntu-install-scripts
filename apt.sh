#!/bin/bash

set -eo pipefail

# Dependency to be able to add repositories
# https://github.com/BurntSushi/ripgrep#installation
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git \
  zsh \
  jq \
  libgit2-dev \
  cmake \
  httpie \
  virtualbox \
  virtualbox-ext-pack \
  terminator \
  python3-dev \
  python3-pip \
  build-essential \
  libssl-dev \
  libffi-dev \
  ripgrep \
  libgirepository1.0-dev \
  libcairo2-dev \
  build-essential \
  libssl-dev \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  libcups2-dev \
  cargo

chsh -s $(which zsh)

# We are using python3 only :D
if ! which python &>/dev/null; then
  sudo ln -s /usr/bin/python3 /usr/bin/python
fi
if ! which pip &>/dev/null; then
  sudo ln -s /usr/bin/pip3 /usr/bin/pip
fi

if ! which aws &>/dev/null; then
  # Install AWS CLI
  pip install --upgrade awscli
fi

if ! which exa &>/dev/null; then
  echo Install exa
  #  https://github.com/ogham/exa
  cargo install exa
  sudo cp ~/.cargo/bin/exa /usr/bin/exa
  sudo chmod 777 /usr/bin/exa
 fi

if ! which docker &>/dev/null; then
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
fi

if ! which google-chrome &>/dev/null; then
  echo Install Google Chrome
  wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
  sudo apt install ./chrome.deb
  rm ./chrome.deb
fi

if ! which go &>/dev/null; then
  echo Install go
  sudo snap install go --classic
fi

echo Clean up packages
sudo apt autoremove -y
