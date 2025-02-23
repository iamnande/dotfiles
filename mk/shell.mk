.PHONY: shell-install
shell-install: ## shell: install zsh
	@echo $(LOG_FMT) "installing powerline fonts"
	@git clone --quiet --depth=1 \
		https://github.com/powerline/fonts.git ~/.config/powerline-fonts
	@cd ~/.config/powerline-fonts && ./install.sh
	@rm -rf ~/.config/powerline-fonts

	@echo $(LOG_FMT) "installing oh-my-zsh"
	@rm -rf ~/.oh-my-zsh
	@curl -fsSL https://raw.githubusercontent.com/oh-my-zsh/oh-my-zsh/master/tools/install.sh | bash
	@chsh -s /bin/zsh "${USER}"

	@echo $(LOG_FMT) "installing bullet-train terminal theme"
	@curl -fsSL -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme \
		https://raw.githubusercontent.com/caiogondim/bullet-train.zsh/master/bullet-train.zsh-theme
