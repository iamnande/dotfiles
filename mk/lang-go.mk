# NOTE:: this is an arm64 household, as the compute gods intended.
GO_VERSION ?= 1.25.1
GO_HOME    := /usr/local
GO_FLAVOR  := $(shell uname -s | awk '{print tolower($$0)}')
GO_SOURCE  := https://dl.google.com/go/go$(GO_VERSION).$(GO_FLAVOR)-arm64.tar.gz

.PHONY: go
go: ## language: go
	@echo $(log) "installing go $(GO_VERSION)"
	@sudo rm -rf $(GO_HOME)/go
	@curl -sSL $(GO_SOURCE) | sudo tar -C $(GO_HOME) -zx
