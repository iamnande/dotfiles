# core
.DEFAULT_GOAL := help
WORKDIR       := $(shell pwd)
SHELL         := /usr/bin/env bash

# vcs info
VCS_COMMIT   := $(shell git rev-parse --short=7 HEAD)
VCS_IS_DIRTY := $(shell test -n "$$(git status --porcelain)" && echo "-dirty")

# colors
COLOR_CYAN    := \033[0;36m
COLOR_GREEN   := \033[0;32m
COLOR_MAGENTA := \033[0;35m
COLOR_YELLOW  := \033[0;33m
COLOR_NONE    := \033[0m

# project info
OWNER_NAME   := iamnande
PROJECT_NAME := dotfiles
PROJECT_REF  := $(VCS_COMMIT)$(VCS_IS_DIRTY)

# modules
include mk/log.mk
include mk/setup.mk

.PHONY: help
help: ## available targets
	@echo -e "${COLOR_GREEN}=================================================================================${COLOR_NONE}"
	@echo -e "                    [ ${COLOR_MAGENTA}$(OWNER_NAME)${COLOR_YELLOW}/${COLOR_MAGENTA}$(PROJECT_NAME)${COLOR_NONE} - ${COLOR_MAGENTA}$(PROJECT_REF)${COLOR_NONE} ]"
	@echo -e "${COLOR_GREEN}=================================================================================${COLOR_NONE}"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -k1 | \
		awk 'BEGIN {FS = ":.*?## "} \
		{printf "${COLOR_CYAN}%-12s${COLOR_NONE} %s %s\n", $$1, "    ..................................    ", $$2}'
