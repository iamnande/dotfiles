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

.PHONY: install-component
install-component:
	@echo $(log) "installing $(COMPONENT) configs"
	$(install)

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: install-component ## setup: backgrounds

.PHONY: claude
claude: COMPONENT=claude
claude: install-component ## setup: claude global context (~/.claude/CLAUDE.md)

.PHONY: fish-clean
fish-clean:
	@rm -rf ~/.config/fish

.PHONY: fish
fish: COMPONENT=fish
fish: fish-clean install-component ## setup: fish

.PHONY: gitconfig
gitconfig: COMPONENT=gitconfig
gitconfig: install-component ## setup: gitconfig

.PHONY: helix
helix: COMPONENT=helix
helix: install-component ## setup: helix

.PHONY: hypr
hypr: COMPONENT=hypr
hypr: install-component ## setup: hypr

.PHONY: kitty
kitty: COMPONENT=kitty
kitty: install-component ## setup: kitty

.PHONY: waybar
waybar: COMPONENT=waybar
waybar: install-component ## setup: waybar

.PHONY: wofi
wofi: COMPONENT=wofi
wofi: install-component ## setup: wofi

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: install-component ## setup: zellij configs
