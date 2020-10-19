#!/bin/bash

./apt.sh

./curl.sh

cp ./zsh/.zshrc ~/.zshrc
cp ./zsh/.p10k.zsh

./kubernetes.sh

. ~/.zshrc

./dev-tools.sh

sudo snap install code --classic

sudo snap install slack --classic

sudo snap install vlc
