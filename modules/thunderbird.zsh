# thunderbird
if program "thunderbird"; then
  profile=$(awk -F= '$1 == "Default" && $2 !~ /^[[:digit:]]+$/ {print $2}' ~/.thunderbird/profiles.ini)
  copy "${0:A:h:h}/home/thunderbird/profile/extensions/gruvbox-dark@calch.themes.thunderbird.net.xpi" ".thunderbird/$profile/extensions/gruvbox-dark@calch.themes.thunderbird.net.xpi"
else
  skip "thunderbird"
fi
