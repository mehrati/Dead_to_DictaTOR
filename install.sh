#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}
# todo check installed package or not
function pack_arch() {
	sudo pacman -Sy 1>/dev/null 2>&1
	if ! sudo pacman -S tor proxychains-ng firefox; then
		echo "unsuccessfully install package"
	fi
	if ! yaourt -S obfs4proxy; then
		echo "unsuccessfully install package"
	fi
}

function pack_fedora() {
	if ! sudo dnf install -y tor obfs4proxy proxychains firefox; then
		echo "unsuccessfully install package"
	fi
}

function pack_deb() {
	sudo add-apt-repository ppa:hda-me/proxychains-ng
	sudo apt-get update >/dev/null
	if ! sudo apt install -y tor obfs4proxy proxychains firefox; then
		echo "unsuccess install package"
	fi
}

# function pack_suse() {
# 	if ! sudo zypper in -l -y tor obfs4proxy proxychains firefox; then
# 		echo "unsuccessfully install package"
# 		exit 1
# 	fi
# }

function check_net() {
	if ping google.com -c 1 1>/dev/null 2>&1; then
		echo "connect"
	else
		echo "you must connect to internet"

	fi
}
# todo fix this function later
function install_pack() {
	if type lsb_release 1>/dev/null 2>&1; then
		OS=$(lsb_release -si)
	else
		echo "sorry package lsb_release not installed please install it and try again"
	fi
	if echo $OS | grep "Arch" >/dev/null; then
		pack_arch
	elif echo $OS | grep "Debian" >/dev/null; then
		pack_deb
	elif echo $OS | grep "Ubuntu" >/dev/null; then
		pack_deb
	elif echo $OS | grep "Mint" >/dev/null; then
		pack_deb
	elif echo $OS | grep "Fedora" >/dev/null; then
		pack_fedora
	else
		echo "sorry ddtor not support your OS"
	fi

}

function config_ddtorrc() {
	if cat ddtorrc | grep "obfs4" >/dev/null; then
		if [ -f "/etc/tor/torrc" ]; then
			echo "Backup the old torrc to '/etc/tor/torrc.ddtor-backup'..."
			cp /etc/tor/torrc /etc/tor/torrc.ddtor-backup
			rm /etc/tor/torrc
			touch /etc/tor/torrc
		fi
		echo "Log notice syslog" | tee -a /etc/tor/torrc > /dev/null 
		echo "DataDirectory /var/lib/tor" | tee -a /etc/tor/torrc > /dev/null
		echo "UseBridges 1" | tee -a /etc/tor/torrc > /dev/null
		echo "ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" | tee -a /etc/tor/torrc > /dev/null
		sed s/" obfs4"/"bridge obfs4"/g ddtorrc | tee -a /etc/tor/torrc > /dev/null
	else
		echo "ddtroc is empty please see README file"
		exit 1
	fi
}

function install_ddtor() {
	cp ddtor.sh /bin/ && mv /bin/ddtor.sh /bin/ddtor
	chmod 755 /bin/ddtor
}

check_net
install_pack
check_root "for install"
config_ddtorrc
install_ddtor
