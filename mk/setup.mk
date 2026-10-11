SETUP_HOME     ?= src
SETUP_SIMULATE ?=
SETUP_TARGET   ?= ~/
SETUP_VERBOSE  ?= true
SETUP_OVERRIDE ?= true

COMPONENTS := agents backgrounds bin fish ghostty git helix hypr mako ssh waybar wofi zellij

_install_component = cd $(SETUP_HOME) \
	&& stow \
	$(if $(SETUP_OVERRIDE),--restow) \
	$(if $(SETUP_VERBOSE),--verbose) \
	$(if $(SETUP_SIMULATE),--simulate) \
	--target $(SETUP_TARGET) \
	$(1) && cd -

# each component has its own recipe. a shared prerequisite runs once per
# invocation, so `make a b` would only install a.
.PHONY: $(COMPONENTS)
$(COMPONENTS):
	@echo $(log) "installing $@"
	$(call _install_component,$@)

.PHONY: all
all: $(COMPONENTS) ## setup: every component

backgrounds: ## setup: backgrounds (weeb)

agents: ## setup: global agent instructions

bin: ## setup: command-line utilities

hypr: ## setup: hyprland (twm)

git: ## setup: git (vcs)

fish: ## setup: fish (shell)

.PHONY: fisher
fisher: fish ## setup: fisher + fish plugins (tide, etc.)
	@echo $(log) "installing fisher"
	@fish -c 'functions -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher; end'
	@echo $(log) "syncing fish plugins"
	@fish -c 'fisher update'
	@echo $(log) "if the prompt still looks bare, run: tide configure"

ghostty: ## setup: ghostty (terminal)

helix: ## setup: helix (editor)

mako: ## setup: mako (notifications)

ssh: ## setup: ssh (client)

waybar: ## setup: waybar (status)

wofi: ## setup: wofi (nav)

zellij: ## setup: zellij (sessions)

.PHONY: guardrails
guardrails: agents ## setup: claude guardrails (hook + ~/.claude/settings.json)
	test -f ~/.claude/settings.json || echo '{}' > ~/.claude/settings.json
	jq -s '.[0] * .[1]' ~/.claude/settings.json guardrails/settings.json > ~/.claude/settings.json.tmp
	mv ~/.claude/settings.json.tmp ~/.claude/settings.json
