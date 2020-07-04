# tig
if program "tig"; then
  copy ${0:A:h:h}/home/tigrc
else
  skip "tig"
fi
