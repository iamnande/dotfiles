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

.PHONY: all
all: backgrounds claude fish git hypr kitty ## setup: install all components

.PHONY: backgrounds
backgrounds: COMPONENT=backgrounds
backgrounds: ## setup: background images
	@echo $(log) "installing backgrounds"
	$(install)

.PHONY: claude
claude: COMPONENT=claude
claude: ## setup: claude skills + context
	@echo $(log) "installing claude configs"
	$(install)

.PHONY: hypr
hypr: COMPONENT=hypr
hypr: ## setup: hyprland configs
	@echo $(log) "installing hypr configs"
	$(install)

.PHONY: git
git: COMPONENT=git
git: ## setup: git config + identity
	@echo $(log) "installing git configs"
	$(install)

.PHONY: fish
fish: COMPONENT=fish
fish: ## setup: fish shell config
	@echo $(log) "installing fish configs"
	$(install)

.PHONY: kitty
kitty: COMPONENT=kitty
kitty: ## setup: kitty terminal config
	@echo $(log) "installing kitty configs"
	$(install)
