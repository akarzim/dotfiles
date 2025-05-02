# git
if program "git"; then
  copy ${0:A:h:h}/home/gitconfig
  copy ${0:A:h:h}/home/gitconfig-enercoop
  copy ${0:A:h:h}/home/gitconfig-perso
  copy ${0:A:h:h}/home/gitignore
  copy ${0:A:h:h}/home/gitattributes

  # if [[ -d $HOME/dev/perso ]]; then
  #   rdecipher $HOME/dev/perso ${0:A:h:h}/home/dev/perso/mailmap.age .mailmap
  # fi
else
  skip "git"
fi
