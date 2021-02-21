#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

NVM_VERSION=0.37.2

echo Configure git
curl -s https://gist.githubusercontent.com/adeekshith/cd4c95a064977cdc6c50/raw/bb54233668f5c56c1a19f0ce8faf3a89eff8c678/.git-commit-template.txt > ~/.gitmessage
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/git/.gitconfig > ~/.gitconfig

if ! cliExists git-tree; then
  getLatestGithubBinary google/git-tree git-tree
  cat >> ~/.zshrc <<CONFIG
alias git-tree='git-tree -- --format="%C(auto)%h %d %<(50,trunc)%s"'
CONFIG
fi

# Golang
## goenv
if ! folderExists ~/.goenv; then
  git clone https://github.com/syndbg/goenv.git ~/.goenv
fi
### Register goenv
if ! rg goenv ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
export GOENV_ROOT="\$HOME/.goenv"
export PATH="\$GOENV_ROOT/bin:\$PATH"
CONFIG
fi
## Install latest Golang
GO_V=$(goenv install -l | rg -v beta | tail -1 | awk '{$1=$1};1')
cliExists go && (go version | rg $GO_V) && goenv install $GO_V


## pyenv
if ! folderExists ~/.pyenv; then
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev
  curl https://pyenv.run | bash
fi
if ! rg pyenv ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
CONFIG
fi
# install python
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install latest Python 3.8
python_v=$(pyenv install -l | grep "^  3\\.8\\." | grep -v dev | tail -1)
pyenv install $python_v
pyenv global $python_v

# NodeJs
if ! folderExists ~/.nvm; then
  ## nvm
  sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
fi
if ! rg NVM_DIR ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
CONFIG
fi
## Install nodejs
nvm install --lts --default

# Java
## jenv
if ! folderExists ~/.jenv; then
  git clone https://github.com/jenv/jenv.git ~/.jenv
fi
if ! rg jenv ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
export PATH="\$HOME/.jenv/bin:\$PATH"
eval "\$(jenv init -)"
CONFIG
fi
## sdkman
if ! folderExists ~/.sdkman; then
  curl -s "https://get.sdkman.io" | bash
fi
## Install java
cliExists java || sdk install java
