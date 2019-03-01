#!/bin/bash

# Go to home
cd ~

echo Install GoLang
wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar xz -C /tmp go1.12.linux-amd64.tar.gz
sudo mv /tmp/go /usr/local/go

echo Install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo Install Nerd fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
~/.nerd-fonts/install.sh

echo Configure git
curl -s https://gist.githubusercontent.com/adeekshith/cd4c95a064977cdc6c50/raw/bb54233668f5c56c1a19f0ce8faf3a89eff8c678/.git-commit-template.txt > ~/.gitmessage
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/git/.gitconfig > ~/.gitconfig

echo Install Oh! My zsh
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/zsh/.zshrc > ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
