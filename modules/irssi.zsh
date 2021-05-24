# irssi
if program "irssi"; then
  copy ${0:A:h:h}/home/irssi/akar.theme .irssi/akar.theme
  decipher ${0:A:h:h}/home/irssi/config.age .irssi/config
else
  skip "irssi"
fi
