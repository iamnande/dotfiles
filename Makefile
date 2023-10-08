.PHONY: default help

default: help
help: ## help: display available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-20s %s\n\033[0m", $$1, $$2}'


# repository information
SRC_NAME    := dotfiles
SRC_HOME    := ~/src/iamnande
SRC_WORKDIR := $(shell pwd)
SRC_LOG_FMT := `/bin/date "+%Y-%m-%d %H:%M:%S %z [$(SRC_NAME)]"`

# --------------------------------------------------
# Install (Symlink) Targets
# --------------------------------------------------
INSTALL_CONFIGS = $(shell find $(SRC_WORKDIR)/etc -type f)

.PHONY: clean
clean: ## core: clean home of installed configurations
	@echo $(SRC_LOG_FMT) "cleaning installed configurations from the home directory"
	@for cfg in $(INSTALL_CONFIGS); \
	do \
		unlink $(HOME)/.`basename $$cfg` > /dev/null 2>&1; true; \
	done

.PHONY: install
install: ## core: install configurations into the home directory
	@echo $(SRC_LOG_FMT) "installing configurations into the home directory"
	@for cfg in $(INSTALL_CONFIGS); \
	do \
		f=$$(basename $$cfg); \
		ln -sfn $$cfg $(HOME)/.`basename $$f`; \
	done

# --------------------------------------------------
# Package (Environment) Installation Targets
# --------------------------------------------------
BREW_PACKAGES = autoconf bash buf gcc gh git grpcui helm hub jq k9s kubectx kubernetes-cli make tilt tree vim wget zsh

.PHONY: install-brew
install-brew: ## env: install brew and core software
	@if command -v brew &>/dev/null; then \
		echo $(SRC_LOG_FMT) "brew already installed"; \
	else \
		echo $(SRC_LOG_FMT) "installing brew"; \
		ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; \
	fi

	@echo $(SRC_LOG_FMT) "installing brew formulae"
	@for pkg in $(BREW_PACKAGES); do \
		if brew ls --versions $$pkg > /dev/null; then \
			echo $(SRC_LOG_FMT) "$$pkg already installed"; \
		else \
			brew install $$pkg; \
		fi \
	done

	@echo $(SRC_LOG_FMT) "updating brew and cleaning up formulae"
	@brew cleanup
	@brew update
	@brew upgrade

.PHONY: install-zsh
install-zsh: ## env: install preferred shell
	@echo $(SRC_LOG_FMT) "installing powerline fonts"
	@git clone --quiet --depth=1 \
		https://github.com/powerline/fonts.git ~/src/powerline-fonts
	@cd ~/src/powerline-fonts && ./install.sh
	@rm -rf ~/src/powerline-fonts

	@echo $(SRC_LOG_FMT) "installing oh-my-zsh"
	@rm -rf ~/.oh-my-zsh
	@curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
	@chsh -s /bin/zsh "${USER}"

	@echo $(SRC_LOG_FMT) "installing bullet-train theme"
	@curl -fsSL -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme \
		https://raw.githubusercontent.com/caiogondim/bullet-train.zsh/master/bullet-train.zsh-theme

.PHONY: install-vimfiles
install-vimfiles: ## env: install vim setup
	@echo $(SRC_LOG_FMT) "installing vim setup"
	@rm -rf $(SRC_HOME)/vimfiles
	@git clone git@github.com:iamnande/vimfiles.git $(SRC_HOME)/vimfiles
	@cd $(SRC_HOME)/vimfiles && make

GO_VERSION := 1.21.2
GO_HOME    := /usr/local
GO_FLAVOR  := $(shell uname -s | awk '{print tolower($$0)}')
GO_SOURCE  := https://dl.google.com/go/go$(GO_VERSION).$(GO_FLAVOR)-amd64.tar.gz

.PHONY: install-go
install-go: ## env: install go
	@echo $(SRC_LOG_FMT) "installing go $(GO_VERSION)"
	@sudo rm -rf $(GO_HOME)/go
	@curl -sSL $(GO_SOURCE) | sudo tar -C $(GO_HOME) -zx
