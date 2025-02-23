CONFIG_DIR     := $(PROJECT_WORKDIR)/config
CONFIG_FILES   =  $(shell find $(CONFIG_DIR) -type f -depth 1)
CONFIG_MODULES =  $(shell find $(CONFIG_DIR) -type d)

.PHONY: cfg-clean
cfg-clean: ## config: remove user configurations
	@echo $(LOG_FMT) "removing $(PROJECT_NAME) configurations"
	@unlink $(HOME)/.config
	@for cfg in $(CONFIG_FILES); \
	do \
		unlink $(HOME)/.`basename $$cfg`; \
	done

.PHONY: cfg-install
cfg-install: ## config: install user configurations
	@echo $(LOG_FMT) "installing $(PROJECT_NAME) configurations"
	@ln -vsfn $(CONFIG_DIR) $(HOME)/.config
	@for cfg in $(CONFIG_FILES); \
	do \
		f=$$(basename $$cfg); \
		ln -vsfn $$cfg $(HOME)/.`basename $$f`; \
	done
