#!/usr/bin/env zsh
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

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ -e $dotfile ]]; then
    if diff -q "$filepath" "$dotfile" &>/dev/null; then
      echo "$fg[blue][•]$reset_color $dotfile already exists"
    elif (( $FORCE )); then
      if [[ -d $filepath ]]; then
        if cp -Rf "${filepath:a}" "$dotfile"; then
          echo "$fg[green][+]$reset_color $dotfile directory $fg[red]force$reset_color copied"
        else
          echo "$fg[red][!]$reset_color $dotfile directory $fg[red]force$reset_color copy failed"
        fi
      elif [[ -a $filepath ]]; then
        if cp -pf "${filepath:a}" "$dotfile"; then
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
    if cp -R "${filepath:a}" "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile directory copied"
    else
      echo "$fg[red][!]$reset_color $dotfile directory copy failed"
    fi
  elif [[ -a $filepath ]]; then
    if cp -p "${filepath:a}" "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile file copied"
    else
      echo "$fg[red][!]$reset_color $dotfile file copy failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
  fi
}

rcopy() {
  local directory=$argv[1]
  local filepath=$argv[2]
  local dotfile=${argv[3]:-.${filepath:t}}

  for subdir in $directory/*(/); do
    copy "$filepath" "$subdir/$dotfile"
  done
}

decipher() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ -d $filepath ]]; then
    echo "$fg[red][!]$reset_color decipher failed. $dotfile is a directory"
  elif [[ -e $dotfile ]]; then
    if gpg --no-tty -q -d "$filepath" | diff -q - "$dotfile" &>/dev/null; then
      echo "$fg[blue][•]$reset_color $dotfile already exists"
    elif (( $FORCE )); then
      if gpg --no-tty -q -d "$filepath" 1>| "$dotfile"; then
        echo "$fg[green][+]$reset_color $dotfile file $fg[red]force$reset_color deciphered"
      else
        echo "$fg[red][!]$reset_color $dotfile file $fg[red]force$reset_color decipher failed"
      fi
    else
      echo "$fg[yellow][?]$reset_color files $filepath and $dotfile differ"
      if (( $DIFF )); then
        gpg --no-tty -q -d "$filepath" | diff - "$dotfile"
      fi
    fi
  elif [[ -a $filepath ]]; then
    if gpg --no-tty -q -d "$filepath" 1> "$dotfile"; then
      echo "$fg[green][+]$reset_color $dotfile file deciphered"
    else
      echo "$fg[red][!]$reset_color $dotfile file decipher failed"
    fi
  else
    echo "$fg[red][!]$reset_color $filepath does not exist"
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

caching_policy() {
  local oldp=( $1/*(.Nmh-1) )
  (( $#oldp ))
}

program() {
  [[ ${#PROGRAM} == 0 || ${PROGRAM} =~ [[:\<:]]$1[[:\>:]] ]] && (( $+commands[$1] ))
}
