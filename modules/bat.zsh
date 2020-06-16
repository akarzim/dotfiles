# bat
if program "bat"; then
  copy ${0:A:h:h}/home/config/bat .config/bat

  if caching_policy ${HOME}/.config/bat/themes; then
    bat cache --build
    echo "$fg[green][+]$reset_color bat cache rebuilt"
  else
    echo "$fg[yellow][-]$reset_color no need to rebuild bat cache"
  fi
else
  echo "$fg[magenta][/]$reset_color skip bat"
fi
