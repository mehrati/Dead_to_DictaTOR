#!/bin/sh

usage() {
	echo "Dead to Dictator"
	echo "this script use tor network for passing the boycott"
	echo "Usage: $(ddtor) [OPTION]..."
	echo
	echo "Options:"
	echo "  -v, --version"
	echo "    Display the version"
	echo "  -u, --start"
	echo "    Start Tor Service"
	echo "  -d, --stop"
	echo "    Stop Tor Service"
	echo "  -s, --status"
	echo "    Status Tor Service"
	echo "  -c, --config"
	echo "    Update config ddtorrc"
	echo "  -h, --help"
	echo "    Display Help Massage"

	exit 0
}

if [ $# -eq 0 ]; then
	usage
fi

function start_tor() {
	check_root "for starting tor"
	isactive=$(systemctl is-active tor.service)
	if [ $isactive == "inactive" ]; then
		systemctl start tor.service
		sleep 1
		isfailed=$(systemctl is-failed tor.service)
		if [ $isfailed == "failed" ]; then
			echo "failed"
			restart_tor
		fi
		echo "Tor is trying to establish a connection. This may take long for some minutes. Please wait..."
		status_tor
	else
		echo "tor service active "
	fi
}

function status_tor() {
	isactive=$(systemctl is-active tor.service)
	if [ $isactive == "active" ]; then
		isfailed=$(systemctl is-failed tor.service)
		if [ $isfailed == "failed" ]; then
			echo "failed "
		fi
	else
		echo "tor is not started please start with $ ddtor --start command"
		exit 0
	fi
	start=$SECONDS
	count=0
	while true; do
		if systemctl status tor.service | grep "Bootstrapped 100%: Done"; then
			echo "You Connected..."
			break
		elif [ $count -eq 2 ]; then
			#edit this -> massage
			echo "maybe ISP blocked bridge"
			echo "please see help option $ ddtor --help"
			stop_tor
			exit 1

		else
			if [ $(expr $SECONDS - $start) -ge 20 ]; then
				echo "tor not connected"
				count=$(expr $count + 1)
				start=$SECONDS
				restart_tor
			fi
			sleep 2
		fi
	done
}

function restart_tor() {
	check_root "for restarting"
	echo "are you sure restart tor.service y/n ?"
	read answer
	answer=${answer:-'y'} # set default value as yes
	if [ $answer == 'y' -o $answer == 'Y' ]; then
		systemctl restart tor.service
		echo "restarted !!!"
		sleep 1
	else
		echo "Exiting ..."
		exit 1
	fi
}

function update_conf() {
	echo "this func must update bridge obfs4 config ddtorrc"
}

function help_ddtor() {
	echo "for update bridge address send mail to bellow address"
	echo "TO : bridges@torproject.org"
	echo "Subject : no need subject"
	echo "Body : get transport obfs4"
	echo "save bridges to somthing.txt file and pass to script "
	echo "$ ddtor --config somthing.txt"
}

function stop_tor() {
	check_root "for stoping tor"
	systemctl stop tor.service
}

function check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "$1 you must be run as root"
		exit 1
	fi
}

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
		status_tor
		shift # past argument
		;;
	-c | --config)
		CONF="$2"
		echo $2
		shift # past argument
		shift # past value
		;;
	-h | --help)
	    help_ddtor
		shift # past argument
		;;
	-v | --version)
		echo "Dead to Dictator Version 0.1"
		shift # past argument
		;;
	*)
		echo "somthing wrong..."
		exit 1
		shift # past argument
		;;
	esac
done
