#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

if [[ "$(readlink -f "${BIN_HOME}/dotfiles")" == "${SCRIPT_PATH}/init.zsh" ]]; then
	rm "${BIN_HOME}/dotfiles"
	echo "Uninstalled ${BIN_HOME}/dotfiles"
else
	echo "Nothing to uninstall. Abort."
	exit 1
fi
