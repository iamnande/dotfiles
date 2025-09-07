SETUP_TARGET ?= ~/

install = cd src && stow --verbose $(if $(SIM),--simulate) --target $(SETUP_TARGET) $(COMPONENT) && cd -

install-component:
	@echo $(log) "installing $(COMPONENT) configs"
	$(install)

.PHONY: arch
arch: COMPONENT=arch
arch: install-component ## install arch configs

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: install-component ## install backgrounds

.PHONY: editor
editor: COMPONENT=editor
editor: install-component ## install editor (nvim)

.PHONY: shell
shell: COMPONENT=shell
shell: install-component ## install shell (zsh)
shell:
	@cp src/shell/.gitignore $(SETUP_TARGET)

.PHONY: terminal
terminal: COMPONENT=terminal
terminal: install-component ## install terminal (kitty)
