.PHONY: all clean bootstrap links

all: clean bootstrap links

bootstrap:
	@/bin/bash $(CURDIR)/bin/bootstrap golang
	@/bin/bash $(CURDIR)/bin/bootstrap github
	@/bin/bash $(CURDIR)/bin/bootstrap vimfiles
	@/bin/bash $(CURDIR)/bin/bootstrap terraform

links:
	@ln -sfn $(CURDIR)/path $(HOME)/.path
	@ln -sfn $(CURDIR)/prompt $(HOME)/.prompt
	@ln -sfn $(CURDIR)/bashrc $(HOME)/.bashrc
	@ln -sfn $(CURDIR)/extras $(HOME)/.extras
	@ln -sfn $(CURDIR)/exports $(HOME)/.exports
	@ln -sfn $(CURDIR)/aliases $(HOME)/.aliases
	@ln -sfn $(CURDIR)/functions $(HOME)/.functions
	@ln -sfn $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@ln -sfn $(CURDIR)/hushlogin $(HOME)/.hushlogin
	@ln -sfn $(CURDIR)/bash_profile $(HOME)/.bash_profile

clean:
	@unlink $(HOME)/.path >/dev/null 2>&1; true
	@unlink $(HOME)/.bashrc >/dev/null 2>&1; true
	@unlink $(HOME)/.extras >/dev/null 2>&1; true
	@unlink $(HOME)/.prompt >/dev/null 2>&1; true
	@unlink $(HOME)/.exports >/dev/null 2>&1; true
	@unlink $(HOME)/.aliases >/dev/null 2>&1; true
	@unlink $(HOME)/.functions >/dev/null 2>&1; true
	@unlink $(HOME)/.gitconfig >/dev/null 2>&1; true
	@unlink $(HOME)/.hushlogin >/dev/null 2>&1; true
	@unlink $(HOME)/.bash_profile >/dev/null 2>&1; true

