#!/usr/bin/env zsh
autoload -Uz colors && colors
source "functions.zsh"

version="0.3.2"

help="dotfiles $version

Usage: ${0:t} [-d | --diff] [-f | --force] [-h | --help] [-V | --version]

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

# zsh
if [[ -d ${0:A:h:h}/zsh ]]; then
  link ${0:A:h:h}/zsh
  copy ${0:A:h:h}/zsh/zlogin
  copy ${0:A:h:h}/zsh/zlogout
  copy ${0:A:h:h}/zsh/zprofile
  copy ${0:A:h:h}/zsh/zshenv
  copy ${0:A:h:h}/zsh/zshrc

  # zplug
  if [[ -d $HOME/.zplug ]]; then
    copy ${0:A:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  fi
fi

# vim
if [[ -d ${0:A:h:h}/vim ]]; then
  link ${0:A:h:h}/vim
  link ${0:A:h:h}/vim .config/nvim
  copy ${0:A:h:h}/vim/config.vim .vimrc
fi

# tmux
copy ${0:A:h}/home/tmux.conf

# tig
copy ${0:A:h}/home/tigrc

# git
copy ${0:A:h}/home/gitconfig
copy ${0:A:h}/home/gitignore

if [[ -d $HOME/dev/synbioz ]]; then
  rdecipher $HOME/dev/synbioz ${0:A:h}/home/dev/synbioz/mailmap.gpg .mailmap
  rdecipher $HOME/dev/synbioz ${0:A:h}/home/dev/synbioz/gitconfig.gpg .gitconfig
fi

if [[ -d $HOME/dev/perso ]]; then
  rdecipher $HOME/dev/perso ${0:A:h}/home/dev/perso/mailmap.gpg .mailmap
  rdecipher $HOME/dev/perso ${0:A:h}/home/dev/perso/gitconfig.gpg .gitconfig
fi

# bat
if which bat &> /dev/null; then
  copy ${0:A:h}/home/config/bat .config/bat

  if caching_policy ${HOME}/.config/bat/themes; then
    bat cache --build
    echo "$fg[green][+]$reset_color bat cache rebuilt"
  else
    echo "$fg[yellow][-]$reset_color no need to rebuild bat cache"
  fi
fi

# Iosevka font
if [[ -d $HOME/git/iosevka ]]; then
  copy ${0:A:h}/home/fonts/iosevka/private-build-plans.toml private-build-plans.toml
fi
