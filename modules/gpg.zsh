# gpg
if program "gpg"; then
  copy "${0:A:h:h}/home/gnupg/gpg-agent.conf" ".gnupg/gpg-agent.conf"
else
  skip "gpg"
fi
