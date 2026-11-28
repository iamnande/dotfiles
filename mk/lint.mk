# each state repo's agent gitconfig. a new ecosystem adds its own here.
AGENT_GITCONFIGS := src/git/.gitconfig-iamnande-senzu

.PHONY: lint
lint: ## lint: each agent key is trusted only in its state repo
	@echo $(log) "linting the agent keys"
	@mk/lint-agent-keys $(AGENT_GITCONFIGS)
