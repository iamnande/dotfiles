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

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: ## setup: backgrounds
	@echo $(log) "installing backgrounds configs"
	$(install)

.PHONY: claude
claude: COMPONENT=claude
claude: ## setup: claude global context (~/.claude/CLAUDE.md)
	@echo $(log) "installing claude configs"
	$(install)

.PHONY: fish-clean
fish-clean:
	@rm -rf ~/.config/fish

.PHONY: fish
fish: COMPONENT=fish
fish: fish-clean ## setup: fish
	@echo $(log) "installing fish configs"
	$(install)


.PHONY: helix
helix: COMPONENT=helix
helix: ## setup: helix
	@echo $(log) "installing helix configs"
	$(install)

.PHONY: hypr
hypr: COMPONENT=hypr
hypr: ## setup: hypr
	@echo $(log) "installing hypr configs"
	$(install)

.PHONY: kitty
kitty: COMPONENT=kitty
kitty: ## setup: kitty
	@echo $(log) "installing kitty configs"
	$(install)

.PHONY: waybar
waybar: COMPONENT=waybar
waybar: ## setup: waybar
	@echo $(log) "installing waybar configs"
	$(install)

.PHONY: wofi
wofi: COMPONENT=wofi
wofi: ## setup: wofi
	@echo $(log) "installing wofi configs"
	$(install)

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: ## setup: zellij configs
	@echo $(log) "installing zellij configs"
	$(install)
