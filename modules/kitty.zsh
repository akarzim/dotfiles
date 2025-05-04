# tmux
if program "kitty"; then
  copy "${0:A:h:h}/home/config/kitty" ".config/kitty"
else
  skip "kitty"
fi
