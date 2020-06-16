# tig
if program "tig"; then
  copy ${0:A:h:h}/home/tigrc
else
  echo "$fg[magenta][/]$reset_color skip tig"
fi
