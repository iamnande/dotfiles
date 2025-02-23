# foo
DEPENDENCIES = awscli $\
			   bash $\
			   brotli $\
			   buf $\
			   gh $\
			   git $\
			   golangci-lint-langserver $\
			   gopls $\
			   grpcui $\
			   helm $\
			   httpie $\
			   hub $\
			   jq $\
			   k9s $\
			   kubectl $\
			   kubectl-argo-rollouts $\
			   kubectx $\
			   kubernetes-cli $\
			   make $\
			   markdown-oxide $\
			   mockery $\
			   msgpack $\
			   neovim $\
			   pinentry $\
			   pinentry-mac $\
			   pre-commit $\
			   protobuf $\
			   redis $\
			   saml2aws $\
			   sqlite $\
			   telnet $\
			   tree $\
			   tree-sitter $\
			   tilt $\
			   wget $\
			   yaml-language-server $\
			   yq $\
			   zsh

.PHONY: install-brew
deps-manager: ## dependencies: install dependency manager
	@if command -v brew &>/dev/null; then \
		echo $(LOG_FMT) "brew already installed"; \
	else \
		echo $(LOG_FMT) "installing brew"; \
		ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; \
	fi

.PHONE: deps
deps: ## dependencies: install dependencies
	@echo $(LOG_FMT) "installing dependencies"
	@for dep in $(DEPENDENCIES); do \
		if brew ls --versions $$dep > /dev/null; then \
			echo $(LOG_FMT) "$$dep already installed"; \
		else \
			brew install $$dep; \
		fi \
	done

.PHONY: deps-update
deps-update: ## dependencies: update dependencies
	@echo $(LOG_FMT) "updating dependencies" 
	@brew update
	@brew upgrade
	@brew cleanup
