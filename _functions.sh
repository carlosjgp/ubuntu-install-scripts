#!/usr/bin/env bash

function download(){
  local tmpDir=$(mktemp -d)
  local url=$1
  local defaultTarget=$(echo $url | rev | cut -d '/' -f 1 | rev)
  local target=${2:-$defaultTarget}

  wget -O $tmpDir/$target $url
  echo $tmpDir
}

function addPPA() {
  local ppa=$1
  sudo add-apt-repository $ppa
  sudo apt-get update
}

function cliExists() {
  local cli=$1
  if which $cli &>/dev/null; then
    true
  else
    false
  fi
}

function folderExists() {
  local folder=$1
  if test -d $folder; then
    true
  else
    false
  fi
}

function fileExists() {
  local file=$1
  if test -f $file; then
    true
  else
    false
  fi
}

function cloneGit() {
  local repo=$1
  local target=$2
  git clone --depth=1 $repo $target
}

function info () {
  echo $@
}

function latestGithubReleaseURI() {
  local repo=$1
  local file=$2
  local apiCall="https://api.github.com/repos/$repo/releases/latest"
  local grepRegEx="https://.+?$file"
  echo $(curl -u $GITHUB_USER:$GITHUB_TOKEN -Ls $apiCall | grep -o -E $grepRegEx)
}

function downloadBinary() {
  local url=$1
  local defaultTarget=$(rev $url | cut -d "/" -f 1 | rev)
  local target=${2:-$defaultTarget}
  local path=${3:-"/usr/local/bin"}
  local binary=$path/$target
  sudo wget -O $binary $url
  sudo chmod +x $binary
}
