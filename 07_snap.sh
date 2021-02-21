#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

sudo snap install \
    skype \
    vlc \
    zoom-client

