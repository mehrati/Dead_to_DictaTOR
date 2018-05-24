#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "you must be run as root"
		exit 1
	fi
}

function check_package() {

	if ! which tor >/dev/null 2>&1; then
		echo "[-] tor not installed"
		pacman -S tor
	fi
	if ! which torsocks >/dev/null 2>&1; then
		echo "[-] torsocks not installed"
		pacman -S torsocks
	fi
	if ! which obfs4proxy >/dev/null 2>&1; then
		echo "[-] obfs4proxy not installed"
		echo '[archlinuxcn]' | sudo tee -a /etc/pacman.conf >/dev/null
		echo 'SigLevel = Never' | sudo tee -a /etc/pacman.conf >/dev/null
		echo 'Server = http://repo.archlinuxcn.org/$arch' | tee -a /etc/pacman.conf >/dev/null
		pacman -Sy
		pacman -S obfs4proxy
	fi
	if ! which dnscrypt-proxy >/dev/null 2>&1; then
		echo "[-] dnscrypt-proxy not installed"
		pacman -S dnscrypt-proxy
	fi
	if ! which privoxy >/dev/null 2>&1; then
		echo "[-] privoxy not installed"
		pacman -S privoxy
	fi
}

function config_ddtor() {
	if cat ddtorrc | grep "obfs4" >/dev/null; then
		if [ -f "/etc/tor/torrc" ]; then
			echo "Backup the old torrc to '/etc/tor/torrc-ddtor-backup'"
			cp /etc/tor/torrc /etc/tor/torrc-ddtor-backup
			rm /etc/tor/torrc
			touch /etc/tor/torrc
		fi
		path_obfs4=$(which obfs4proxy)
		echo "Log notice syslog" | tee -a /etc/tor/torrc >/dev/null
		echo "DataDirectory /var/lib/tor" | tee -a /etc/tor/torrc >/dev/null
		echo "UseBridges 1" | tee -a /etc/tor/torrc >/dev/null
		echo "ClientTransportPlugin obfs4 exec $path_obfs4" | tee -a /etc/tor/torrc >/dev/null
		sed s/" obfs4"/"bridge obfs4"/g ddtorrc | tee -a /etc/tor/torrc >/dev/null
	else
		echo "ddtroc is empty please see README file"
		exit 1
	fi
	lineNumPri="$(grep -n "forward-socks5t   /               127.0.0.1:9050 ." /etc/privoxy/config | head -n 1 | cut -d: -f1)"
	sed -i "$lineNumPri s/^##*//" /etc/privoxy/config
	lineNumDns="$(grep -n "server_names = " /etc/dnscrypt-proxy/dnscrypt-proxy.toml | head -n 1 | cut -d: -f1)"
	sed -i "$lineNumDns s/^##*//" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
}

function install_ddtor() {
	cp ddtor.sh /bin/ && mv /bin/ddtor.sh /bin/ddtor
	chmod 755 /bin/ddtor
}

check_root
check_package
if [[ $? -eq 0 ]]; then
	echo "[+] Ok all package installed"
	config_ddtor
	install_ddtor
fi
