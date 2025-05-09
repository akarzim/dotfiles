DOTFILES_EXISTS=$(shell [ -e "$(shell which dotfiles &>/dev/null)" ] && echo 1 || echo 0 )

install:	## Install the dotfiles application
	./install.sh

uninstall:	## Uninstall the dotfiles application
	./uninstall.sh

run:		## Run the dotfiles application
ifeq ($(DOTFILES_EXISTS), 1)
	@dotfiles
else
	@echo "Please run 'make install' first. More options with 'make help'."
endif

check:		## Run the healthcheck
ifeq ($(DOTFILES_EXISTS), 1)
	@dotfiles --dry-run
else
	@echo "Please run 'make install' first. More options with 'make help'."
endif

help:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/##//'

.PHONY: install uninstall run check help
.DEFAULT_GOAL := help
