# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add support for 256 color terminal
export TERM="xterm-256color"

# Kubernetes
export KUBE_EDITOR=vim

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# For custom Go lang location
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin

# GoEnv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Indexlabs
export PATH=$PATH:/home/carlosjgp/repos/indexlabs/devops-tools

# tfenv: https://github.com/tfutils/tfenv
export TFENV_ROOT="$HOME/.tfenv"
export PATH="$TFENV_ROOT/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/home/carlosjgp/.oh-my-zsh

# kubernetes SIG krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export NVM_DIR="/home/carlosjgp/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	golang
	helm
	kubectl
	python
	nvm
	pip
	ubuntu
	sudo
	zsh-syntax-highlighting
	history
	history-substring-search
	terraform
	aws
	minikube
	)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
for f in $(exa -a ~/aliases); do
	source ~/aliases/$f
done
alias ls="exa -lh --time-style iso"
alias le="ls --tree"
alias ecr-login='$(aws ecr get-login --no-include-email)'
alias os-update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
autoload -U compinit && compinit

# Indexlabs required
export CI_API_V4_URL="https://gitlab.infra-shared.footballindex.co.uk/api/v4"
export PLATFORM_CORE_UTILS_PROJECT_ID=17
export AWS_DEFAULT_REGION=eu-west-1
export AWS_REGION=${AWS_DEFAULT_REGION}
export AWS_SDK_LOAD_CONFIG=1

function aws-export-keys() {
  profile=$1
  if [[ -z "$profile" ]]; then
    profile=${AWS_PROFILE:-"default"}
  fi

  sso_start_url=$(aws configure get sso_start_url --profile $profile)
  sso_role_name=$(aws configure get sso_role_name --profile $profile)
  sso_account_id=$(aws configure get sso_account_id --profile $profile)
  sso_region=$(aws configure get sso_region --profile $profile)
  token_cache_file=$(grep -l \"$sso_start_url\" ~/.aws/sso/cache/*)

  if [[ -z "$token_cache_file" ]]; then
    # need to login
    echo "you need to aws sso login first"
    return 1
  else
    access_token=$(jq -r '.accessToken' < $token_cache_file)
  fi

  creds=$(aws sso get-role-credentials \
    --profile $profile \
    --role-name $sso_role_name \
    --account-id $sso_account_id \
    --region $sso_region \
    --access-token $access_token)

  export AWS_ACCESS_KEY_ID=$(jq -r '.roleCredentials.accessKeyId' <<< $creds)
  export AWS_SECRET_ACCESS_KEY=$(jq -r '.roleCredentials.secretAccessKey' <<< $creds)
  export AWS_SESSION_TOKEN=$(jq -r '.roleCredentials.sessionToken' <<< $creds)
  export AWS_DEFAULT_REGION=$sso_region
}

function switch-env() {
  env=$1
  export AWS_PROFILE=${env}
  if ! aws iam get-caller-identity &>/dev/null; then
    aws sso login
  fi
  aws-export-keys
  k config use-context fi-${env}
}

export NVM_DIR="/home/carlosjgp/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
