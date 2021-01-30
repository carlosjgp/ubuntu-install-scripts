#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

if ! cliExists keybase; then
  folder=$(download https://prerelease.keybase.io/keybase_amd64.deb)
  sudo apt install $folder/keybase_amd64.deb
fi
