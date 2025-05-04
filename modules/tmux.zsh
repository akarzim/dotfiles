# tmux
if program "tmux"; then
  copy "${0:A:h:h}/home/tmux.conf"
else
  skip "tmux"
fi
