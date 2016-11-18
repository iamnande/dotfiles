.PHONY: help default clean link

#
# help / usage
#
default: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[35m%-6s => %s\n\033[0m", $$1, $$2}'

#
# make: targets
#
mac:    clean_home setup_mac link_home    ## setup mac workstation
centos: clean_home setup_centos link_home ## setup centos/rhel machine
clean:  clean_home                        ## clean workspace symlinks
links:  link_home                         ## clean workspace symlinks

#
# make: log
#
fmt := `/bin/date "+%Y-%m-%d %H:%M:%S %z make::dotfiles::"`

#
# remove symlinks to homedir
#
clean_home:
	@echo "$(fmt)$@::unlink init"
	@echo "$(fmt)$@::unlink => path"
	@unlink $(HOME)/.path >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => bashrc"
	@unlink $(HOME)/.bashrc >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => extras"
	@unlink $(HOME)/.extras >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => prompt"
	@unlink $(HOME)/.prompt >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => exports"
	@unlink $(HOME)/.exports >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => aliases"
	@unlink $(HOME)/.aliases >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => functions"
	@unlink $(HOME)/.functions >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => gitconfig"
	@unlink $(HOME)/.gitconfig >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => hushlogin"
	@unlink $(HOME)/.hushlogin >/dev/null 2>&1; true
	@echo "$(fmt)$@::unlink => bash_profile"
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
	@echo "$(fmt)$@::link init"
	@echo "$(fmt)$@::link => path"
	@ln -sfn $(CURDIR)/path $(HOME)/.path
	@echo "$(fmt)$@::link => prompt"
	@ln -sfn $(CURDIR)/prompt $(HOME)/.prompt
	@echo "$(fmt)$@::link => bashrc"
	@ln -sfn $(CURDIR)/bashrc $(HOME)/.bashrc
	@echo "$(fmt)$@::link => extras"
	@ln -sfn $(CURDIR)/extras $(HOME)/.extras
	@echo "$(fmt)$@::link => exports"
	@ln -sfn $(CURDIR)/exports $(HOME)/.exports
	@echo "$(fmt)$@::link => aliases"
	@ln -sfn $(CURDIR)/aliases $(HOME)/.aliases
	@echo "$(fmt)$@::link => functions"
	@ln -sfn $(CURDIR)/functions $(HOME)/.functions
	@echo "$(fmt)$@::link => gitconfig"
	@ln -sfn $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@echo "$(fmt)$@::link => hushlogin"
	@ln -sfn $(CURDIR)/hushlogin $(HOME)/.hushlogin
	@echo "$(fmt)$@::link => bash_profile"
	@ln -sfn $(CURDIR)/bash_profile $(HOME)/.bash_profile
	@echo "$(fmt)$@::link done"
