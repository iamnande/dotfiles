.PHONY: shell-install
shell-install: ## shell: install zsh
	@echo $(LOG_FMT) "installing powerline fonts"
	@git clone --quiet --depth=1 \
		https://github.com/powerline/fonts.git $(PROJECT_WORKDIR)/config/powerline-fonts
	@cd $(PROJECT_WORKDIR)/config/powerline-fonts && ./install.sh
	@rm -rf $(PROJECT_WORKDIR)/config/powerline-fonts

	@echo $(LOG_FMT) "installing oh-my-zsh"
	@rm -rf ~/.oh-my-zsh
	@curl -vfsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	@chsh -s /bin/zsh "${USER}"

	@echo $(LOG_FMT) "installing bullet-train terminal theme"
	@mkdir -p ~/.oh-my-zsh/themes
	@curl -vfsSL -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme \
		https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
