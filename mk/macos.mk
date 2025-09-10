MAC_HOSTNAME := $(shell hostname)

PKGMGR_CMD      := /opt/homebrew/bin/brew
PKGMGR_EXTRAS   := font-open-dyslexic-nerd-font
PKGMGR_PACKAGES := fontconfig neovim nerdfetch starship tree zsh

.PHONY: macos
macos: ## setup: MacOS
	@echo $(log) "setting up $(MAC_HOSTNAME) workstation"

	@echo $(log) "checking for package manager"
	@if command -v $(PKGMGR_CMD) &>/dev/null; then \
		echo $(log) "package management system is already installed"; \
	else \
		echo $(log) "installing package management system"; \
		ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

	@echo $(log) "installing dependent packages"
	@for pkg in $(PKGMGR_PACKAGES); do \
		echo $(log) "package: $$pkg"; \
		if $(PKGMGR_CMD) ls --versions $$pkg > /dev/null; then \
			echo $(log) "$$pkg already installed"; \
		else \
			$(PKGMGR_CMD) install $$pkg; \
		fi \
	done
