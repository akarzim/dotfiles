# bundler
if program "bundle" "bundler"; then
  copy ${0:A:h:h}/home/gemrc .gemrc
else
  skip "bundler"
fi
