#!/bin/bash

# Go to home
cd ~

echo Install GoLang
wget -q -O - https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz | tar xz -C ~/ &

echo Configure git
curl -s https://gist.githubusercontent.com/adeekshith/cd4c95a064977cdc6c50/raw/bb54233668f5c56c1a19f0ce8faf3a89eff8c678/.git-commit-template.txt > ~/.gitmessage
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/git/.gitconfig > ~/.gitconfig

echo Install Oh! My zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# Not needed if I'm keeping the .zshrc file
# sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' ~/.zshrc
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/zsh/.zshrc > ~/.zshrc

# Install Powerline fonts
# clone
#git clone https://github.com/powerline/fonts.git --depth=1
# install
#cd fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
cd nerd-fonts
./install.sh

echo Install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo Import Vim configuration
curl -s https://raw.githubusercontent.com/milesbxf/dotfiles/master/nvim/.vimrc > ~/.vimrc
curl -s https://raw.githubusercontent.com/milesbxf/dotfiles/master/nvim/init.vim > ~/init.vim
