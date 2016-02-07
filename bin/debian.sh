#!/bin/sh

#
# check for root
#
if [ "$EUID" -ne 0 ];
then
	echo "please run as root"
	exit
fi

# 
# install base packages
#
base() {
	apt-get update
	apt-get -y upgrade

	apt-get install -y \
			adduser \
			automake \
			bash-completion \
			bzip2 \
			ca-certificates \
			cmake \
			coreutils \
			curl \
			dnsutils \
			file \
			findutils \
			gcc \
			git \
			grep \
			gzip \
			hostname \
			indent \
			iptables \
			jq \
			less \
			locales \
			lsof \
			make \
			mount \
			openvpn \
			ssh \
			strace \
			sudo \
			tar \
			tree \
			tzdata \
			unzip \
			xclip \
			zip \
			--no-install-recommends

	apt-get autoremove
	apt-get autoclean
	apt-get clean

	install_docker
	install_go
}

# 
# setup sudo for meh
# in the great words of jfrazelle, "i know what the fuck im doing :)"
#
setup_sudo() {
	
	# add user and add to sudo group
	useradd -m -s /bin/sh nande	
	adduser nande sudo

	# add to systemd groups
	gpasswd -a nande systemd-journal
	gpasswd -a nande systemd-network

	# add go and other fun to sudo path
	{ \
		echo -e 'Defaults		secure_path="/usr/local/go/bin:/home/nande/go/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"'; \
		echo -e 'Defaults		env_keep += "ftp_proxy http_proxy no_proxy GOPATH EDITOR"'; \
		echo -e 'nande ALL=(ALL) NOPASSWD:ALL'; \
		echo -e 'nande ALL=NOPASSWD: /bin/mount, /sbin/mount.nfs, /bin/unmount, /sbin/unmount.nfs, /sbin/ifconfig, /sbin/ifup, /sbin/ifdown, /sbin/ifquery'; \
	} >> /etc/sudoers

}
