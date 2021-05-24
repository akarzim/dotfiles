#!/usr/bin/env zsh
autoload -Uz colors && colors
source "functions.zsh"

version="0.4.0"

help="dotfiles $version

Usage: ${0:t} [-d | --diff] [-f | --force] [-h | --help] [-V | --version] [program ...]

Environment:
  DIFF      hide/show changes between files if they are different (default: 0 ; values: 0, 1)
  FORCE     overwrite or not existing files if they are different (default: 0 ; values: 0, 1)
  GPGTOOL   executable for the GPG file encryption tool (default: gpg)
  AGETOOL   executable for the age file encryption tool (default: age)
  AGEKEY    path to your age private key

Options:
  --age-tool=AGE_TOOL         set the age file encryption tool executable
  --gpg-tool=GPG_TOOL         set the gpg file encryption tool executable
  -d, --diff, --no-diff       show/hide changes between files if they are different
  -f, --force, --no-force     overwrite or not existing files if they are different
  -h, --help                  print this help
  -V, --version               print the version number"

# options
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -h | --help )
    echo $help
    exit
    ;;
  --age-key )
    shift; AGEKEY=$1
    echo "$fg[green](|)$reset_color age private key path is set to $AGEKEY"
    ;;
  --age-tool )
    shift; AGETOOL=$1
    echo "$fg[green](|)$reset_color age file encryption tool is set to $AGETOOL"
    ;;
  --gpg-tool )
    shift; GPGTOOL=$1
    echo "$fg[green](|)$reset_color gpg file encryption tool is set to $GPGTOOL"
    ;;
  -d | --diff )
    echo "$fg[green](|)$reset_color diff mode on"
    DIFF=1
    ;;
  --no-diff )
    echo "$fg[yellow](–)$reset_color diff mode off"
    DIFF=0
    ;;
  -f | --force )
    echo "$fg[red](|)$reset_color force mode on"
    FORCE=1
    ;;
  --no-force )
    echo "$fg[yellow](–)$reset_color force mode off"
    FORCE=0
    ;;
esac; shift; done

if [[ "$1" == '--' ]]; then shift; fi

AGETOOL=${AGETOOL:-age}
GPGTOOL=${GPGTOOL:-gpg}
PROGRAM=${argv[@]}

# Load modules
for module in ${0:A:h}/modules/*.zsh; do
  source $module
done
