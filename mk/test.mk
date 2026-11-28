.PHONY: test
test: ## test: the hooks and the agent key lint
	@echo $(log) "testing the hooks and the lint"
	python3 -B -m unittest discover --start-directory tests
