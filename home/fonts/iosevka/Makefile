init:		## Clone the repository
	git clone --depth 1 https://github.com/be5invis/Iosevka.git
	@echo "Initialized!"

fetch:		## Fetch the latest changes
	git switch main
	git pull --rebase
	@echo "Fetched!"

preinstall:	## Install system dependencies
	sudo apt install ttfautohint
	@echo "Installed!"

bundle:		## Install node dependencies
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	export NVM_DIR="${HOME}/.nvm"; \
	. "${NVM_DIR}/nvm.sh"  # This loads nvm
	nvm install --lts; \
	nvm use --lts; \
	npm install
	@echo "Bundled!"

build:		## Build the font
	nice -n 1 npm run build -- ttf::IosevkaCustom
	if [ -d ~/.local/share/fonts/IosevkaCustom/TTF ]; \
		then if [ -d ~/.local/share/fonts/IosevkaCustom/TTF.old ]; \
			then rm -r ~/.local/share/fonts/IosevkaCustom/TTF.old; \
		fi; \
		mv ~/.local/share/fonts/IosevkaCustom/TTF ~/.local/share/fonts/IosevkaCustom/TTF.old; \
	fi
	cp -r dist/IosevkaCustom/TTF ~/.local/share/fonts/IosevkaCustom/TTF
	sudo fc-cache
	@echo "Built!"

clean:		## Clean the dist font directory
	rm -r dist/IosevkaCustom/TTF*
	@echo "Cleaned!"

uninstall:	## Uninstall the font
	rm -r ~/.local/share/fonts/IosevkaCustom
	sudo fc-cache
	@echo "Uninstalled!"

CURRENT_TAG := $(shell git describe --tags)
LATEST_TAG := $(shell git describe --tags $(shell git rev-list --tags --max-count=1))
check:		## Find the latest version
	git fetch --all
	@echo "current version: $(CURRENT_TAG)"
	@echo "latest version: $(LATEST_TAG)"

install: preinstall bundle		## Install all dependencies

all: init fetch install build clean	## First run

update: fetch build clean		## Update the font

upgrade: fetch install build clean	## Update dependencies & the font

help:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/##//'

.PHONY: init fetch install build clean uninstall all update upgrade help
.DEFAULT_GOAL := help
