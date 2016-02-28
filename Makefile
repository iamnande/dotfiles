.PHONY: default install clean centos darwin debian link

default: clean link

centos: clean setup_centos link

darwin: clean setup_mac link

debian: clean setup_debian link

#
# make log
#
fmt := `/bin/date "+%Y-%m-%d %H:%M:%S %z [dotfiles]"`

#
# clean (remove) links
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
# setup for CentOS
#
setup_centos:
	@echo $(fmt) "configuring system for CentOS"
	@/bin/bash $(CURDIR)/bin/centos

#
# setup for mac
#
setup_mac:
	@echo $(fmt) "configuring system for mac"
	@/bin/bash $(CURDIR)/bin/darwin

#
# setup for Debian
#
setup_debian:
	@echo $(fmt) "configuring system for Debian"
	@/bin/bash $(CURDIR)/bin/debian.sh

#
# link dotfiles
#
link:
	@echo $(fmt) "symlinking .path"
	-@ln -sfn $(CURDIR)/.path $(HOME)/.path
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
	@echo $(fmt) "symlinking .prompt"
	-@ln -sfn $(CURDIR)/.prompt $(HOME)/.prompt
	@echo $(fmt) "symlinking .bash_profile"
	-@ln -sfn $(CURDIR)/.bash_profile $(HOME)/.bash_profile
