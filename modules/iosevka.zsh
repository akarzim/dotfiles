# Iosevka font
if module "iosevka" && [[ -d $HOME/git/iosevka ]]; then
  copy ${0:A:h:h}/home/fonts/iosevka/private-build-plans.toml $HOME/git/iosevka/private-build-plans.toml
  copy ${0:A:h:h}/home/fonts/iosevka/Makefile $HOME/git/iosevka/Makefile
else
  skip "iosevka font"
fi
