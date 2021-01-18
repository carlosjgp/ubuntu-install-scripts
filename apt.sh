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
  ffmpeg \
  x264 x265 \
  exa

chsh -s $(which zsh)

# We are using python3 only :D
# is this the best way of doing this?
# if ! which python &>/dev/null; then
#   sudo ln -s /usr/bin/python3 /usr/bin/python
# fi
# if ! which pip &>/dev/null; then
#   sudo ln -s /usr/bin/pip3 /usr/bin/pip
# fi

if ! which google-chrome &>/dev/null; then
  echo Install Google Chrome
  wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
  sudo apt install ./chrome.deb
  rm ./chrome.deb
fi

echo Clean up packages
sudo apt autoremove -y
