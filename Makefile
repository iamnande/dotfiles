.PHONY: help default links clean centos darwin debian link

#
# Help/Usage
#
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s %s\n", $$1, $$2}'

default: help

#
# Build Commands
#
links: clean link ## Cleanup and re-link symlinks from source to homedir

centos: clean setup_centos link ## Run build steps for a CentOS machine

darwin: clean setup_darwin link ## Run build steps for a Mac machine

debian: clean setup_debian link ## Run Build steps for a Debian machine

#
# Make Log Format
#
fmt := `/bin/date "+%Y-%m-%d %H:%M:%S %z [dotfiles]"`

#
# Cleanup (remove) Symlinks
#
clean:
	@echo $(fmt) "unlinking .path"
	-@unlink $(HOME)/.path >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .bashrc"
	-@unlink $(HOME)/.bashrc >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .extras"
	-@unlink $(HOME)/.extras >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .prompt"
	-@unlink $(HOME)/.prompt >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .exports"
	-@unlink $(HOME)/.exports >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .aliases"
	-@unlink $(HOME)/.aliases >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .functions"
	-@unlink $(HOME)/.functions >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .gitconfig"
	-@unlink $(HOME)/.gitconfig >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .hushlogin"
	-@unlink $(HOME)/.hushlogin >/dev/null 2>&1; true
	@echo $(fmt) "unlinking .bash_profile"
	-@unlink $(HOME)/.bash_profile >/dev/null 2>&1; true

#
# Build Setup for CentOS
#
setup_centos:
	@echo $(fmt) "configuring system for CentOS"
	@/bin/bash $(CURDIR)/bin/centos

#
# Build Setup for Darwin
#
setup_darwin:
	@echo $(fmt) "configuring system for Darwin"
	@/bin/bash $(CURDIR)/bin/darwin

#
# Build Setup for Debian
#
setup_debian:
	@echo $(fmt) "configuring system for Debian"
	@/bin/bash $(CURDIR)/bin/debian.sh

#
# Symlink Dotfiles to $(HOME)
#
link:
	@echo $(fmt) "symlinking .path"
	-@ln -sfn $(CURDIR)/.path $(HOME)/.path
	@echo $(fmt) "symlinking .prompt"
	-@ln -sfn $(CURDIR)/.prompt $(HOME)/.prompt
	@echo $(fmt) "symlinking .bashrc"
	-@ln -sfn $(CURDIR)/.bashrc $(HOME)/.bashrc
	@echo $(fmt) "symlinking .extras"
	-@ln -sfn $(CURDIR)/.extras $(HOME)/.extras
	@echo $(fmt) "symlinking .exports"
	-@ln -sfn $(CURDIR)/.exports $(HOME)/.exports
	@echo $(fmt) "symlinking .aliases"
	-@ln -sfn $(CURDIR)/.aliases $(HOME)/.aliases
	@echo $(fmt) "symlinking .functions"
	-@ln -sfn $(CURDIR)/.functions $(HOME)/.functions
	@echo $(fmt) "symlinking .gitconfig"
	-@ln -sfn $(CURDIR)/.gitconfig $(HOME)/.gitconfig
	@echo $(fmt) "symlinking .hushlogin"
	-@ln -sfn $(CURDIR)/.hushlogin $(HOME)/.hushlogin
	@echo $(fmt) "symlinking .bash_profile"
	-@ln -sfn $(CURDIR)/.bash_profile $(HOME)/.bash_profile
