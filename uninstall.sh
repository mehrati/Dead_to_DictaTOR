#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
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

