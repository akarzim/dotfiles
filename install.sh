#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
SCRIPT_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

if [[ -e "${BIN_HOME}/dotfiles" ]]; then
	echo "Already installed. Abort."
	exit 1
fi

if [[ ! -d "${BIN_HOME}" ]]; then
	mkdir -p "${BIN_HOME}"
fi

ln -s "${SCRIPT_PATH}/init.zsh" "${BIN_HOME}/dotfiles"

echo "Installed into ${BIN_HOME}/dotfiles"
