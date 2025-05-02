PLAN?=IosevkaCustom
JCMD?=8
NICE?=1

info:
	@echo "Build name: $(PLAN)"
	@echo "Niceness: $(NICE)"
	@echo "Jobs: $(JCMD)"

plans:
	cat ./private-build-plans.toml | tomlq -t '.buildPlans | {Plans: keys}'

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
	nice -n $(NICE) npm run build -- --jCmd=$(JCMD) "ttf::$(PLAN)"
	if [ -d "${HOME}/.local/share/fonts/$(PLAN)/TTF" ]; \
		then if [ -d "${HOME}/.local/share/fonts/$(PLAN)/TTF.old" ]; \
			then rm -r "${HOME}/.local/share/fonts/$(PLAN)/TTF.old"; \
		fi; \
		mv "${HOME}/.local/share/fonts/$(PLAN)/TTF" "${HOME}/.local/share/fonts/$(PLAN)/TTF.old"; \
	fi
	cp -r "dist/$(PLAN)/TTF" "${HOME}/.local/share/fonts/$(PLAN)/TTF"
	sudo fc-cache
	@echo "Built!"

clean:		## Clean the dist font directory
	rm -r "dist/$(PLAN)/TTF"*
	@echo "Cleaned!"

uninstall:	## Uninstall the font
	rm -r "${HOME}/.local/share/fonts/$(PLAN)"
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

.PHONY: info init fetch install build clean uninstall all update upgrade help
.DEFAULT_GOAL := help
