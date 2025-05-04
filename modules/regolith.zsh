# Regolith
if program "regolith-diagnostic" "regolith"; then
  copy "${0:A:h:h}/home/config/regolith3" ".config/regolith3"
else
  skip "regolith"
fi
