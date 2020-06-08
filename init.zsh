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
copy ${0:A:h}/home/tmux.conf

# tig
copy ${0:A:h}/home/tigrc

# git
copy ${0:A:h}/home/gitconfig

if [[ -d ~/dev/synbioz ]] then
  decipher ${0:A:h}/home/dev/synbioz/mailmap.gpg dev/synbioz/.mailmap
  decipher ${0:A:h}/home/dev/synbioz/gitconfig.gpg dev/synbioz/.gitconfig
fi

if [[ -d ~/dev/perso ]] then
  decipher ${0:A:h}/home/dev/perso/mailmap.gpg dev/perso/.mailmap
  decipher ${0:A:h}/home/dev/perso/gitconfig.gpg dev/perso/.gitconfig
fi

# bat
copy ${0:A:h}/home/config/bat .config/bat

# Iosevka font
if [[ -d ~/git/iosevka ]] then
  copy ${0:A:h}/home/fonts/iosevka/private-build-plans.toml private-build-plans.toml
fi
