# nvim
if program "nvim" && [[ -d ${0:A:h:h:h}/vim ]]; then
  link ${0:A:h:h:h}/vim .config/nvim
else
  skip "nvim"
fi
