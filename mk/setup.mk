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

.PHONY: agents
agents: COMPONENT=agents
agents: install ## setup: global agent instructions

.PHONY: bin
bin: COMPONENT=bin
bin: install ## setup: command-line utilities

.PHONY: hypr
hypr: COMPONENT=hypr
hypr: install ## setup: hyprland (twm)

.PHONY: git
git: COMPONENT=git
git: install ## setup: git (vcs)

.PHONY: fish
fish: COMPONENT=fish
fish: install ## setup: fish (shell)

.PHONY: fisher
fisher: fish ## setup: fisher + fish plugins (tide, etc.)
	@echo $(log) "installing fisher"
	@fish -c 'functions -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher; end'
	@echo $(log) "syncing fish plugins"
	@fish -c 'fisher update'
	@echo $(log) "if the prompt still looks bare, run: tide configure"

.PHONY: ghostty
ghostty: COMPONENT=ghostty
ghostty: install ## setup: ghostty (terminal)

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
