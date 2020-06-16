# git
if program "git"; then
  copy ${0:A:h:h}/home/gitconfig
  copy ${0:A:h:h}/home/gitignore

  if [[ -d $HOME/dev/synbioz ]]; then
    rdecipher $HOME/dev/synbioz ${0:A:h:h}/home/dev/synbioz/mailmap.gpg .mailmap
    rdecipher $HOME/dev/synbioz ${0:A:h:h}/home/dev/synbioz/gitconfig.gpg .gitconfig
  fi

  if [[ -d $HOME/dev/perso ]]; then
    rdecipher $HOME/dev/perso ${0:A:h:h}/home/dev/perso/mailmap.gpg .mailmap
    rdecipher $HOME/dev/perso ${0:A:h:h}/home/dev/perso/gitconfig.gpg .gitconfig
  fi
else
  echo "$fg[magenta][/]$reset_color skip git"
fi
