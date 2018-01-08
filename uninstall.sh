#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

function pack_arch() {
	pacman -R tor obfs4proxy proxychains
}
#todo fix this bug later
function pack_fedora() {
	dnf remove -y tor obfs4proxy proxychains
}
#todo fix this bug later
# function pack_suse() {
# 	sudo zypper re -l -y tor obfs4proxy 
# }

function pack_deb() {
	apt remove -y tor obfs4proxy proxychains
}
#todo fix this bug later
function remove_pack() {
	if type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
	else
		echo "sorry you must romve package tor,obfs4proxy,proxychains manually"
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
	rm /bin/ddtor 2>/dev/null
	if [ -f "/etc/tor/torrc.ddtor-backup"] ;then
	rm /etc/tor/torrc 2>/dev/null
	mv /etc/tor/torrc.ddtor-backup /etc/tor/torrc 2>/dev/null
	fi

}

check_root "for uninstalling"
uninstall
remove_pack

