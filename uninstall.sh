#!/bin/sh

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

function pack_arch() {
	sudo pacman -R tor obfs4proxy torsocks
}
#todo fix this bug later
function pack_fedora() {
	sudo dnf remove -y tor obfs4proxy torsocks
}
#todo fix this bug later
function pack_suse() {
	sudo zypper in -l -y tor obfs4proxy torsocks
}

function pack_deb() {
	sudo apt remove -y tor obfs4proxy torsocks
}
#todo fix this bug later
function remove_pack() {
	if uname -a | grep "ARCH" >/dev/null; then
		pack_arch
	elif uname -a | grep "DEBIAN" >/dev/null; then
		pack_deb
	elif uname -a | grep "Fedora" >/dev/null; then
		pack_fedora
	elif uname -a | grep "Suse" >/dev/null; then
		pack_suse
	else
	    uninstall
		echo "sorry ddtor not support this os"
		exit 1
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

