#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/_functions.sh

sudo apt update
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git \
  zsh \
  jq \
  unzip \
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
  x264 x265 #\
  #exa

# AppImage Launcher
if ! cliExists AppImageLauncher; then
  addPPA ppa:appimagelauncher-team/stable
  sudo apt install -y \
    appimagelauncher
fi

# Set ZSH as default SHELL
[ ! "$SHELL" = $(which zsh) ] && chsh -s $(which zsh)

echo Clean up packages
sudo apt autoremove -y
