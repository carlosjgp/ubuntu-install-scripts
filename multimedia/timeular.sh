#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

mkdir -p ~/Applications

if ! fileExists ~/Applications/Timeular.AppImage; then
  url=https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular.AppImage
  folder=$(download $url Timeular.AppImage)
  chmod a+x $folder/Timeular*.AppImage
  mv $folder/Timeular.AppImage ~/Applications/
fi
