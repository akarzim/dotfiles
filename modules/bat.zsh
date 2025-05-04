# bat
if program "batcat" "bat"; then
  copy "${0:A:h:h}/home/config/bat" ".config/bat"

  if caching_policy "${XDG_CONFIG_HOME:-$HOME/.config}/bat/themes"; then
    if (( $CHECK )); then
      notify "need to rebuild bat cache"
    else
      batcat cache --build
      success "bat cache rebuilt"
    fi
  else
    noop "no need to rebuild bat cache"
  fi
else
  skip "bat"
fi
