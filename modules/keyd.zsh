# keyd
if program "keyd"; then
  scopy "${0:A:h:h}/etc/keyd/default.conf" "/etc/keyd/default.conf"
  scopy "${0:A:h:h}/etc/keyd/mx_master.conf" "/etc/keyd/mx_master.conf"
  scopy "${0:A:h:h}/etc/keyd/typematrix.conf" "/etc/keyd/typematrix.conf"

  if (( $CHECK )); then
    notify "omit keyd reloading"
  else
    notify "keyd reload…"
    sudo keyd reload
    notify "keyd reloaded!"
  fi
else
  skip "keyd"
fi
