#
# makefile sections
#
.PHONY: all default setup_dotfiles install clean

#
# timestamp
#
ts := `/bin/date "+%Y-%m-%d %H:%M:%S %z"`

#
# section(s) for install
#
install: all

#
# all actions
#
all: clean setup_dotfiles

#
# default action
#
default: install

#
# clean (remove) links
#
clean:
	-@unlink $(HOME)/bin >/dev/null 2>&1; true
	-@unlink $(HOME)/.path >/dev/null 2>&1; true
	-@unlink $(HOME)/.bashrc >/dev/null 2>&1; true
	-@unlink $(HOME)/.extras >/dev/null 2>&1; true
	-@unlink $(HOME)/.exports >/dev/null 2>&1; true
	-@unlink $(HOME)/.aliases >/dev/null 2>&1; true
	-@unlink $(HOME)/.functions >/dev/null 2>&1; true
	-@unlink $(HOME)/.gitconfig >/dev/null 2>&1; true
	-@unlink $(HOME)/.hushlogin >/dev/null 2>&1; true
	-@unlink $(HOME)/.bash_prompt >/dev/null 2>&1; true
	-@unlink $(HOME)/.bash_profile >/dev/null 2>&1; true

#
# link dotfiles
#
setup_dotfiles:
	@ln -sfn $(CURDIR)/bin $(HOME)/bin
	@ln -sfn $(CURDIR)/.path $(HOME)/.path
	@ln -sfn $(CURDIR)/.bashrc $(HOME)/.bashrc
	@ln -sfn $(CURDIR)/.extras $(HOME)/.extras
	@ln -sfn $(CURDIR)/.exports $(HOME)/.exports
	@ln -sfn $(CURDIR)/.aliases $(HOME)/.aliases
	@ln -sfn $(CURDIR)/.functions $(HOME)/.functions
	@ln -sfn $(CURDIR)/.gitconfig $(HOME)/.gitconfig
	@ln -sfn $(CURDIR)/.hushlogin $(HOME)/.hushlogin
	@ln -sfn $(CURDIR)/.bash_prompt $(HOME)/.bash_prompt
	@ln -sfn $(CURDIR)/.bash_profile $(HOME)/.bash_profile
