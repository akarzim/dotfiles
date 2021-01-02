# irssi
if program "irssi"; then
  copy ${0:A:h:h}/home/irssi/akar.theme .irssi/akar.theme
  copy ${0:A:h:h}/home/irssi/config .irssi/config
else
  skip "irssi"
fi
