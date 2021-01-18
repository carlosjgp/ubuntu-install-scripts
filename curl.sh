#!/bin/bash

# Go to home
cd ~

if ! test -d ~/.fzf; then
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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if ! test -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi


if ! test -d ~/.tfenv; then
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
fi

if ! which terraenv &>/dev/null; then
  wget https://github.com/aaratn/terraenv/releases/latest/download/terraenv_linux_x64.tar.gz
  tar -xvzf terraenv_linux_x64.tar.gz
  rm terraenv_linux_x64.tar.gz
  sudo cp terraenv /usr/local/bin/terraenv
fi

if ! which aws &>/dev/null; then
  # Install AWS CLI
  # https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  rm awscliv2.zip
  sudo ./aws/install
fi

if ! which aws-sso-fetcher &>/dev/null; then
  curl https://github.com/flyinprogrammer/aws-sso-fetcher/releases/download/0.0.4/aws-sso-fetcher_0.0.4_linux_amd64.tar.gz \
    -o aws-sso-fetcher.tar.gz
  tar -C /tmp -xzf aws-sso-fetcher.tar.gz
  rm aws-sso-fetcher.tar.gz
  sudo cp /tmp/aws-sso-fetcher /usr/local/bin
fi
