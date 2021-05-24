#!/usr/bin/env zsh
autoload -Uz colors && colors
source "functions.zsh"

version="0.3.5"

help="dotfiles $version

Usage: ${0:t} [-d | --diff] [-f | --force] [-h | --help] [-V | --version] [program ...]

Environment:
  DIFF      hide/show changes between files if they are different (default: 0 ; values: 0, 1)
  FORCE     overwrite or not existing files if they are different (default: 0 ; values: 0, 1)

Options:
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

PROGRAM=${argv[@]}

# Load modules
for module in ${0:A:h}/modules/*.zsh; do
  source $module
done
