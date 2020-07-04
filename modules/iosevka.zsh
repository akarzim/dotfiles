# Iosevka font
if [[ -d $HOME/git/iosevka ]]; then
  copy ${0:A:h:h}/home/fonts/iosevka/private-build-plans.toml $HOME/git/iosevka/private-build-plans.toml
else
  skip "iosevka font"
fi
