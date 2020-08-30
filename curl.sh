#!/bin/bash

# Go to home
cd ~

if ! which fzf &>/dev/null; then
  echo Install fuzzy finder
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

if ! test -d ~/.nerd-fonts; then
  echo Install Nerd fonts
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
  ~/.nerd-fonts/install.sh
fi

if ! which go &> /dev/null; then
  VERSION=1.15
  OS=linux
  ARCH=amd64
  wget https://golang.org/dl/go$VERSION.$OS-$ARCH.tar.gz
  sudo tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
  rm go$VERSION.$OS-$ARCH.tar.gz
fi

echo Configure git
curl -s https://gist.githubusercontent.com/adeekshith/cd4c95a064977cdc6c50/raw/bb54233668f5c56c1a19f0ce8faf3a89eff8c678/.git-commit-template.txt > ~/.gitmessage
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/git/.gitconfig > ~/.gitconfig

if ! test -d ~/.oh-my-zsh; then
  echo Install Oh! My zsh
  curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/zsh/.zshrc > ~/.zshrc
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if ! test -d ~/.oh-my-zsh/custom/themes/powerlevel9k; then
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

if ! test -d ~/.oh-my-zsh/plugins/zsh-syntax-highlighting; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
