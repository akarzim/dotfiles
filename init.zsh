#!/usr/bin/env zsh
set -euo pipefail
IFS=$'\n\t'

autoload -Uz colors && colors
source "${0:A:h}/functions.zsh"

version="0.7.1"

help="dotfiles $version

Usage: ${0:t} [-d | --diff] [-i | --interactive] [--diff-tool diff] [--diff-editor vim] [--git-tool git]
                [--gpg-tool gpg] [--age-tool age] [--age-key path/to/key]
                [-f | --force] [--ours | --their]
                [-h | --help]
                [-V | --version]
                [-n | --dry-run] [program ...]

Environment:
  CHECK       check if changes need to be applied (default: 0; values: 0, 1)
  DIFF        hide/show changes between files if they are different (default: 0; values: 0, 1)
  INTERACTIVE show changes in editor (default: 0; values: 0, 1)
  FORCE       overwrite or not existing files if they are different (default: 0; values: 0, 1)
  OURS        copy local files to dotfiles (default: 0; values: 0, 1)
  THEIR       copy dotfiles to local files (default: 1; values: 0, 1)
  DIFFTOOL    exectuable for diffing files (default: diff)
  DIFFEDITOR  executable for editing diff (default: EDITOR)
  GITTOOL     executable for git diffing files (default: git)
  GPGTOOL     executable for the GPG file encryption tool (default: gpg)
  AGETOOL     executable for the age file encryption tool (default: age)
  AGEKEY      path to your age private key

Options:
      --age-tool=AGE_TOOL               set the age file encryption tool executable
      --gpg-tool=GPG_TOOL               set the gpg file encryption tool executable
      --git-tool=GIT_TOOL               set the git tool executable
      --diff-tool=DIFF_TOOL             set the diff tool executable
      --diff-editor=DIFF_EDITOR         set the diff editor executable
  -n, --dry-run, --no-dry-run           check if changes need to be applied
  -d, --diff, --no-diff                 show/hide changes between files if they are different
  -f, --force, --no-force               overwrite or not existing files if they are different
  -h, --help                            print this help
  -i, --interactive, --no-interactive   show changes in editor
      --ours                            copy local files to dotfiles when force is enabled
      --their                           copy dotfiles to local files when force is enabled
  -V, --version                         print the version number"

# rc file
if [[ -f ".dotfilesrc" ]]; then
  source .dotfilesrc
fi

# options
opt=${1:-}
while [[ "${opt}" =~ ^- && ! "${opt}" == "--" ]]; do case "${opt}" in
  -V | --version )
    echo $version
    exit
    ;;
  -h | --help )
    echo $help
    exit
    ;;
  -n | --dry-run )
    echo "$fg[green](|)$reset_color dry-run mode on"
    CHECK=1;
    ;;
  -d | --diff )
    echo "$fg[green](|)$reset_color diff mode on"
    DIFF=1
    ;;
  -i | --interactive )
    echo "$fg[green](|)$reset_color interactive mode on"
    INTERACTIVE=1
    ;;
  -f | --force )
    echo "$fg[red](|)$reset_color force mode on"
    FORCE=1
    ;;
  --ours )
    echo "$fg[red](|)$reset_color ours mode on"
    OURS=1
    THEIR=0
    ;;
  --their )
    echo "$fg[red](|)$reset_color their mode on"
    OURS=0
    THEIR=1
    ;;
  --age-key )
    shift; AGEKEY=$opt
    echo "$fg[green](|)$reset_color age private key path is set to $AGEKEY"
    ;;
  --age-tool )
    shift; AGETOOL=$opt
    echo "$fg[green](|)$reset_color age file encryption tool is set to $AGETOOL"
    ;;
  --gpg-tool )
    shift; GPGTOOL=$opt
    echo "$fg[green](|)$reset_color gpg file encryption tool is set to $GPGTOOL"
    ;;
  --git-tool )
    shift; GITTOOL=$opt
    echo "$fg[green](|)$reset_color git tool is set to $GITTOOL"
    ;;
  --diff-tool )
    shift; DIFFTOOL=$opt; DIFF=1
    echo "$fg[green](|)$reset_color diff tool is set to $DIFFTOOL"
    ;;
  --diff-editor )
    shift; DIFFEDITOR=$opt; DIFF=1; INTERACTIVE=1
    echo "$fg[green](|)$reset_color diff editor is set to $DIFFEDITOR"
    ;;
  --no-dry-run )
    echo "$fg[yellow](–)$reset_color dry-run mode off"
    CHECK=0
    ;;
  --no-diff )
    echo "$fg[yellow](–)$reset_color diff mode off"
    DIFF=0
    ;;
  --no-interactive )
    echo "$fg[yellow](–)$reset_color interactive mode off"
    INTERACTIVE=0
    ;;
  --no-force )
    echo "$fg[yellow](–)$reset_color force mode off"
    FORCE=0
    ;;
esac; shift; opt=${1:-}; done

if [[ "${opt}" == '--' ]]; then shift; fi

AGETOOL=${AGETOOL:-age}
GPGTOOL=${GPGTOOL:-gpg}
GITTOOL=${GITTOOL:-git}
DIFFTOOL=${DIFFTOOL:-diff}
DIFFEDITOR=${DIFFEDITOR:-${EDITOR:-vim}}
PROGRAM=$*

OURS=${OURS:-0}
THEIR=${THEIR:-1}

CHECK=${CHECK:-0}
DIFF=${DIFF:-0}
FORCE=${FORCE:-0}
INTERACTIVE=${INTERACTIVE:-0}

# Load modules
for module in ${0:A:h}/modules/*.zsh; do
  source $module
done
