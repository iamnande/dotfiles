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
	@echo $(log) "installing backgrounds"
	$(install)

.PHONY: hypr
hypr: COMPONENT=hypr
hypr: ## setup: hyprland
	@echo $(log) "installing hypr"
	$(install)

.PHONY: git
git: COMPONENT=git
git: ## setup: git config
	@echo $(log) "installing git"
	$(install)

.PHONY: fish
fish: COMPONENT=fish
fish: ## setup: fish shell
	@echo $(log) "installing fish"
	$(install)

.PHONY: kitty
kitty: COMPONENT=kitty
kitty: ## setup: kitty
	@echo $(log) "installing kitty"
	$(install)

.PHONY: nvim
nvim: COMPONENT=nvim
nvim: ## setup: neovim
	@echo $(log) "installing neovim"
	$(install)

.PHONY: waybar
waybar: COMPONENT=waybar
waybar: ## setup: waybar
	@echo $(log) "installing waybar"
	$(install)

.PHONY: wofi
wofi: COMPONENT=wofi
wofi: ## setup: wofi
	@echo $(log) "installing wofi"
	$(install)

.PHONY: zed
zed: COMPONENT=zed
zed: ## setup: zed
	@echo $(log) "installing zed"
	$(install)

.PHONY: zellij
zellij: COMPONENT=zellij
zellij: ## setup: zellij
	@echo $(log) "installing zellij"
	$(install)
