# .env configuration
ifneq (,$(wildcard ./.env))
	include .env
	export
endif

# project information
OWNER_NAME       := iamnande
PROJECT_NAME     := dotfiles
PROJECT_WORKDIR  := $(shell pwd)
PROJECT_REPO     := github.com/$(OWNER_NAME)/$(PROJECT_NAME)
PROJECT_COMMIT   ?= $(shell git rev-parse --short=7 HEAD)
PROJECT_VERSION  ?= $(shell cat $(PROJECT_WORKDIR)/VERSION)

# settings & utils
.DEFAULT_GOAL := help
SHELL         := /usr/bin/env bash
LOG_FMT       := `/bin/date "+%Y-%m-%d %H:%M:%S %z [$(PROJECT_NAME) - $(PROJECT_VERSION) - $(PROJECT_COMMIT)]"`

# modules
include mk/configs.mk
include mk/dependencies.mk
include mk/lang-go.mk
# include mk/lang-rust.mk
# include mk/lang-zig.mk
# include mk/lang-typescript.mk
include mk/shell.mk

# help me obi wan kenobi, you're my only hope
.PHONY: help
help: ## help: display available targets
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -k1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@grep -h -E '^[a-zA-Z0-9_-]+/[a-zA-Z0-9/_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk '{print $$1}' | \
		awk -F/ '{print $$1}' | \
		sort -u | \
		while read section ; do \
		echo; \
		grep -h -E "^$$section/[^:]+:.*?## .*$$" $(MAKEFILE_LIST) | sort -k1 | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ; \
		done
