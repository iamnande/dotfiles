.PHONY: test
test: ## test: the claude-guard hook
	@echo $(log) "testing claude-guard"
	python3 -B -m unittest discover --start-directory tests
