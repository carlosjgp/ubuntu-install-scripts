#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

if ! cliExists google-chrome; then
  folder=$(download https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb chrome.deb)
  sudo apt install $folder/chrome.deb
fi

# Xtreme Download Manager
if ! cliExists xdman; then
  target=xdm.tar.xz
  folder=$(download https://github.com/subhra74/xdm/releases/download/7.2.11/xdm-setup-7.2.11.tar.xz $target)
  tar $folder/$target -C $folder
  sudo $folder/install.sh
fi

