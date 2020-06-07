source "functions.zsh"

# zsh
if [[ -d ${0:A:h:h}/zsh ]] then
  link ${0:A:h:h}/zsh
  copy ${0:A:h:h}/zsh/zlogin
  copy ${0:A:h:h}/zsh/zlogout
  copy ${0:A:h:h}/zsh/zprofile
  copy ${0:A:h:h}/zsh/zshenv
  copy ${0:A:h:h}/zsh/zshrc

  # zplug
  if [[ -d ~/.zplug ]] then
    copy ${0:A:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  fi
fi

# vim
if [[ -d ${0:A:h:h}/vim ]] then
  link ${0:A:h:h}/vim
  link ${0:A:h:h}/vim .config/nvim
  copy ${0:A:h:h}/vim/config.vim .vimrc
fi

# tmux
copy ${0:A:h}/tmux.conf

# tig
copy ${0:A:h}/tigrc

# git
copy ${0:A:h}/gitconfig

# bat
copy ${0:A:h}/bat .config/bat
