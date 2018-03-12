#!/bin/bash

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

function check_package() {
	ok=true
	if ! whereis tor >/dev/null; then
		echo "[-] tor not installed"
		ok=false
	fi
	if ! whereis obfs4proxy >/dev/null; then
		echo "[-] obfs4proxy not installed"
		ok=false
	fi
	if ! whereis proxychains >/dev/null; then
		echo "[-] proxychains not installed"
		ok=false
	fi
	if ! whereis dnscrypt-proxy >/dev/null; then
		echo "[-] dnscrypt-proxy not installed"
		ok=false
	fi
	if ! whereis privoxy >/dev/null; then
		echo "[-] privoxy not installed"
		ok=false
	fi
	if [ $ok ]; then
		echo "[+] Yes All package installed"
	else
		exit 1
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
		echo "Log notice syslog" | tee -a /etc/tor/torrc >/dev/null
		echo "DataDirectory /var/lib/tor" | tee -a /etc/tor/torrc >/dev/null
		echo "UseBridges 1" | tee -a /etc/tor/torrc >/dev/null
		echo "ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" | tee -a /etc/tor/torrc >/dev/null
		sed s/" obfs4"/"bridge obfs4"/g ddtorrc | tee -a /etc/tor/torrc >/dev/null
	else
		echo "ddtroc is empty please see README file"
		exit 1
	fi
	echo "forward-socks5 / localhost:9050 ." | tee -a /etc/privoxy/config >/dev/null
	echo "http	127.0.0.1 8118" | tee -a /etc/proxychains.conf >/dev/null
	echo "server_names = ['scaleway-fr', 'google', 'yandex']" | tee -a /etc/dnscrypt-proxy/dnscrypt-proxy.toml
}

function install_ddtor() {
	cp ddtor.sh /bin/ && mv /bin/ddtor.sh /bin/ddtor
	chmod 755 /bin/ddtor
}

check_root "for install"
check_package
config_ddtorrc
install_ddtor
