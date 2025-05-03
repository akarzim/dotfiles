# nvim
if program "nvim"; then
  if [[ ! -d ${XDG_CONFIG_HOME:-$HOME/.config}/nvim ]]; then
    notify "please fetch nvim configuration by running:"
    notify "  git clone git@github.com:akarzim/kickstart.nvim.git ${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    notify "  git switch config"
  elif [[ ! -d ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/.git ]]; then
    notify "git repository not found"
  else
    pushd ${XDG_CONFIG_HOME:-$HOME/.config}/nvim
    if (git diff --exit-code --quiet); then
      info "nvim configuration is up to date!"
    else
      notify "consider versioning your recent modifications!"
      if (( $DIFF )); then
        if (( $INTERACTIVE )) && (( $+commands[$GITTOOL] )); then
          gittool_status
          if (git diff --exit-code --quiet); then
            info "nvim configuration is up to date!"
          fi
        else
          git diff --no-ext-diff
        fi
      fi
    fi
    popd
  fi
else
  skip "nvim"
fi
