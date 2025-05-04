# vim
if program "vim"; then
  if [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/vim" ]]; then
    notify "please fetch vim configuration by running:"
    notify "  git clone git@github.com:akarzim/.vim.git ${XDG_CONFIG_HOME:-$HOME/.config}/vim"
    notify "  git switch config"
  elif [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/vim/.git" ]]; then
    notify "git repository not found"
  else
    copy "${XDG_CONFIG_HOME:-$HOME/.config}/vim/config.vim" ".vimrc"
    pushd "${XDG_CONFIG_HOME:-$HOME/.config}/vim"
    if (git diff --exit-code --quiet); then
      info "vim configuration is up to date!"
    else
      notify "consider versioning your recent modifications!"
      if (( $DIFF )); then
        if (( $INTERACTIVE )) && (( $+commands[$GITTOOL] )); then
          gittool_status
          if (git diff --exit-code --quiet); then
            info "vim configuration is up to date!"
          fi
        else
          git diff --no-ext-diff
        fi
      fi
    fi
    popd
  fi
else
  skip "vim"
fi
