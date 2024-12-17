#!/usr/bin/env zsh
module() {
  if [[ -o rematchpcre || "$OSTYPE" == darwin* ]]; then
    [[ ${#PROGRAM} == 0 || ${PROGRAM} =~ [[:\<:]]$1[[:\>:]] ]]
  else
    [[ ${#PROGRAM} == 0 || ${PROGRAM} =~ "\<$1\>" ]]
  fi
}

program() {
  module ${2:-$1} && (( $+commands[$1] ))
}

caching_policy() {
  local oldp=( $1/*(.Nmh-1) )
  (( $#oldp ))
}

skip() {
  echo "$fg[magenta][/]$reset_color skip $1"
}

link() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ $filepath -ef $dotfile ]]; then
    echo "$fg[blue][•]$reset_color $dotfile link already exists"
  elif [[ -e $dotfile ]]; then
    if (( $FORCE )); then
      if ln -svf "${filepath:a}" "$dotfile"; then
        echo "$fg[green][+]$reset_color $dotfile $fg[red]force$reset_color linked"
      else
        echo "$fg[red][!]$reset_color $dotfile $fg[red]force$reset_color link failed"
      fi
    else
      echo "$fg[yellow][?]$reset_color $dotfile link exists but point to the wrong file"
    fi
  elif [[ -a $filepath ]]; then
    if ln -sv "${filepath:a}" "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile linked"
    else
      echo "$fg[red][!]$reset_color $dotfile link failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

rlink() {
  local directory=$argv[1]
  local filepath=$argv[2]
  local dotfile=${argv[3]:-.${filepath:t}}

  for subdir in $directory/*(/); do
    link "$filepath" "$subdir/$dotfile"
  done
}

copy() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}
  local sudo=""
  
  if [[ -n "$argv[3]" ]]; then
    sudo="sudo"
  fi

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ -e $dotfile ]]; then
    if diff -q "$filepath" "$dotfile" &>/dev/null; then
      echo "$fg[blue][•]$reset_color $dotfile already exists"
    elif (( $FORCE )); then
      if [[ -d $filepath ]]; then
        if $sudo cp -Rf "${filepath:a}" "$dotfile"; then
          echo "$fg[green][+]$reset_color $dotfile directory $fg[red]force$reset_color copied"
        else
          echo "$fg[red][!]$reset_color $dotfile directory $fg[red]force$reset_color copy failed"
        fi
      elif [[ -a $filepath ]]; then
        if $sudo cp -pf "${filepath:a}" "$dotfile"; then
          echo "$fg[green][+]$reset_color $dotfile file $fg[red]force$reset_color copied"
        else
          echo "$fg[red][!]$reset_color $dotfile file $fg[red]force$reset_color copy failed"
        fi
      fi
    else
      echo "$fg[yellow][?]$reset_color files $filepath and $dotfile differ"
      if (( $DIFF )); then
        diff "$filepath" "$dotfile"
      fi
    fi
  elif [[ -d $filepath ]]; then
    if $sudo cp -R "${filepath:a}" "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile directory copied"
    else
      echo "$fg[red][!]$reset_color $dotfile directory copy failed"
    fi
  elif [[ -a $filepath ]]; then
    if $sudo mkdir -p "${dotfile:h}" && $sudo cp -p "${filepath:a}" "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile file copied"
    else
      echo "$fg[red][!]$reset_color $dotfile file copy failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

scopy() {
  copy $argv "sudo"
}

rcopy() {
  local directory=$argv[1]
  local filepath=$argv[2]
  local dotfile=${argv[3]:-.${filepath:t}}

  for subdir in $directory/*(/); do
    copy "$filepath" "$subdir/$dotfile"
  done
}

decryptool() {
  local filepath=$argv[1]

  if (( $+commands[$GPGTOOL] )) && [[ $filepath =~ ".gpg$" ]]; then
    $GPGTOOL --no-tty -q -d "$filepath"
  elif (( $+commands[$AGETOOL] )) && [[ -n "$AGEKEY" ]] && [[ $filepath =~ ".age$" ]]; then
    $AGETOOL --decrypt -i $AGEKEY "$filepath"
  elif [[ ! (( $+commands[$GPGTOOL] )) ]]; then
    echo "$fg[red][!]$reset_color $GPGTOOL file encryption tool is not installed"
  elif [[ ! (( $+commands[$AGETOOL] )) ]]; then
    echo "$fg[red][!]$reset_color $AGETOOL file encryption tool is not installed"
  elif [[ -z "$AGEKEY" ]]; then
    echo "$fg[red][!]$reset_color age private key is missing."
  else
    echo "$fg[red][!]$reset_color $dotfile cannot be decrypted"
  fi
}

decipher() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ -d $filepath ]]; then
    echo "$fg[red]{!}$reset_color decipher failed. $dotfile is a directory"
  elif [[ -e $dotfile ]]; then
    if decryptool "$filepath" | diff -q - "$dotfile" &>/dev/null; then
      echo "$fg[blue]{•}$reset_color $dotfile already exists"
    elif (( $FORCE )); then
      if decryptool "$filepath" 1>| "$dotfile"; then
        echo "$fg[green]{+}$reset_color $dotfile file $fg[red]force$reset_color deciphered"
      else
        echo "$fg[red]{!}$reset_color $dotfile file $fg[red]force$reset_color decipher failed"
      fi
    else
      echo "$fg[yellow]{?}$reset_color files $filepath and $dotfile differ"
      if (( $DIFF )); then
        decryptool "$filepath" | diff - "$dotfile"
      fi
    fi
  elif [[ -a $filepath ]]; then
    if decryptool "$filepath" 1> "$dotfile"; then
      echo "$fg[green]{+}$reset_color $dotfile file deciphered"
    else
      echo "$fg[red]{!}$reset_color $dotfile file decipher failed"
    fi
  else
    echo "$fg[red]{!}$reset_color $filepath does not exist"
  fi
}

rdecipher() {
  local directory=$argv[1]
  local filepath=$argv[2]
  local dotfile=${argv[3]:-.${filepath:t}}

  for subdir in $directory/*(/); do
    decipher "$filepath" "$subdir/$dotfile"
  done
}

notify() {
  local msg=$argv[1]

  echo "$fg[yellow][ℹ]$reset_color $msg"
}
