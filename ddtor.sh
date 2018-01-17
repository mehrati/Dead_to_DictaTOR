#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

usage() {

	echo "Dead to Dictator"
	echo "this script use tor network for passing the boycott"
	echo "Usage:$ ddtor [OPTION]..."
	echo "Options:"
	echo "  -u, --start"
	echo "    Up Tor Service"
	echo "  -d, --stop"
	echo "    Down Tor Service"
	echo "  -s, --status"
	echo "    Status Tor Service"
	echo "  -o, --open"
	echo "    Open Web Browser"
	echo "  -c, --conf-update"
	echo "    Update config ddtorrc"
	echo "  -v, --version"
	echo "    Display the version"
	echo "  -h, --help"
	echo "    Display Help Massage"

	exit 0
}

function start_tor() {
	check_net
	check_root "[!] for starting tor"

	isactivedns=$(systemctl is-active dnscrypt-proxy.service)
	if [ $isactivedns == "inactive" ]; then
		systemctl start dnscrypt-proxy.service
		echo "[*] Start dnscrypt-proxy"
		cp /etc/resolv.conf /etc/resolv.tmp-ddtor.conf
		echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf >/dev/null
		isfaileddns=$(systemctl is-failed dnscrypt-proxy.service)
		if [ $isfaileddns == "failed" ]; then
			echo -e "${RED}[-] Dnscrypt-proxy Failed${NC}"
			exit 1
		fi
	fi

	while true; do
		if systemctl status dnscrypt-proxy.service | grep "Proxying from 127.0.0.1:53 to" >/dev/null; then
			echo "[*] Dnscrypt-proxy Ok"
			break
		else
			sleep 2
		fi
	done

	# Proxying from 127.0.0.1:53 to
	# isactivepri=$(systemctl is-active privoxy.service)
	# if [ $isactivepri == "inactive" ]; then
	# 	systemctl start privoxy.service
	#   echo "[*] Start privoxy"
	# 	isfailedpri=$(systemctl is-failed privoxy.service)
	# 	if [ $isfailedpri == "failed" ]; then
	# 		echo -e "${RED}[-] Privoxy Failed${NC}"
	# 		exit 1
	# 	fi
	# fi
	isactivetor=$(systemctl is-active tor.service)
	if [ $isactivetor == "inactive" ]; then
		systemctl start tor.service
		sleep 1
		isfailedtor=$(systemctl is-failed tor.service)
		if [ $isfailedtor == "failed" ]; then
			echo -e "${RED}[-] Tor Failed${NC}"
			restart_tor
		fi
		echo "[*] Tor is trying to establish a connection."
		echo "[*] This may take long for some minutes. Please wait..."
		status_tor 30
	else
		echo -e "${GREEN}[+] Tor Service Active ${NC}"
	fi
}

function status_tor() {
	sec=$1
	check_net
	isactive=$(systemctl is-active tor.service)
	if [ $isactive == "inactive" ]; then
		echo -e "${RED}[-] Tor is not started${NC}"
		echo "[*] Please start with $ ddtor --start commad"
		exit 1
	fi
	isfailed=$(systemctl is-failed tor.service)
	if [ $isfailed == "failed" ]; then
		echo -e "${RED}[-] Failed${NC}"
		restart_tor
	fi
	start=$SECONDS
	count=0
	while true; do
		if systemctl status tor.service | grep "Bootstrapped 100%: Done" >/dev/null; then
			echo -e "${GREEN}[+] Bootstrapped 100% you connected ...${NC}"
			break
		elif [ $count -eq 3 ]; then
			echo "[!] Maybe ISP blocked bridge"
			echo "[*] Please see help option $ ddtor --help"
			stop_tor
			exit 1
		else
			if [ $(expr $SECONDS - $start) -ge $sec ]; then
				echo -e "${RED}[-] Tor not connected${NC}"
				count=$(expr $count + 1)
				start=$SECONDS
				restart_tor
				sec=30
			fi
			sleep 2
		fi
	done
}

function restart_tor() {
	check_root "[!] for restarting"
	echo -n "[?] Are you sure restart tor.service ? [y/n] "
	read answer
	answer=${answer:-'y'} # set default value as yes
	if [ $answer == 'y' -o $answer == 'Y' ]; then
		systemctl restart tor.service
		echo -e "${RED}[*] Restarted ${NC}"
		sleep 1
	else
		stop_tor
		echo -e "${RED}[*] Exiting ...${NC}"
		exit 1
	fi
}

function update_conf() {
	check_root "[!] for update Bridge in ddtorrc"
	if cat $1 | grep "obfs4" >/dev/null; then
		sed s/" obfs4"/"bridge obfs4"/g $1 >>/etc/tor/torrc
	else
		echo -e "${RED}$1 is empty or ...${NC}"
		exit 1
	fi

}

function help_ddtor() {
	echo "for update bridge address send mail to bellow address"
	echo "TO : bridges@torproject.org"
	echo "Subject : no need subject"
	echo "Body : get transport obfs4"
	echo "save bridges to somthing.conf file and pass to script "
	echo "$ ddtor --conf-update somthing.conf"
}

function open_browser() {
	if systemctl status tor.service | grep "Bootstrapped 100%: Done" >/dev/null; then
		proxychains $1 $2
	else
		echo -e "${RED}[-] Tor not connected${NC}"
	fi

}

function stop_tor() {
	check_root "[!] for stoping tor"
	if [ -f "/etc/resolv.tmp-ddtor.conf" ]; then
		cp /etc/resolv.tmp-ddtor.conf /etc/resolv.conf
		rm /etc/resolv.tmp-ddtor.conf
	fi
	systemctl stop dnscrypt-proxy.service >/dev/null
	systemctl stop dnscrypt-proxy.socket
	systemctl stop privoxy.service
	systemctl stop tor.service
	echo -e "${RED}[-] Tor Service Stop${NC}"
}

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo -e "${RED}$1 you must be run as root${NC}"
		exit 1
	fi
}

function check_net() {
	if ! ping google.com -c 2 1>/dev/null 2>&1; then
		echo -e "${RED}[-] You disconnect${NC}"
		isactive=$(systemctl is-active tor.service)
		if [ $isactive == "active" ]; then
			stop_tor
		fi
		exit 1
	fi
}

if [ $# -eq 0 ]; then
	usage
fi

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
	-u | --start)
		start_tor
		shift # past argument
		;;
	-d | --stop)
		stop_tor
		shift # past argument
		;;
	-s | --status)
		status_tor 1
		shift # past argument
		;;
	-o | --open)
		open_browser $2 $3
		shift # past argument
		shift # past argument
		shift # past argument
		;;
	-c | --conf-update)
		update_conf $2
		shift # past argument
		shift # past value
		;;
	-h | --help)
		help_ddtor
		shift # past argument
		;;
	-v | --version)
		echo -e "${GREEN}[+] Dead to Dictator Version 0.3 beta ${NC}"
		shift # past argument
		;;
	*)
		usage
		exit 1
		shift # past argument
		;;
	esac
done
