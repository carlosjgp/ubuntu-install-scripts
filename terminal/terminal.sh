#!/usr/bin/env bash

set -eo pipefail
source ${BASH_SOURCE%/*}/../_functions.sh

# Exa is only available on APT from Ubuntu 20.10 onwards
if ! cliExists exa; then
  info Install EXA
  EXA_V="0.9.0"
  url=https://github.com/ogham/exa/releases/download/v$EXA_V/exa-linux-x86_64-$EXA_V.zip
  folder=$(download $url exa.zip)
  unzip $folder/exa.zip -d $folder
  sudo mv $folder/exa-linux-x86_64 /usr/local/bin/exa
fi


if ! folderExists ~/.fzf; then
  info Install fuzzy finder
  cloneGit https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

if ! folderExists ~/.vim_runtime; then
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
fi

if ! folderExists ~/.nerd-fonts; then
  info Install Nerd fonts
  cloneGit https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
  ~/.nerd-fonts/install.sh
fi

info Configure git
curl -s https://gist.githubusercontent.com/adeekshith/cd4c95a064977cdc6c50/raw/bb54233668f5c56c1a19f0ce8faf3a89eff8c678/.git-commit-template.txt > ~/.gitmessage
curl -s https://raw.githubusercontent.com/carlosjgp/ubuntu-install-scripts/master/git/.gitconfig > ~/.gitconfig

if ! folderExists ~/.oh-my-zsh; then
  info Install Oh! My zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

zshCustomPath="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
zshThemesPath="$zshCustomPath/themes"
if ! folderExists $zshThemesPath/powerlevel10k; then
  cloneGit https://github.com/romkatv/powerlevel10k.git $zshThemesPath/powerlevel10k
fi
if ! folderExists $zshCustomPath/plugins/zsh-autosuggestions; then
git clone https://github.com/zsh-users/zsh-autosuggestions $zshCustomPath/plugins/zsh-autosuggestions
fi
if ! folderExists $zshCustomPath/plugins/zsh-syntax-highlighting; then
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zshCustomPath/plugins/zsh-syntax-highlighting
fi

if ! rg powerlevel10k ~/.zshrc &>/dev/null; then
  info Configure Oh My Zsh Theme
  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
fi

info Configure ZSH plugins
sed -i 's/plugins=\((.*)\)/plugins=(git git-extras golang helm kubectl python nvm pip ubuntu sudo zsh-syntax-highlighting history history-substring-search terraform aws minikube)/g' ~/.zshrc


if ! rg os-update ~/.zshrc &>/dev/null; then
  cat >> ~/.zshrc <<CONFIG
for f in $(exa -a ~/aliases); do
  source ~/aliases/$f
done
alias ls="exa -lh --time-style iso"
alias le="ls --tree"
alias ecr-login='\$(aws ecr get-login --no-include-email)'
alias os-update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
autoload -U compinit && compinit
CONFIG
fi

  # # Left prompt segments.
  # typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  #   # =========================[ Line #1 ]=========================
  #   # context                 # user@host
  #   kubecontext
  #   dir                       # current directory
  #   vcs                       # git status
  #   status
  #   # command_execution_time  # previous command duration
  #   # =========================[ Line #2 ]=========================
  #   newline                   # \n
  #   # virtualenv                # python virtual environment
  #   prompt_char               # prompt symbol
  # )

  # # Right prompt segments.
  # typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  #   # =========================[ Line #1 ]=========================
  #   load
  #   ram
  #   command_execution_time    # previous command duration
  #   context
  #   time
  #   virtualenv                # python virtual environment
  #   aws
  #   goenv
  #   pyenv
  #   nvm
  #   jenv
  #   gcloud
  #   # =========================[ Line #2 ]=========================
  #   newline                   # \n
  # )

info Configure Terminator
mkdir -p ~/.config/terminator
cat > ~/.config/terminator/config <<CONFIG
[global_config]
[keybindings]
  split_horiz = <Primary><Alt>minus
  split_vert = <Primary><Alt>backslash
[profiles]
  [[default]]
    cursor_color = "#aaaaaa"
    font = RobotoMono Nerd Font Mono 10
    scrollback_lines = 10000
    use_system_font = False
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
CONFIG
