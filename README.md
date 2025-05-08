<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/akarzim/dotfiles">
    <img src="images/logo.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Dotfiles</h3>

  <p align="center">
    My personal dotfiles.
    <br />
    <a href="https://github.com/akarzim/dotfiles"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/akarzim/dotfiles/issues">Report Bug</a>
    ·
    <a href="https://github.com/akarzim/dotfiles/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Miscellanea](#miscellanea)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)

## About The Project

This repo hosts my personal dotfiles.

[![Dotfiles Screen Shot][screenshot]][screenshot]

### Built With

* [ZSH](http://zsh.sourceforge.net/)

## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

* macOS

```sh
brew install bat exa fd fzf git git-delta htop ncdu neovim ripgrep sqlparse \
             tig tldr tmux tree universal-ctags watch z zplug
```

Plus for [age] file encryption tool support:

```sh
brew tap filippo.io/age https://filippo.io/age
brew install age
```

[age]: https://github.com/FiloSottile/age

### Installation

1. Clone the repo

```sh
git clone https://github.com/akarzim/dotfiles.git
```

2. Install dotfiles

```sh
cd dotfiles && ./init.zsh
```

## Makefile

A Makefile exists to install, uninstall, run & check dotfiles.

```
make help

install:	Install the dotfiles application
uninstall:	Uninstall the dotfiles application
run:		Run the dotfiles application
check:		Run the healthcheck
help:		Show this help
```

## Usage

```
Usage: init.zsh [-d | --diff] [-i | --interactive] [--diff-tool diff] [--diff-editor vim] [--git-tool git]
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
```

NOTE: Environment variables can be set in a `.dotfilesrc` file.
      An example is available in `dotfilesrc.sample`.

Add support for other dotfiles by creating new `.zsh` files under the `modules/`
directory. You have some functions at your disposal:

- `link SOURCE [DOTFILE]` to create a symlink from `SOURCE` to `DOTFILE`
- `copy SOURCE [DOTFILE]` to copy the `SOURCE` file to the `DOTFILE` destination
- `decipher SOURCE [DOTFILE]` to copy an encrypted `SOURCE` file to the `DOTFILE` destination
- `rlink DIRECTORY SOURCE [DOTFILE]` recursively link `SOURCE` to `DOTFILE` in `DIRECTORY` subdirectories
- `rcopy DIRECTORY SOURCE [DOTFILE]` recursively copy `SOURCE` to `DOTFILE` in `DIRECTORY` subdirectories
- `rdecipher DIRECTORY SOURCE [DOTFILE]`recursively decipher `SOURCE` to `DOTFILE` in `DIRECTORY` subdirectories
- `module MODULE` to check if `MODULE` is required
- `program PROGRAM` to check if `PROGRAM` is executable

NOTE: The last argument is optional. If it is missing, it will be forged from
      the file name `SOURCE` prefixed with a period.

### Cache

A caching policy is also available to avoid useless computations:

- `caching_policy DIRECTORY` returns true if the cache is obslolete.

### A la carte

By providing your program selection, you can update a subset of the available
configuration. For example, to choose only zsh and git, just call `./init.zsh
zsh git` and that's it.

## Miscellanea

1. `init.zsh` and `functions.zsh` contain ZSH syntax which is not Bash compatible:
   - Glob qualifiers[^1]
   - Character Highlighting[^2]
1. `functions.zsh` contains BSD-based specific regex syntax[^3]

## Roadmap

See the [open issues](https://github.com/akarzim/dotfiles/issues) for a list of
proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to
be learn, inspire, and create. Any contributions you make are **greatly
appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

François Vantomme - [@akarzim](https://mastodon.host/@akarzim)

Project Link: <https://github.com/akarzim/dotfiles>

## Acknowledgements

* [Othneil Drew][othneildrew] for [this readme template][readme-template]
* [DevHints.io][devhints] for [this Bash cheatsheet][bash]

<!-- footnotes -->
[^1]: http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers
[^2]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
[^3]: https://stackoverflow.com/a/12696899/1340861

<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/akarzim/dotfiles.svg?style=flat-square
[contributors-url]: https://github.com/akarzim/dotfiles/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/akarzim/dotfiles.svg?style=flat-square
[forks-url]: https://github.com/akarzim/dotfiles/network/members
[stars-shield]: https://img.shields.io/github/stars/akarzim/dotfiles.svg?style=flat-square
[stars-url]: https://github.com/akarzim/dotfiles/stargazers
[issues-shield]: https://img.shields.io/github/issues/akarzim/dotfiles.svg?style=flat-square
[issues-url]: https://github.com/akarzim/dotfiles/issues
[license-shield]: https://img.shields.io/github/license/akarzim/dotfiles.svg?style=flat-square
[license-url]: https://github.com/akarzim/dotfiles/blob/master/LICENSE.txt
[screenshot]: images/screenshot.png
[othneildrew]: https://github.com/othneildrew
[readme-template]: https://github.com/othneildrew/Best-README-Template
[devhints]: https://devhints.io/
[bash]: https://devhints.io/bash
