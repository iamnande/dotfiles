#!/usr/bin/env bash

# grab password upfront
sudo -v

# sudo keep-alive
while true;
do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

# ensure latest
brew update

# upgrade installed formulae
brew upgrade --all

# tap up
brew tap homebrew/php
brew tap caskroom/cask
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/completions

# core utils
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
brew install moreutils
brew install findutils

# install some OS X tools
brew install wget --with-iri
brew install vim --override-system-vi --with-lua
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# install some personal stuff
brew install ansible
brew install bash
brew install bash-completion2
brew install boot2docker
brew install caddy
brew install cctools
brew install cifer
brew install composer
brew install dns2tcp
brew install docker
brew install docker-compose
brew install docker-machine
brew install docker-machine-parallels
brew install docker-swarm
brew install dos2unix
brew install freetype
brew install gettext
brew install git
brew install go
brew install hub
brew install icu4c
brew install jpeg
brew install knock
brew install libpng
brew install libyaml
brew install lua
brew install mutt
brew install nmap
brew install node
brew install openssl
brew install packer
brew install pcre
brew install php56
brew install readline
brew install ruby
brew install shellcheck
brew install sqlite
brew install sqlmap
brew install subversion
brew install tokyo-cabinet
brew install tree
brew install unixodbc
brew install vagrant-completion

# remove outdated formulae
brew cleanup
