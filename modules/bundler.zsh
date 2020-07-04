# bundler
if program "bundle"; then
  decipher ${0:A:h:h}/home/gemrc.gpg .gemrc
else
  echo "$fg[magenta][/]$reset_color skip bundler"
fi
