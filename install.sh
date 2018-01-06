#!/bin/sh

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

function pack_arch() {
	sudo pacman -Sy 1>/dev/null 2>&1
	if ! sudo pacman -S tor obfs4proxy proxychains-ng firefox; then
		echo "unsuccess install package"
		uninstall
	fi
}

function pack_fedora() {

	if ! sudo dnf install -y tor obfs4proxy proxychains firefox; then
		echo "unsuccess install package"
		uninstall
	fi
}

# function pack_suse() {
# 	if ! sudo zypper in -l -y tor obfs4proxy proxychains firefox; then
# 		echo "unsuccess install package"
# 		uninstall
# 		exit 1
# 	fi
# }

function pack_deb() {
	sudo apt-get update >/dev/null

	if ! sudo apt install -y tor obfs4proxy proxychains firefox; then
		echo "unsuccess install package"
		uninstall
	fi
}

function check_net() {
	if ping google.com -c 1 1>/dev/null 2>&1; then
		echo "connect"
	else
		echo "you must connect to internet"
		uninstall
	fi
}
#todo fix this bug later
function install_pack() {
	if type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
	else
		echo "package lsb_release not installed please install it and try again"
		uninstall
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
		uninstall
	fi

}
#todo fix this func later
function config_ddtorrc() {
	check_root "for cofig ddtorrc"
	if [ -f "/etc/tor/torrc" ]; then
		echo "Backup the old torrc to '/etc/tor/torrc.ddtor-backup'..."
		#sudo cp /etc/tor/torrc /etc/tor/torrc.ddtor-backup
		#echo "UseBridges 1 \nClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" | sudo tee -a /etc/tor/torrc
		if cat ddtorrc | grep "obfs4" >/dev/null; then
			#sudo sed s/"obfs4"/"bridge obfs4"/g ddtorrc >> /etc/tor/torrc
		else
			echo "ddtroc is empty please get bridge address from @ and paste this file"
			uninstall
		fi
	fi
}

function install_ddtor() {
	check_root "for installing"
	cp ddtor.sh /bin/ && mv /bin/ddtor.sh /bin/ddtor
	chmod 755 /bin/ddtor
}
function uninstall() {
	check_root "for uninstalling"
	rm /bin/ddtor 1>/dev/null 2>&1
	if [ -f "/etc/tor/torrc.ddtor-backup"]; then
		rm /etc/tor/torrc 1>/dev/null 2>&1
		mv /etc/tor/torrc.ddtor-backup /etc/tor/torrc
	fi
	exit 1
}

config_ddtorrc
install_ddtor
check_net
install_pack
