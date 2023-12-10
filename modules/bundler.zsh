# bundler
if program "bundle"; then
  copy ${0:A:h:h}/home/gemrc .gemrc
else
  skip "bundler"
fi
