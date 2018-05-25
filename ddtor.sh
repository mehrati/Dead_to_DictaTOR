#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
VER='0.5'

usage() {

	echo "Dead to Dictator"
	echo "This script use tor,privoxy,dnscrypt,proxychain for passing the boycott "
	echo "Usage:$ ddtor [OPTION]..."
	echo "Options:"
	echo "  -u, --start"
	echo "    Start | Up Services"
	echo "  -d, --stop"
	echo "    Stop | Down Services"
	echo "  -s, --status"
	echo "    Status Services"
	echo "  -b, --update-bridge"
	echo "    Update Tor Bridge"
	echo "  -h, --help"
	echo "    Show Help Massage"
	echo "  -v, --version"
	echo "    Show Script Version"

	exit 0
}
function start_service() {
	con_net
	isactivedns=$(sudo systemctl is-active dnscrypt-proxy.service)
	if [ $isactivedns == "inactive" ]; then
		sudo systemctl start dnscrypt-proxy.service
		echo -e "${GREEN}[+] Dnscrypt-proxy Start ${NC}"
	fi
	sleep 1
	isfaileddns=$(sudo systemctl is-failed dnscrypt-proxy.service)
	if [ $isfaileddns == "failed" ]; then
		echo -e "${RED}[-] Dnscrypt-proxy Failed${NC}"
		restart_dns
		isactivedns=$(sudo systemctl is-active dnscrypt-proxy.service)
		if [ $isactivedns == "active" ]; then
			echo -e "${GREEN}[+] Dnscrypt-proxy Start ${NC}"
		else
			echo -e "${RED}[-] Dnscrypt-proxy Problem ${NC}"
			stop_service >/dev/null
			exit 1
		fi
	fi
	sudo cp /etc/resolv.conf /etc/resolv.tmp-ddtor.conf
	sudo echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf >/dev/null
	isactivetor=$(sudo systemctl is-active tor.service)
	if [ $isactivetor == "inactive" ]; then
		sudo systemctl start tor.service
		echo -e "${GREEN}[+] Tor Start${NC}"
	fi
	sleep 1
	isfailedtor=$(sudo systemctl is-failed tor.service)
	if [ $isfailedtor == "failed" ]; then
		echo -e "${RED}[-] Tor Failed${NC}"
		restart_tor
		isactivetor=$(sudo systemctl is-active tor.service)
		if [ $isactivetor == "active" ]; then
			echo -e "${GREEN}[+] Tor Start ${NC}"
		else
			echo -e "${RED}[-] Tor Problem ${NC}"
			stop_service >/dev/null
			exit 1
		fi
	fi
	isactivepri=$(sudo systemctl is-active privoxy.service)
	if [ $isactivepri == "inactive" ]; then
		sudo systemctl start privoxy.service
		echo -e "${GREEN}[+] Privoxy Start ${NC}"
	fi
	sleep 1
	isfailedpri=$(sudo systemctl is-failed privoxy.service)
	if [ $isfailedpri == "failed" ]; then
		echo -e "${RED}[-] Privoxy Failed${NC}"
		restart_privoxy
		isactivepri=$(sudo systemctl is-active privoxy.service)
		if [ $isactivepri == "active" ]; then
			echo -e "${GREEN}[+] Privoxy Start ${NC}"
		else
			echo -e "${RED}[-] Privoxy Problem ${NC}"
			stop_service >/dev/null
			exit 1
		fi
	fi
	echo -e "${GREEN}[*] Dnscrypt-proxy is connecting ...${NC}"
	status_dns 20
	if [ $? == 2 ]; then
		echo -e "${GREEN}[+] Dnscrypt-proxy Connect ${NC}"
	fi
	echo -e "${GREEN}[*] Tor is connecting ...${NC}"
	status_tor 30
	if [ $? == 3 ]; then
		echo -e "${GREEN}[+] Tor Client Connect ${NC}"
	fi
}
function status_all() {
	failed=false
	isactivepri=$(sudo systemctl is-active privoxy.service)
	if [ $isactivepri == "inactive" ]; then
		echo -e "${RED}[-] Privoxy Stop ${NC}"
		failed=true
	fi
	if [ $isactivepri == "active" ]; then
		echo -e "${GREEN}[+] Privoxy Active ${NC}"
	fi
	isfailedpri=$(sudo systemctl is-failed privoxy.service)
	if [ $isfailedpri == "failed" ]; then
		echo -e "${RED}[-] Privoxy Failed${NC}"
		failed=true
	fi
	isactivedns=$(sudo systemctl is-active dnscrypt-proxy.service)
	if [ $isactivedns == "inactive" ]; then
		echo -e "${RED}[-] Dnscrypt-proxy Stop ${NC}"
		failed=true
	fi
	if [ $isactivedns == "active" ]; then
		echo -e "${GREEN}[+] Dnscrypt-proxy Active ${NC}"
	fi
	isfaileddns=$(sudo systemctl is-failed dnscrypt-proxy.service)
	if [ $isfaileddns == "failed" ]; then
		echo -e "${RED}[-] Dnscrypt-proxy Failed${NC}"
		failed=true
	fi
	isactivedns=$(sudo systemctl is-active tor.service)
	if [ $isactivedns == "active" ]; then
		echo -e "${GREEN}[+] Tor Active${NC}"
	fi
	if [ $isactivedns == "inactive" ]; then
		echo -e "${RED}[-] Tor Stop${NC}"
		failed=true
	fi
	isfaileddns=$(sudo systemctl is-failed tor.service)
	if [ $isfaileddns == "failed" ]; then
		echo -e "${RED}[-] Tor Failed${NC}"
		failed=true
	fi
	if $failed; then
		return 1
	else
		return 0
	fi
}
function status_dns() {
	secdns=$1
	startdns=$SECONDS
	while true; do
		if sudo systemctl status dnscrypt-proxy.service | grep "dnscrypt-proxy is ready" >/dev/null; then
			return 2
		else
			if [ $(expr $SECONDS - $startdns) -ge $secdns ]; then
				echo -e "${RED}[-] Dnscrypt-proxy not connected${NC}"
				restart_dns
				startdns=$SECONDS
			fi
			sleep 2
		fi
	done

}
function status_tor() {
	sec=$1
	con_net
	start=$SECONDS
	count=0
	while true; do
		if sudo systemctl status tor.service | grep "Bootstrapped 100%: Done" >/dev/null; then
			return 3
		elif [ $count -eq 3 ]; then
			echo "[!] Maybe ISP blocked bridge"
			echo "[*] Please see help option $ ddtor --help"
			stop_service
			exit 1
		else
			if [ $(expr $SECONDS - $start) -ge $sec ]; then
				echo -e "${RED}[-] Tor not connected${NC}"
				count=$(expr $count + 1)
				restart_tor
				start=$SECONDS
				sec=30
			fi
			sleep 2
		fi
	done
}
function restart_tor() {
	echo -n "[?] Are you sure restart tor.service ? [y/n] "
	read answer
	answer=${answer:-'y'} # set default value as yes
	if [ $answer == 'y' -o $answer == 'Y' ]; then
		sudo systemctl restart tor.service
		echo -e "${RED}[*] Restarted ${NC}"
		sleep 1
	else
		stop_service
		echo -e "${RED}[*] Exiting ...${NC}"
		exit 1
	fi
}
function restart_dns() {
	echo -n "[?] Are you sure restart dnscrypt-proxy.service ? [y/n] "
	read answer
	answer=${answer:-'y'} # set default value as yes
	if [ $answer == 'y' -o $answer == 'Y' ]; then
		sudo systemctl restart dnscrypt-proxy.service
		echo -e "${RED}[*] Restarted ${NC}"
		sleep 1
	else
		stop_service
		echo -e "${RED}[*] Exiting ...${NC}"
		exit 1
	fi
}
function restart_privoxy() {
	echo -n "[?] Are you sure restart privoxy.service ? [y/n] "
	read answer
	answer=${answer:-'y'} # set default value as yes
	if [ $answer == 'y' -o $answer == 'Y' ]; then
		sudo systemctl restart privoxy.service
		echo -e "${RED}[*] Restarted ${NC}"
		sleep 1
	else
		stop_service
		echo -e "${RED}[*] Exiting ...${NC}"
		exit 1
	fi
}
function update_bridge() {
	if cat $1 | grep "obfs4" >/dev/null; then
		sudo sed s/" obfs4"/"bridge obfs4"/g $1 >>/etc/tor/torrc
	else
		echo -e "${RED}$1 file is empty or ...${NC}"
		exit 1
	fi

}
function help_ddtor() {
	echo "get bridges by sending mail to bridges@bridges.torproject.org"
	echo "with the line 'get transport obfs4' by itself in the body of the mail."
}
function set_proxy_setting() {
	if which gsettings >/dev/null 2>&1; then
		#Set IP and Port on HTTP and SOCKS gnome-shell
		gsettings set org.gnome.system.proxy mode 'manual'
		gsettings set org.gnome.system.proxy.http host 127.0.0.1
		gsettings set org.gnome.system.proxy.http port 8118
		gsettings set org.gnome.system.proxy.socks host 127.0.0.1
		gsettings set org.gnome.system.proxy.socks port 9050
		gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', '192.168.0.0/16', '10.0.0.0/8', '172.16.0.0/12']"
		echo -e "${GREEN}[+] Enable Network Proxy ${NC}"
	fi
	export http_proxy="http://127.0.0.1:8118"
	export https_proxy="https://127.0.0.1:8118"
	export HTTPS_PROXY="https://127.0.0.1:8118"
	export HTTP_PROXY="http://127.0.0.1:8118"
}
function unset_proxy_setting() {
	if which gsettings >/dev/null 2>&1; then
		if gsettings get org.gnome.system.proxy mode | grep 'manual' >/dev/null; then
			gsettings set org.gnome.system.proxy mode 'none'
			echo -e "${RED}[-] Disabled Network Proxy ${NC}"
		fi
	fi
	unset http_proxy
	unset http_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
}
function stop_service() {
	if [ -f "/etc/resolv.tmp-ddtor.conf" ]; then
		sudo cp /etc/resolv.tmp-ddtor.conf /etc/resolv.conf
		sudo rm /etc/resolv.tmp-ddtor.conf
	fi
	sudo systemctl stop dnscrypt-proxy.service 2>/dev/null
	sleep 1
	sudo systemctl stop dnscrypt-proxy.socket
	echo -e "${RED}[-] Stop Dnscrypt-proxy ${NC}"
	sleep 1
	sudo systemctl stop privoxy.service
	echo -e "${RED}[-] Stop Privoxy ${NC}"
	sleep 1
	sudo systemctl stop tor.service
	echo -e "${RED}[-] Stop Tor ${NC}"
	unset_proxy_setting
}
function con_net() {
	if ! ping google.com -c 3 1>/dev/null 2>&1; then
		if type nmcli >/dev/null 2>&1; then
			nmcli radio wifi on
			declare -a uuids=($(nmcli -f UUID con show | sed '/UUID/d'))
			for uid in "${uuids[@]}"; do
				nmcli con up uuid $uid 1>/dev/null 2>&1
				sleep 1
				if ping google.com -c 3 1>/dev/null 2>&1; then
					echo -e "${GREEN}[+] Connect to internet ...${NC}"
					break
				fi
				nmcli con down uuid $uid 1>/dev/null 2>&1
			done
		else
			echo -e "${RED}[-] Connect to internet failed${NC}"
			status_all >/dev/null
			if [ $? == 0 ]; then
				stop_service >/dev/null
			fi
			exit 1
		fi
	fi
}

if [ $# -eq 0 ]; then
	usage
fi
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
	-u | --start)
		start_service
		set_proxy_setting
		shift # past argument
		;;
	-d | --stop)
		stop_service
		shift # past argument
		;;
	-s | --status)
		status_all
		shift # past argument
		;;
	-b | --update-bridge)
		update_bridge $2
		shift # past argument
		shift # past value
		;;
	-h | --help)
		help_ddtor
		shift # past argument
		;;
	-v | --version)
		echo -e "${GREEN}[+] ddtor version $VER ${NC}"
		shift # past argument
		;;
	*)
		usage
		exit 1
		shift # past argument
		;;
	esac
done
