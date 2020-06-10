#!/usr/bin/env zsh
link() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ $filepath -ef ~/$dotfile ]]; then
    echo "$fg[blue][•]$reset_color $dotfile already exists"
  elif [[ -e ~/$dotfile ]]; then
    echo "$fg[yellow][?]$reset_color $dotfile exists but point to the wrong file"
  elif [[ -a $filepath ]]; then
    if ln -sv "${filepath:a}" "$HOME/$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile linked"
    else
      echo "$fg[red][!]$reset_color $dotfile link failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

copy() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ -e ~/$dotfile ]]; then
    if diff -q "$filepath" "$HOME/$dotfile" &>/dev/null; then
      echo "$fg[blue][•]$reset_color $dotfile already exists"
    else
      echo "$fg[yellow][?]$reset_color files $filepath and $dotfile differ"
    fi
  elif [[ -d $filepath ]]; then
    if cp -R "${filepath:a}" "$HOME/$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile directory copied"
    else
      echo "$fg[red][!]$reset_color $dotfile directory copy failed"
    fi
  elif [[ -a $filepath ]]; then
    if cp -p "${filepath:a}" "$HOME/$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile file copied"
    else
      echo "$fg[red][!]$reset_color $dotfile file copy failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

decipher() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ -d $filepath ]]; then
    echo "$fg[red][!]$reset_color decipher failed. $dotfile is a directory"
  elif [[ -e ~/$dotfile ]]; then
    if gpg --no-tty -q -d "$filepath" | diff -q - "$HOME/$dotfile" &>/dev/null; then
      echo "$fg[blue][•]$reset_color $dotfile already exists"
    else
      echo "$fg[yellow][?]$reset_color files $filepath and $dotfile differ"
    fi
  elif [[ -a $filepath ]]; then
    if gpg --no-tty -q -d "$filepath" 1> "$HOME/$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile file deciphered"
    else
      echo "$fg[red][!]$reset_color $dotfile file decipher failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

caching_policy() {
  local oldp=( $1/*(.Nmh-1) )
  (( $#oldp ))
}
