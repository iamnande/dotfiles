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
# install brew
#
install_brew() {
	if ! command -v brew >/dev/null;
	then
		log "installing homebrew"
		curl -fsSL \
			'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
	else
		log "homebrew already installed.. moving on"
	fi
}

#
# update brew itself
#
update_brew() {
	brew update
}

#
# upgrade installed formulae
#
upgrade_formulae() {
	log "install_taps initializing"
	brew upgrade --all
	log "install_taps terminating"
}

#
# install a list of taps
#
install_taps() {
	local taps=(
		'homebrew/php'
		'caskroom/cask'
		'homebrew/dupes'
		'homebrew/versions'
		'homebrew/completions'
	)

	log "install_taps initializing"
	for tap in ${taps[@]};
	do
		log "tapping $tap"
		brew tap "$tap"
	done
	log "install_taps terminating"
}

#
# install a sh!t ton of bottles
#
install_bottles() {
	local bottles=(
		'coreutils'
		'moreutils'
		'findutils'
		'homebrew/dupes/grep'
		'homebrew/dupes/openssh'
		'homebrew/dupes/screen'
		'ansible'
		'bash'
		'bash-completion2'
		'boot2docker'
		'caddy'
		'cctools'
		'cifer'
		'composer'
		'dns2tcp'
		'docker'
		'docker-compose'
		'docker-machine'
		'docker-machine-parallels'
		'docker-swarm'
		'dos2unix'
		'freetype'
		'gettext'
		'git'
		'hub'
		'icu4c'
		'jpeg'
		'knock'
		'libpng'
		'libyaml'
		'lua'
		'mutt'
		'nmap'
		'node'
		'openssl'
		'packer'
		'pcre'
		'php70'
		'readline'
		'ruby'
		'shellcheck'
		'sqlite'
		'sqlmap'
		'subversion'
		'tokyo-cabinet'
		'tree'
		'unixodbc'
		'vagrant-completion'
	)

	log "install_bottles initializing"
	for bottle in ${bottles[@]};
	do
		log "installing bottle: $bottle"
		brew install "$bottle"
	done

	brew install wget --with-iri
	brew install vim --with-lua --with-system-vi

	log "install_bottles terminating"
}

#
# cleanup brew (outdated formulae)
#
cleanup_brew() {
	brew cleanup
}

#
# setup brew (install taps, bottles, etc)
#
setup_brew() {
	install_brew
	update_brew
	upgrade_formulae
	install_taps
	install_bottles
	cleanup_brew
}

#
# setup dotfiles (bash/vim)
#
setup_dotfiles() {
	local homedir="/Users/$USER"
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
		curl -sSL "https://storage.googleapis.com/golang/go$go_version.darwin-amd64.tar.gz" | sudo tar -v -C /usr/local -zx
	)

	# go packages
	(
		go get github.com/golang/lint/golint
		go get golang.org/x/tools/cmd/cover
		go get golang.org/x/tools/cmd/vet
		go get golang.org/x/tools/cmd/goimports

		go get github.com/alecthomas/kingpin

		go get github.com/mavricknz/asn1-ber
		go get github.com/mavricknz/ldap

		go get github.com/wafture/log
		go get github.com/wafture/godap
	)
}

#
# usage
#
usage() {
	echo "bootrap-mac.sh"
	echo -e "\tThis script installs my basic setup for a Mac.\n"
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
		usage
		exit 1
	fi

	if [[ $cmd == "packages" ]];
	then
		log "installing packages and apps"
		get_sudo
		setup_brew
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
# bootstrap my mac
#
bootstrap "$@"
