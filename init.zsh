#!/usr/bin/env zsh
autoload -Uz colors && colors
source "functions.zsh"

version="0.3.0"

help="dotfiles $version

Options:

-d, --diff      show changes between files if they are different
-f, --force     overwrite existing files if they are different
-h, --help      print this help
-V, --version   print the version number"

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
    diff=1
    ;;
  -f | --force )
    echo "$fg[red](|)$reset_color force mode on"
    force=1
    ;;
esac; shift; done

if [[ "$1" == '--' ]]; then shift; fi

# zsh
if [[ -d ${0:A:h:h}/zsh ]]; then
  link -d$diff -f$force ${0:A:h:h}/zsh
  copy -d$diff -f$force ${0:A:h:h}/zsh/zlogin
  copy -d$diff -f$force ${0:A:h:h}/zsh/zlogout
  copy -d$diff -f$force ${0:A:h:h}/zsh/zprofile
  copy -d$diff -f$force ${0:A:h:h}/zsh/zshenv
  copy -d$diff -f$force ${0:A:h:h}/zsh/zshrc

  # zplug
  if [[ -d $HOME/.zplug ]]; then
    copy -d$diff -f$force ${0:A:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  fi
fi

# vim
if [[ -d ${0:A:h:h}/vim ]]; then
  link -d$diff -f$force ${0:A:h:h}/vim
  link -d$diff -f$force ${0:A:h:h}/vim .config/nvim
  copy -d$diff -f$force ${0:A:h:h}/vim/config.vim .vimrc
fi

# tmux
copy -d$diff -f$force ${0:A:h}/home/tmux.conf

# tig
copy -d$diff -f$force ${0:A:h}/home/tigrc

# git
copy -d$diff -f$force ${0:A:h}/home/gitconfig
copy -d$diff -f$force ${0:A:h}/home/gitignore

if [[ -d $HOME/dev/synbioz ]]; then
  for project in $HOME/dev/synbioz/*(/); do
    decipher -d$diff -f$force ${0:A:h}/home/dev/synbioz/mailmap.gpg dev/synbioz/${project:t}/.mailmap
    decipher -d$diff -f$force ${0:A:h}/home/dev/synbioz/gitconfig.gpg dev/synbioz/${project:t}/.gitconfig
  done
fi

if [[ -d $HOME/dev/perso ]]; then
  for project in $HOME/dev/perso/*(/); do
    decipher -d$diff -f$force ${0:A:h}/home/dev/perso/mailmap.gpg dev/perso/${project:t}/.mailmap
    decipher -d$diff -f$force ${0:A:h}/home/dev/perso/gitconfig.gpg dev/perso/${project:t}/.gitconfig
  done
fi

# bat
if which bat &> /dev/null; then
  copy -d$diff -f$force ${0:A:h}/home/config/bat .config/bat

  if caching_policy ${HOME}/.config/bat/themes; then
    bat cache --build
    echo "$fg[green][+]$reset_color bat cache rebuilt"
  else
    echo "$fg[yellow][-]$reset_color no need to rebuild bat cache"
  fi
fi

# Iosevka font
if [[ -d $HOME/git/iosevka ]]; then
  copy -d$diff -f$force ${0:A:h}/home/fonts/iosevka/private-build-plans.toml private-build-plans.toml
fi
