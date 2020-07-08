# zsh
if program "zsh" && [[ -d ${0:A:h:h:h}/zsh ]]; then
  link ${0:A:h:h:h}/zsh
  copy ${0:A:h:h:h}/zsh/zlogin
  copy ${0:A:h:h:h}/zsh/zlogout
  copy ${0:A:h:h:h}/zsh/zprofile
  copy ${0:A:h:h:h}/zsh/zshenv
  copy ${0:A:h:h:h}/zsh/zshrc
  decipher ${0:A:h:h}/home/zsecrets.gpg .zsecrets

  # zplug
  if [[ -d $HOME/.zplug ]]; then
    copy ${0:A:h:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  else
    skip "zplug"
  fi
else
  skip "zsh"
fi
