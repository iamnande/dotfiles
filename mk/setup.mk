SETUP_HOME     ?= src
SETUP_SIMULATE ?=
SETUP_TARGET   ?= ~/
SETUP_VERBOSE  ?= true
SETUP_OVERRIDE ?= true

_install_component = cd $(SETUP_HOME) \
	&& stow \
	$(if $(SETUP_OVERRIDE),--restow) \
	$(if $(SETUP_VERBOSE),--verbose) \
	$(if $(SETUP_SIMULATE),--simulate) \
	--target $(SETUP_TARGET) \
	$(COMPONENT) && cd -

.PHONY: install
install:
	@echo $(log) "installing $(COMPONENT)"
	$(_install_component)

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: install ## setup: backgrounds (weeb)
.PHONY: hypr
hypr: COMPONENT=hypr
hypr: install ## setup: hyprland (twm)

.PHONY: git
git: COMPONENT=git
git: install ## setup: git (vcs)

.PHONY: fish
fish: COMPONENT=fish
fish: install ## setup: fish (shell)

.PHONY: kitty
kitty: COMPONENT=kitty
kitty:  install## setup: kitty (terminal)

.PHONY: helix
helix: COMPONENT=helix
helix:  install## setup: helix (editor)

.PHONY: waybar
waybar: COMPONENT=waybar
waybar: install ## setup: waybar (status)

.PHONY: wofi
wofi: COMPONENT=wofi
wofi: install ## setup: wofi (nav)

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: install ## setup: zellij (sessions)
