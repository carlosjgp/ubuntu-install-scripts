#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

if ! cliExists reMarkable; then
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

  url=https://nain.oso.chalmers.se/oso/ubuntu/pool/contrib/r/remarkable-linux-client/remarkable-linux-client_1.0.1-0-18.04_amd64.deb
  folder=$(download $url remarkable.deb)
  sudo dpkg -i $folder/remarkable.deb
fi
