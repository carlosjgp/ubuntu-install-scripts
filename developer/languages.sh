#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

NVM_VERSION=0.37.2

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


# Python
## Set Python3 as default
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

## pyenv
if ! folderExists ~/.pyenv; then
  curl https://pyenv.run | bash

  # install python
  # ??
fi
if ! rg pyenv ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
CONFIG
fi

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
if ! cliExists node; then
  ## Install nodejs
  nvm install --lts --default
fi

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
