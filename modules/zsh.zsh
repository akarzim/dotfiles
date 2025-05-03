# zsh
if program "zsh"; then
  if [[ ! -d ${0:A:h:h:h}/zsh ]]; then
    notify "please fetch zsh configuration by running:"
    notify "  git clone git@github.com:akarzim/.zsh.git ${0:A:h:h:h}/zsh"
    notify "  git switch config"
  elif [[ ! -d ${0:A:h:h:h}/zsh/.git ]]; then
    notify "git repository not found"
  else
    link ${0:A:h:h:h}/zsh
    link ${0:A:h:h:h}/zsh/zfunctions
    link ${0:A:h:h:h}/zsh/zlogin
    link ${0:A:h:h:h}/zsh/zlogout
    link ${0:A:h:h:h}/zsh/zprofile
    link ${0:A:h:h:h}/zsh/zshenv
    link ${0:A:h:h:h}/zsh/zshrc
    decipher ${0:A:h:h}/home/zsecrets.age .zsecrets

    pushd ${0:A:h:h:h}/zsh
    if (git diff --exit-code --quiet); then
      info "zsh configuration is up to date!"
    else
      notify "consider versioning your recent modifications!"
      if (( $DIFF )); then
        if (( $INTERACTIVE )) && (( $+commands[tig] )); then
          tig status
          if (git diff --exit-code --quiet); then
            info "zsh configuration is up to date!"
          fi
        else
          git diff --no-ext-diff
        fi
      fi
    fi
    popd
  fi

  # zplug
  if [[ -d $HOME/.zplug ]]; then
    copy ${0:A:h:h:h}/zsh/zplug-packages.zsh .zplug/packages.zsh
  else
    skip "zplug"
  fi
else
  skip "zsh"
fi
