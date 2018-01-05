#!/bin/sh

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

# function check_arch() {

# }

function check_deb() {
	sudo pacman -S tor obfs4proxy torsocks
}
# function check_net() {

# }
function install_ddtor() {
	check_root "for installing"
	if [ -f "/etc/tor/torrc" ]; then
		echo "Backup the old torrc to '/etc/tor/torrc.ddtor-backup'..."
		#sudo cp /etc/tor/torrc /etc/tor/torrc.ddtor-backup
		#echo "UseBridges 1 \nClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" | sudo tee -a /etc/tor/torrc
        if [ -f "ddtorrc" && ]; then
		#sudo sed s/"obfs4"/"bridge obfs4"/g ddtorrc >> /etc/tor/torrc
	fi
	chmod 755 ddtor.sh
	cp ddtor.sh /bin/ && mv /bin/ddtor.sh /bin/ddtor
}
install_ddtor
