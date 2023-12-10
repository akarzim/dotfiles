# tealdeer
if program "tldr" && (tldr -v | grep -q 'tealdeer'); then
  copy ${0:A:h:h}/home/config/tealdeer.toml "`tldr --show-paths | awk '/Config path/ {print $3}'`"
else
  skip "tldr"
fi
