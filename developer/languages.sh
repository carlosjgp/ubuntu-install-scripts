#!/usr/bin/env bash

set -x
set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

NODEJS_VERSION=14
NVM_VERSION=0.37.2

# Golang
## goenv
if ! folderExists ~/.goenv; then
  git clone https://github.com/syndbg/goenv.git ~/.goenv 
fi
### Register goenv
if ! rg goenv ~/.zshrc &>/dev/null; then
  echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.zshrc
  echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >> ~/.zshrc
  exec $SHELL
fi
## Install latest Golang
GO_V=$(goenv install -l | rg -v beta | tail -1 | awk '{$1=$1};1')
cliExists go && (go version | rg $GO_V) && goenv install $GO_V


# Python
## Set Python3 as default
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
## pyenv
if ! folderExists ~/.pyenv; then
  curl https://pyenv.run | bash
  exec $SHELL

  # install python
  # ??
fi
if ! rg pyenv ~/.zshrc &>/dev/null; then
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
fi


# NodeJs
if ! cliExists node; then
  ## Install nodejs
  curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi
if ! cliExists nvm; then
  ## nvm
  sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
  exec $SHELL
fi
if ! rg NVM_DIR ~/.zshrc &>/dev/null; then
  echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
  exec $SHELL
fi


# Java
## jenv
if ! folderExists ~/.jenv; then
  git clone https://github.com/jenv/jenv.git ~/.jenv
fi
if ! rg jenv ~/.zshrc; then
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(jenv init -)"' >> ~/.zshrc
  exec $SHELL
fi
## sdkman
if ! folderExists ~/.sdkman; then
  curl -s "https://get.sdkman.io" | bash
  exec $SHELL
fi
## Install java
cliExists java || sdk install java
