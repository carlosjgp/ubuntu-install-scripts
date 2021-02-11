#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

sudo apt-get install libpam-u2f

mkdir -p ~/.config/Yubico

# TODO: WAIT FOR INPUT
# "INSERT YUBIKEY"
#pamu2fcfg >> ~/.config/Yubico/u2f_keys

# TODO: WAIT AGAIN
# "INSERT BACKUP YUBIKEY"
#pamu2fcfg >> ~/.config/Yubico/u2f_keys

# Yubikey PAM
# https://developers.yubico.com/yubico-pam/
sudo add-apt-repository ppa:yubico/stable
sudo apt-get update
sudo apt-get install libpam-yubico
# check
# /usr/share/doc/libpam-yubico/README.Debian
