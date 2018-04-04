.PHONY: default help clean install vim git go

default: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[m%-12s %s\n\033[0m", $$1, $$2}'
#
# make: info
#
APP_NAME    := dotfiles
APP_VERSION := 1.0
GIT_COMMIT  := $(shell git rev-list --count HEAD)
GIT_BRANCH  := $(shell git rev-parse --abbrev-ref HEAD)
ifeq ($(GIT_BRANCH), master)
	APP_VERSION := $(APP_VERSION).$(GIT_COMMIT)
else
	APP_VERSION := $(APP_VERSION).$(GIT_COMMIT).$(GIT_BRANCH)
endif

#
# make: install info
#
DOT_FILES := $(shell ls $(CURDIR)/conf/*)
OS_FLAVOR := $(shell uname -s | awk '{print tolower($$0)}')

#
# make: formatted logger
#
log := `/bin/date "+%Y-%m-%d %H:%M:%S %z [$(APP_NAME)]"`

all: git go vim clean install ## install dotfiles and software

install: ## install dotfiles
	@echo $(log) "installing dotfiles"
	@for f in $(DOT_FILES); \
		do \
			ln -sfn $$f $(HOME)/.`basename $$f`; \
	done

clean: ## clean dotfiles
	@echo $(log) "cleaning dotfiles"
	@for f in $(DOT_FILES); \
		do \
			unlink $(HOME)/.`basename $$f` >/dev/null 2>&1; \
	done

sudo:
	@sudo -v

#
# make: git
#
GIT_VERSION := 2.17.0
GIT_HOME    := /usr/local/src
GIT_SOURCE  := https://github.com/git/git/archive/v$(GIT_VERSION).tar.gz

git: sudo ## install git
	@echo $(log) "cleaning $@ install directory"
	@sudo rm -rf $(GIT_HOME)/$@-*

	@echo $(log) "installing $@ v$(GIT_VERSION)"
	@curl -sSL $(GIT_SOURCE) | sudo tar -C $(GIT_HOME) -zx
	@cd $(GIT_HOME)/$@-$(GIT_VERSION) \
		&& sudo make configure \
		&& sudo ./configure \
		&& sudo make \
		&& sudo make install

#
# make: go
#
GO_VERSION := 1.10.1
GO_HOME    := /usr/local
GO_SOURCE  := https://dl.google.com/go/go$(GO_VERSION).$(OS_FLAVOR)-amd64.tar.gz

go: sudo ## install go
	@echo $(log) "cleaning $@ install directory"
	@sudo rm -rf $(GO_HOME)/$@

	@echo $(log) "installing $@ v$(GO_VERSION)"
	@curl -sSL $(GO_SOURCE) | sudo tar -v -C $(GO_HOME) -zx

#
# make: vim
#
VIM_VERSION := 8.0.1659
VIM_HOME    := /usr/local/src
VIM_SOURCE  := https://github.com/vim/vim/archive/v$(VIM_VERSION).tar.gz

vim: sudo ## install vim
	@echo $(log) "cleaning $@ install directory"
	@sudo rm -rf $(VIM_HOME)/$@-*

	@echo $(log) "installing $@ v$(VIM_VERSION)"
	@curl -sSL $(VIM_SOURCE) | sudo tar -C $(VIM_HOME) -zx
	@cd $(VIM_HOME)/$@-$(VIM_VERSION) \
		&& sudo ./configure \
		&& sudo make install
