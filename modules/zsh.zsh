# zsh
if program "zsh" && [[ -d ${0:A:h:h:h}/zsh ]]; then
  link ${0:A:h:h:h}/zsh
  copy ${0:A:h:h:h}/zsh/zlogin
  copy ${0:A:h:h:h}/zsh/zlogout
  copy ${0:A:h:h:h}/zsh/zprofile
  copy ${0:A:h:h:h}/zsh/zshenv
  copy ${0:A:h:h:h}/zsh/zshrc

  # zplug
  if [[ -d $HOME/.zplug ]]; then
    copy ${0:A:h:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  else
    echo "$fg[magenta][/]$reset_color skip zplug"
  fi
else
  echo "$fg[magenta][/]$reset_color skip zsh"
fi
