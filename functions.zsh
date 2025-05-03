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
    info "$dotfile symlink already exists"
  elif [[ -e $dotfile ]]; then
    if (( $FORCE )); then
      if ln -svf "${filepath:a}" "$dotfile"; then
        success "$dotfile $fg[red]force$reset_color linked"
      else
        alert "$dotfile $fg[red]force$reset_color link failed"
      fi
    elif [[ -h $dotfile ]]; then
      warn "$dotfile symllink exists but point to the wrong file"
    elif [[ -d $dotfile ]]; then
      warn "$dotfile should be a symlink but is a directory"
    else
      warn "$dotfile should be a symlink but is a file"
    fi
  elif [[ -a $filepath ]]; then
    if ln -sv "${filepath:a}" "$dotfile"; then
      success "$dotfile linked"
    else
      alert "$dotfile link failed"
    fi
  else
    alert "$filepath does not exist"
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
    if diffrq "$filepath" "$dotfile" &>/dev/null; then
      info "$dotfile already exists"
    elif (( $FORCE )); then
      if (( $THEIR )); then
        if [[ -d $filepath ]]; then
          if $sudo cp -Rf "${filepath:a}" "$dotfile"; then
            success "$dotfile directory $fg[green]force$reset_color updated"
          else
            alert "$dotfile directory $fg[red]force$reset_color copy failed"
          fi
        elif [[ -a $filepath ]]; then
          if $sudo cp -pf "${filepath:a}" "$dotfile"; then
            success "$dotfile file $fg[green]force$reset_color updated"
          else
            alert "$dotfile file $fg[red]force$reset_color copy failed"
          fi
        fi
      elif (( $OURS )); then
        if [[ -d $dotfile ]]; then
          if $sudo cp -Rf "${dotfile:a}" "${filepath:h}"; then
            success "$filepath directory $fg[green]force$reset_color updated"
          else
            alert "$filepath directory $fg[red]force$reset_color copy failed"
          fi
        elif [[ -a $dotfile ]]; then
          if $sudo cp -pf "${dotfile:a}" "$filepath"; then
            success "$filepath file $fg[green]force$reset_color updated"
          else
            alert "$filepath file $fg[red]force$reset_color copy failed"
          fi
        fi
      else
        alert "please provide a copy direction"
      fi
    else
      warn "files $filepath and $dotfile differ"
      if (( $DIFF )); then
        if (( $INTERACTIVE )); then
          if [[ -f $dotfile ]] && (( $+commands[$DIFFEDITOR] )); then
            diffeditor "$filepath" "$dotfile"
            if diffrq "$filepath" "$dotfile" &>/dev/null; then
              info "$filepath and $dotfile are now identical"
            fi
          else
            diffrq "$filepath" "$dotfile"
          fi
        else
          diffr "$filepath" "$dotfile"
        fi
      fi
    fi
  elif [[ -d $filepath ]]; then
    if $sudo cp -R "${filepath:a}" "$dotfile"; then
      success "$dotfile directory copied"
    else
      alert "$dotfile directory copy failed"
    fi
  elif [[ -a $filepath ]]; then
    if $sudo mkdir -p "${dotfile:h}" && $sudo cp -p "${filepath:a}" "$dotfile"; then
      success "$dotfile file copied"
    else
      alert "$dotfile file copy failed"
    fi
  else
    alert "$filepath does not exist"
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
    alert "$GPGTOOL file encryption tool is not installed"
  elif [[ ! (( $+commands[$AGETOOL] )) ]]; then
    alert "$AGETOOL file encryption tool is not installed"
  elif [[ -z "$AGEKEY" ]]; then
    alert "age private key is missing."
  else
    alert "$dotfile cannot be decrypted"
  fi
}

decipher() {
  local filepath=$argv[1]
  local dotfile=${argv[2]:-.${filepath:t}}

  if [[ ! $dotfile =~ "^/" ]]; then
    dotfile="$HOME/$dotfile"
  fi

  if [[ -d $filepath ]]; then
    alert "decipher failed. $dotfile is a directory"
  elif [[ -e $dotfile ]]; then
    if decryptool "$filepath" | diffq - "$dotfile" &>/dev/null; then
      info "$dotfile already exists"
    elif (( $FORCE )); then
      if decryptool "$filepath" 1>| "$dotfile"; then
        success "$dotfile file $fg[red]force$reset_color deciphered"
      else
        alert "$dotfile file $fg[red]force$reset_color decipher failed"
      fi
    else
      warn "files $filepath and $dotfile differ"
      if (( $DIFF )); then
        if (( $INTERACTIVE )); then
          notify "no interactive diff between encrypted files"
        fi
        decryptool "$filepath" | $DIFFTOOL - "$dotfile"
        notify "to encrypt ${dotfile##*/} please run:"
        notify "age --encrypt -i ${AGEKEY} --output ${filepath} ${dotfile}"
      fi
    fi
  elif [[ -a $filepath ]]; then
    if decryptool "$filepath" 1> "$dotfile"; then
      success "$dotfile file deciphered"
    else
      alert "$dotfile file decipher failed"
    fi
  else
    alert "$filepath does not exist"
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

alert() {
  local msg=$argv[1]

  echo "$fg[red][!]$reset_color $msg"
}

info() {
  local msg=$argv[1]

  echo "$fg[blue][•]$reset_color $msg"
}

noop() {
  local msg=$argv[1]

  echo "$fg[yellow][-]$reset_color $msg"
}

notify() {
  local msg=$argv[1]

  echo "$fg[yellow][ℹ]$reset_color $msg"
}

success() {
  local msg=$argv[1]

  echo "$fg[green][+]$reset_color $msg"
}

warn() {
  local msg=$argv[1]

  echo "$fg[yellow][?]$reset_color $msg"
}

diffeditor() {
  case $DIFFEDITOR in
    vi | vim | nvim )
      $DIFFEDITOR -d $argv
    ;;
    * )
      notify "fallback to generic diff editor"
      $DIFFEDITOR $argv
    ;;
  esac
}

diffr() {
  case $DIFFTOOL in
    diff )
      $DIFFTOOL -r $argv
    ;;
    * )
      alert "unsupported diff tool. abort."
      exit 1
    ;;
  esac
}

diffq() {
  case $DIFFTOOL in
    diff )
      $DIFFTOOL -q $argv
    ;;
    * )
      alert "unsupported diff tool. abort."
      exit 1
    ;;
  esac
}

diffrq() {
  case $DIFFTOOL in
    diff )
      $DIFFTOOL -rq $argv
    ;;
    * )
      alert "unsupported diff tool. abort."
      exit 1
    ;;
  esac
}
