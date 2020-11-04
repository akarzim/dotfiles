# starship
if program "starship"; then
  copy ${0:A:h:h}/home/config/starship.toml .config/starship.toml
else
  skip "starship"
fi
