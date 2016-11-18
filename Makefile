.PHONY: help default clean link

#
# help / usage
#
default: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s %s\n\033[0m", $$1, $$2}'

#
# make: targets
#
clean:  clean_home   ## clean workspace symlinks
link:   link_home    ## link workspace symlinks to homedir
centos: setup_centos ## setup centos/rhel machine
mac:    setup_mac    ## setup mac workstation

#
# make: log
#
fmt := `/bin/date "+%Y-%m-%d %H:%M:%S %z make::"`

#
# Cleanup (remove) Symlinks
#
clean_home:
	@echo "$(fmt)$@::unlink init"
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
	@echo "$(fmt)$@::unlink done"

#
# setup centos machine
#
setup_centos:
	@echo "$(fmt)$@::setup init"
	@/bin/bash $(CURDIR)/bin/centos
	@echo "$(fmt)$@::setup done"

#
# setup mac workstation
#
setup_mac:
	@echo "$(fmt)$@::setup init"
	@/bin/bash $(CURDIR)/bin/mac
	@echo "$(fmt)$@::setup done"

#
# symlink workspace to homedir
#
link_home:
	@echo $(fmt) "$@::link init"
	@ln -sfn $(CURDIR)/.path $(HOME)/.path
	@ln -sfn $(CURDIR)/.prompt $(HOME)/.prompt
	@ln -sfn $(CURDIR)/.bashrc $(HOME)/.bashrc
	@ln -sfn $(CURDIR)/.extras $(HOME)/.extras
	@ln -sfn $(CURDIR)/.exports $(HOME)/.exports
	@ln -sfn $(CURDIR)/.aliases $(HOME)/.aliases
	@ln -sfn $(CURDIR)/.functions $(HOME)/.functions
	@ln -sfn $(CURDIR)/.gitconfig $(HOME)/.gitconfig
	@ln -sfn $(CURDIR)/.hushlogin $(HOME)/.hushlogin
	@ln -sfn $(CURDIR)/.bash_profile $(HOME)/.bash_profile
	@echo $(fmt) "$@::link done"
