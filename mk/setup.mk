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
all: claude hypr git ## setup: install all components

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
