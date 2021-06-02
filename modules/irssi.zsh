# irssi
if program "irssi"; then
  copy ${0:A:h:h}/home/irssi/akar.theme .irssi/akar.theme
  decipher ${0:A:h:h}/home/irssi/config.age .irssi/config
  copy ${0:A:h:h}/home/irssi/certs/nick.cer .irssi/certs/nick.cer
  notify "be sure to copy your private key and .pem file in ~/.irssi/certs/ too"
else
  skip "irssi"
fi
