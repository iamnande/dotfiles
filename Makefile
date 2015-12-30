.PHONY: all default dotfiles install

install: all

all: dotfiles 

default: install

dotfiles:
	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp"); do f=$$(basename $$file); ln -sfn $$file $(HOME)/$$f; done
