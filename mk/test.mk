.PHONY: test
test: ## test: the claude-guard and git hooks
	@echo $(log) "testing the hooks"
	python3 -B -m unittest discover --start-directory tests
