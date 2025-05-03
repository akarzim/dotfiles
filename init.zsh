#!/usr/bin/env zsh
autoload -Uz colors && colors
source "functions.zsh"

version="0.6.0"

help="dotfiles $version

Usage: ${0:t} [-d | --diff] [-i | --interactive] [--diff-tool diff] [--diff-editor vim] [--git-tool git]
                [--gpg-tool gpg] [--age-tool age] [--age-key path/to/key]
                [-f | --force] [--ours | --their] [-h | --help]
                [-V | --version] [program ...]

Environment:
  DIFF        hide/show changes between files if they are different (default: 0 ; values: 0, 1)
  INTERACTIVE show changes in editor (default: 0 ; values: 0, 1)
  FORCE       overwrite or not existing files if they are different (default: 0 ; values: 0, 1)
  OURS        copy local files to dotfiles (default: 0 ; values: 0, 1)
  THEIR       copy dotfiles to local files (default: 1 ; values: 0, 1)
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
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -h | --help )
    echo $help
    exit
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
    shift; AGEKEY=$1
    echo "$fg[green](|)$reset_color age private key path is set to $AGEKEY"
    ;;
  --age-tool )
    shift; AGETOOL=$1
    echo "$fg[green](|)$reset_color age file encryption tool is set to $AGETOOL"
    ;;
  --gpg-tool )
    shift; GPGTOOL=$1
    echo "$fg[green](|)$reset_color gpg file encryption tool is set to $GPGTOOL"
    ;;
  --git-tool )
    shift; GITTOOL=$1
    echo "$fg[green](|)$reset_color git tool is set to $GITTOOL"
    ;;
  --diff-tool )
    shift; DIFFTOOL=$1; DIFF=1
    echo "$fg[green](|)$reset_color diff tool is set to $DIFFTOOL"
    ;;
  --diff-editor )
    shift; DIFFEDITOR=$1; DIFF=1; INTERACTIVE=1
    echo "$fg[green](|)$reset_color diff editor is set to $DIFFEDITOR"
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
esac; shift; done

if [[ "$1" == '--' ]]; then shift; fi

AGETOOL=${AGETOOL:-age}
GPGTOOL=${GPGTOOL:-gpg}
GITTOOL=${GITTOOL:-git}
DIFFTOOL=${DIFFTOOL:-diff}
DIFFEDITOR=${DIFFEDITOR:-${EDITOR:-vim}}
PROGRAM=${argv[@]}
THEIR=${THEIR:-1}

# Load modules
for module in ${0:A:h}/modules/*.zsh; do
  source $module
done
