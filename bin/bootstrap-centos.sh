#!/usr/bin/env bash

#
# sudo (with keep-alive)
#
get_sudo() {
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

#
# logger func
#
log() {
	local message=$1
	local timestamp=`/bin/date "+%Y-%m-%d %H:%M:%S %z"`
	local fmt="$timestamp [bootstrap] $message"
	if [[ -n $message ]];
	then
		echo "$fmt"
	fi
}

#
# install a sh!t ton of packages
#
install_packages() {
	local packages=(
		'ansible'
		'composer'
		'cmake'
		'docker'
		'dos2unix'
		'fping'
		'git'
		'gcc'
		'gcc-c++'
		'lua'
		'lua-devel'
		'ncurses'
		'ncurses-devel'
		'nmap'
		'openssl'
		'perl-Net-IP'
		'perl-XML-LibXML'
		'perl-LWP-Protocol-https'
		'rpm-build'
		'rpmdevtools'
		'ruby'
		'subversion'
		'tree'
		'unzip'
		'wget'
	)

	log "install_packages initializing"
	sudo yum update -y
	sudo yum groupinstall "Development Tools"
	sudo yum install -y ${packages[@]}
	log "install_packages terminating"
}

#
# install vim from source
#
install_vim() {
	local vim_version="7.4"
	local vim_tarball="ftp://ftp.vim.org/pub/vim/unix/vim-$vim_version.tar.bz2"

	(
		cd /usr/local/src

		sudo wget $vim_tarball
		sudo tar -zjf vim-$vim_version.tar.bz2

		cd vim74

		sudo ./configure --prefix=/usr --with-features=huge --enable-rubyinterp --enable-pythoninterp --enable-luainterp

		sudo make && sudo make install
	)
}

#
# install hub (from source)
#
install_hub() {
	local hub_version="2.2.2"
	local hub_tarball="https://github.com/github/hub/releases/download/v$hub_version/hub-linux-amd64-$hub_version.tgz"

	(
		sudo curl -sSL $hub_tarball | sudo tar -v -C /usr/local/src -zx

		cd /usr/local/src/hub-linux-amd64-$hub_version
		sudo ./install
	)
}

#
# setup dotfiles (bash/vim)
#
setup_dotfiles() {
	local homedir="/home/$USER"
	local github_account='https://github.com/wafture'
	local dotfiles_repo="$github_account/dotfiles.git"
	local vimfiles_repo="$github_account/vimfiles.git"

	(
		cd $homedir
		git clone $dotfiles_repo "$homedir/dotfiles"
		git clone --recursive $vimfiles_repo "$homedir/vimfiles"

		cd "$homedir/dotfiles"
		make

		cd "$homedir/vimfiles"
		make
	)

	source "$homedir/.bashrc"
}

#
# install golang and packages
#
setup_go() {
	local go_version="1.5.2"
	local go_source="/usr/local/go"

	if [[ -d "$go_source" ]];
	then
		sudo rm -rf "$go_source"
	fi

	# go
	(
		curl -sSL "https://storage.googleapis.com/golang/go$go_version.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -zx
	)

	# go packages
	(
		go get -v github.com/golang/lint/golint
		go get -v golang.org/x/tools/cmd/cover
		go get -v golang.org/x/tools/cmd/vet
		go get -v golang.org/x/tools/cmd/goimports

		go get -v github.com/alecthomas/kingpin

		go get -v github.com/mavricknz/asn1-ber
		go get -v github.com/mavricknz/ldap

		go get -v github.com/wafture/log
		go get -v github.com/wafture/godap
	)
}

#
# usage
#
usage() {
	echo "bootrap-centos.sh"
	echo -e "\tThis script installs my basic setup for a CentOS machine.\n"
	echo "Usage:"
	echo "  packages                    - installs base packages"
	echo "  dotfiles                    - get dotfiles"
	echo "  golang                      - install golang and packages"
}

#
# main bootstrap fuction
#
bootstrap() {
	local cmd=$1

	if [[ -z "$cmd" ]];
	then
		log "installing ALLTHETHINGS"
		bootstrap "packages"
		bootstrap "dotfiles"
		bootstrap "golang"
	fi

	if [[ $cmd == "packages" ]];
	then
		log "installing packages and apps"
		get_sudo
		install_packages
		install_vim
		install_hub
	elif [[ $cmd == "dotfiles" ]];
	then
		log "installing dotfiles"
		setup_dotfiles
	elif [[ $cmd == "golang" ]];
	then
		log "installing golang and packages"
		get_sudo
		setup_go
	else
		usage
	fi
}

#
# bootstrap my machine
#
bootstrap "$@"
