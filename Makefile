.PHONY: default help clean install deps

default: help
help:
		@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
			awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-12s %s\n\033[0m", $$1, $$2}'

#
# make: app info
#
APP_NAME    := dotfiles
APP_VERSION := 0.1.0
APP_FILES   := $(shell ls $(CURDIR)/etc/*)
APP_LOG_FMT := `/bin/date "+%Y-%m-%d %H:%M:%S %z [$(APP_NAME)]"`

#
# make: clean target
#
clean: ## clean dotfiles from homedir
	@echo $(APP_LOG_FMT) "cleaning dotfiles from homedir"
	@for f in $(APP_FILES); \
		do \
			unlink $(HOME)/.`basename $$f` > /dev/null 2>&1; \
		done

#
# make: install target
#
install: deps ## install dotfiles to homedir
	@echo $(APP_LOG_FMT) "installing dotfiles"
	@for f in $(APP_FILES); \
		do \
			ln -sfn $$f $(HOME)/.`basename $$f`; \
		done

#
# make: deps target (install dependencies)
#
deps: --sudo --zsh --pkgs --git --vim --go
--sudo:
	@sudo -v

#
# make: zsh target
#
--zsh:
	@echo $(APP_LOG_FMT) "installing powerline fonts"
	@git clone --quiet --depth=1 \
		https://github.com/powerline/fonts.git \
		~/source/fonts
	@cd ~/source/fonts && ./install.sh
	@rm -rf ~/source/fonts

	@echo $(APP_LOG_FMT) "installing oh-my-zsh"
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	@echo $(APP_LOG_FMT) "installing bullet-train theme"
	@curl -fsSL -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme \
		https://raw.githubusercontent.com/caiogondim/bullet-train.zsh/master/bullet-train.zsh-theme

#
# make: pkgs target
#
OS_FLAVOR := $(shell uname -s | awk '{print tolower($$0)}')
PKG_DEPS  := $(shell echo 'autoconf curl-devel gcc gcc-c++ make ncurses-devel perl-ExtUtils-MakeMaker rpm-build tree wget zlib-devel')

--pkgs:
ifeq ($(OS_FLAVOR), linux)
	@echo $(APP_LOG_FMT) "installing base system packages"
	@for pkg in $(PKG_DEPS); \
	do \
		yum install -y -q $$pkg; \
	done
endif

#
# make: git target
#
GIT_VERSION := 2.17.0
GIT_HOME    := /usr/local/src
GIT_SOURCE  := https://github.com/git/git/archive/v$(GIT_VERSION).tar.gz

--git:
	@echo $(APP_LOG_FMT) "cleaning git install directory"
	@sudo rm -rf $(GIT_HOME)/git-*

	@echo $(APP_LOG_FMT) "installing git v$(GIT_VERSION)"
	@curl -sSL $(GIT_SOURCE) | sudo tar -C $(GIT_HOME) -zx
	@cd $(GIT_HOME)/git-$(GIT_VERSION) \
		&& sudo make configure \
		&& sudo ./configure \
		&& sudo make \
		&& sudo make install

#
# make: vim
#
VIM_VERSION := 8.0.1848
VIM_HOME    := /usr/local/src
VIM_SOURCE  := https://github.com/vim/vim/archive/v$(VIM_VERSION).tar.gz

--vim:
	@echo $(APP_LOG_FMT) "cleaning vim install directory"
	@sudo rm -rf $(VIM_HOME)/vim-*

	@echo $(APP_LOG_FMT) "installing vim v$(VIM_VERSION)"
	@curl -sSL $(VIM_SOURCE) | sudo tar -C $(VIM_HOME) -zx
	@cd $(VIM_HOME)/vim-$(VIM_VERSION) \
		&& sudo ./configure \
		&& sudo make install

#
# make: go target
#
GO_VERSION := 1.10.2
GO_HOME    := /usr/local
GO_SOURCE  := https://dl.google.com/go/go$(GO_VERSION).$(OS_FLAVOR)-amd64.tar.gz

--go:
	@echo $(APP_LOG_FMT) "cleaning go install directory"
	@sudo rm -rf $(GO_HOME)/go

	@echo $(APP_LOG_FMT) "installing go v$(GO_VERSION)"
	@curl -sSL $(GO_SOURCE) | sudo tar -v -C $(GO_HOME) -zx

