# tealdeer
if program "tldr" "tealdeer" && (tldr -v | grep -q 'tealdeer'); then
  copy "${0:A:h:h}/home/config/tealdeer.toml" "`tldr --show-paths | awk '/Config path/ {print $3}'`"
else
  skip "tealdeer"
fi
