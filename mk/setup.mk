SETUP_HOME     ?= src
SETUP_SIMULATE ?=
SETUP_TARGET   ?= ~/
SETUP_VERBOSE  ?= 1

install = cd $(SETUP_HOME) \
					&& stow \
					$(if $(SETUP_VERBOSE),--verbose) \
					$(if $(SETUP_SIMULATE),--simulate) \
					--target $(SETUP_TARGET) \
					$(COMPONENT) && cd -

install-component:
	@echo $(log) "installing $(COMPONENT) configs"
	$(install)

.PHONY: arch
arch: COMPONENT=arch
arch: install-component ## setup: arch configs

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: install-component ## setup: zellij configs

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: install-component ## setup: backgrounds

.PHONY: nvim
nvim: COMPONENT=nvim
nvim: install-component ## setup: nvim (nvim)

.PHONY: shell
shell: COMPONENT=shell
shell: install-component ## setup: shell (zsh)
shell:
	cp $(SETUP_HOME)/$@/.gitignore $(SETUP_TARGET)
	chsh -s /bin/zsh

.PHONY: terminal
terminal: COMPONENT=terminal
terminal: install-component ## setup: terminal (kitty)
