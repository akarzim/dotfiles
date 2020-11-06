# tealdeer
if program "tldr"; then
  copy ${0:A:h:h}/home/config/tealdeer.toml "`tldr --config-path | awk -F ': ' '{print $2}'`"
else
  skip "tldr"
fi
