#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

function pack_arch() {
	sudo pacman -R tor obfs4proxy proxychains
}
#todo fix this bug later
function pack_fedora() {
	sudo dnf remove -y tor obfs4proxy proxychains
}
#todo fix this bug later
# function pack_suse() {
# 	sudo zypper re -l -y tor obfs4proxy 
# }

function pack_deb() {
	sudo apt remove -y tor obfs4proxy proxychains
}
#todo fix this bug later
function remove_pack() {
	if type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
	else
		echo "package lsb_release not installed please install it and try again"
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
	fi

}

function uninstall(){
	check_root "for uninstalling"
	rm /bin/ddtor 1>/dev/null 2>&1
	if [ -f "/etc/tor/torrc.ddtor-backup"] ;then
	rm /etc/tor/torrc 1>/dev/null 2>&1
	mv /etc/tor/torrc.ddtor-backup /etc/tor/torrc
	fi

}

check_root "for uninstalling"
uninstall
remove_pack

