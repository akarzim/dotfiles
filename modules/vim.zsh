# vim
if program "vim" && [[ -d ${0:A:h:h:h}/vim ]]; then
  link ${0:A:h:h:h}/vim
  copy ${0:A:h:h:h}/vim/config.vim .vimrc
else
  skip "vim"
fi
