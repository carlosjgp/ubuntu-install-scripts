#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/_functions.sh

sudo apt update
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  wget \
  apt-transport-https \
  gnupg \
  lsb-release \
  gimp \
  git \
  git-extras \
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
  vim \
  zlib1g-dev \
  libcups2-dev \
  ffmpeg \
  x264 x265 \
  xclip #\
  # Only on Ubuntu 21.04+
  #exa

# ReMarkable
sudo apt install -y \
  libqt5xml5 \
  libqt5quick5 \
  libkf5archive5 \
  libqt5websockets5 \
  libqt5concurrent5 \
  qtquickcontrols2-5-dev \
  qml-module-qtquick-controls \
  qml-module-qtquick-controls2 \
  qml-module-qtquick-dialogs \
  qml-module-qt-labs-platform

if ! cliExists reMarkable; then
  installDeb https://nain.oso.chalmers.se/oso/ubuntu/pool/contrib/r/remarkable-linux-client/remarkable-linux-client_1.0.1-0-18.04_amd64.deb
fi

if ! cliExists google-chrome; then
  # Google Chrome
  installDeb https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
fi

if ! cliExists keybase; then
  # Keybase
  installDeb https://prerelease.keybase.io/keybase_amd64.deb
fi

if ! cliExists xdman; then
  # Xtreme Download Manager
  folder=$(downloadTar https://github.com/subhra74/xdm/releases/download/7.2.11/xdm-setup-7.2.11.tar.xz)
  sudo $folder/install.sh
fi

if ! cliExists AppImageLauncher; then
  # AppImage Launcher
  addPPA ppa:appimagelauncher-team/stable
  sudo apt install -y \
    appimagelauncher
fi

if ! fileExists $HOME/Applications/Timeular.AppImage; then
  # Timeular
  downloadAppImage https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular.AppImage
fi

# Set ZSH as default SHELL
[ ! "$SHELL" = $(which zsh) ] && chsh -s $(which zsh)

echo Clean up packages
sudo apt autoremove -y

shutdown -r 0
