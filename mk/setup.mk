SETUP_HOME     ?= src
SETUP_SIMULATE ?=
SETUP_TARGET   ?= ~/
SETUP_VERBOSE  ?= true
SETUP_OVERRIDE ?= true

install = cd $(SETUP_HOME) \
	  && stow \
	  $(if $(SETUP_OVERRIDE),--restow) \
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

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: install-component ## setup: backgrounds

.PHONY: gitconfig
gitconfig: COMPONENT=gitconfig
gitconfig: install-component ## setup: gitconfig

.PHONY: kitty
kitty: COMPONENT=kitty
kitty: install-component ## setup: kitty

.PHONY: nvim
nvim: COMPONENT=nvim
nvim: install-component ## setup: nvim (nvim)

.PHONY: starship
starship: COMPONENT=starship
starship: install-component ## setup: starship (kitty)

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: install-component ## setup: zellij configs

.PHONY: zsh
zsh: COMPONENT=zsh
zsh: install-component ## setup: zsh configs
