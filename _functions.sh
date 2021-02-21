#!/usr/bin/env bash

set -x

function _filenameFromUri() {
  echo $1 | rev | cut -d "/" -f 1 | rev
}

function download(){
  local tmpDir=$(mktemp -d)
  local uri=$1
  local defaultTarget=$(_filenameFromUri $uri)
  local target=${2:-$defaultTarget}

  wget -qO $tmpDir/$target $uri
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

function latestGithubReleaseURI() {
  local repo=$1
  local file=$2
  local apiCall="https://api.github.com/repos/$repo/releases/latest"
  local grepRegEx="https://.+?$file"
  echo $(curl -u $GITHUB_USER:$GITHUB_TOKEN -Ls $apiCall | grep -o -E $grepRegEx)
}

function downloadBinary() {
  local defaultPath="$HOME/bin"
  mkdir -p $defaultPath
  local url=$1
  local defaultTarget=$(_filenameFromUri $url)
  local target=${2:-$defaultTarget}
  local path=${3:-$defaultPath}
  local binary=$path/$target
  sudo wget -O $binary $url
  sudo chmod +x $binary
}

function installDeb() {
  local package=""
  # if $1 is URL; then
  local url=$1
  local folder=$(download $url file.deb)
  local package="$folder/file.deb"
  # else
  # package=$1
  # fi
  sudo dpkg -i $package
}

function downloadAppImage() {
  mkdir -p ~/Applications
  local url=$1
  local app=$(_filenameFromUri $url)
  local folder=$(download $url $app)
  local tmpPath=$folder/$app
  chmod +x $tmpPath
  mv $tmpPath ~/Applications/
}

function downloadTar() {
  local uri=$1
  local target=$(_filenameFromUri $uri)
  local folder=$(download $uri $target)
  tar -xf $folder/$target -C $folder
  echo $folder
}

function downloadZip() {
  local url=$1
  local folder=$(download $url application.zip)
  unzip $folder/application.zip -d $folder
}

function getLatestGithubBinary() {
  local repo=$1
  local regex=$2
  local binary=$3
  downloadBinary $(latestGithubReleaseURI $repo $regex) $binary
}

function getLatestGithubDeb() {
  local repo=$1
  local regex=$2
  local uri=$(latestGithubReleaseURI $repo $regex)
  local app=$(_filenameFromUri $uri)
  local folder=$(download $uri $app)
  local package=$folder/$app
  sudo dpkg -i $package
}

function _getLatestGithubUnarchive() {
  local unarchivingCmd=$1
  local repo=$2
  local regex=$3
  local binary=$4

  local uri=$(latestGithubReleaseURI $repo $regex)
  local app=$(_filenameFromUri $uri)
  local folder=$(download $uri $app)
  $unarchivingCmd $folder/$app -d $folder
  mv $folder/$binary $HOME/bin/$binary
}

function getLatestGithubZip() {
  _getLatestGithubUnarchive unzip $1 $2 $3
}

function getLatestGithubTar() {
  _getLatestGithubUnarchive "tar -xf" $1 $2 $3
}

function getLatestGithubTarGZ() {
  _getLatestGithubUnarchive "tar -xzf" $1 $2 $3
}
