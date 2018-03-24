#!/bin/bash

# Go to home
cd ~

echo Install Oh! My zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# Not needed if I'm keeping the .zshrc file
# sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' ~/.zshrc

# Install Powerline fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts


# https://github.com/ogham/exa#installation
echo Install Rust needed by EXA
curl https://sh.rustup.rs -sSf | sh
echo Export cargo bynary
export PATH="$PATH:~/.cargo/bin"

cargo install exa
rm -Rf ~/.cargo

echo Install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
