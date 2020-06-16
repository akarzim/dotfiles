# tmux
if program "tmux"; then
  copy ${0:A:h:h}/home/tmux.conf
else
  echo "$fg[magenta][/]$reset_color skip tmux"
fi
