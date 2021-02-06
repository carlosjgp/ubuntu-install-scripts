#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

sudo snap install \
    vlc \
    zoom-client

