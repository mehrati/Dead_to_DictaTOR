#!/bin/sh
function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}
function check_arch() {

}

function check_deb() {

}
function check_net() {

}
function install_ddtor() {
	rc="UseBridges 1
    ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy"
}
