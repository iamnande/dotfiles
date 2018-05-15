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
# make: install info
#
OS_FLAVOR := $(shell uname -s | awk '{print tolower($$0)}')

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
deps:
	@echo $(APP_LOG_FMT) "installing powerline fonts"
	@git clone --quiet --depth=1 \
		https://github.com/powerline/fonts.git \
		~/source/fonts
	@cd ~/source/fonts && ./install.sh
	@rm -rf ~/source/fonts

	@echo $(APP_LOG_FMT) "installing oh-my-zsh"
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	@echo $(APP_LOG_FMT) "installing bullet-train theme"
	@curl -fsSL -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme https://raw.githubusercontent.com/caiogondim/bullet-train.zsh/master/bullet-train.zsh-theme
