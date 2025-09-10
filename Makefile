# .env configuration
ifneq (,$(wildcard ./.env))
	include .env
	export
endif

# core
.DEFAULT_GOAL := help
WORKDIR       := $(shell pwd)
SHELL         := /usr/bin/env bash

# vcs info
VCS_COMMIT   := $(shell git rev-parse --short=7 HEAD)
VCS_IS_DIRTY := $(shell test -n "$$(git status --porcelain)" && echo "-alpha")

# colors are pretty
# COLOR_36m
COLOR_CYAN=\033[0;36m
COLOR_GREEN=\033[0;32m
COLOR_MAGENTA=\033[0;35m
COLOR_YELLOW=\033[0;33m
COLOR_NONE=\033[0m

# project information
OWNER_NAME      := iamnande
PROJECT_NAME    := dotfiles
PROJECT_VERSION ?= $(shell cat $(WORKDIR)/VERSION)$(VCS_IS_DIRTY)
PROJECT_SLUG    := $(OWNER_NAME)-$(PROJECT_NAME)-$(PROJECT_VERSION)

# modules
include mk/log.mk
include mk/setup.mk
include mk/macos.mk
include mk/lang-go.mk
# include mk/lang-rust.mk
# include mk/lang-zig.mk
# include mk/lang-typescript.mk

.PHONY: help
help: ## available targets
	@echo -e "${COLOR_GREEN}=================================================================================${COLOR_NONE}"
	@echo -e "                    [ ${COLOR_MAGENTA}$(OWNER_NAME)${COLOR_YELLOW}/${COLOR_MAGENTA}$(PROJECT_NAME) ${COLOR_NONE} - ${COLOR_MAGENTA}$(PROJECT_VERSION)${COLOR_NONE} ] "
	@echo -e "${COLOR_GREEN}=================================================================================${COLOR_NONE}"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -k1 | \
		awk 'BEGIN {FS = ":.*?## "} \
		{printf "${COLOR_CYAN}%-12s${COLOR_NONE} %s %s\n", $$1, "    ..................................    ", $$2}'

.PHONY: version
version: ## display version
	@echo $(PROJECT_VERSION)
