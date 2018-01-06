#!/bin/sh

usage() {
	echo "Usage: $(ddtor) [OPTION]..."
	echo "With no OPTION specified defaults to -v."
	echo
	echo "Options:"
	echo "  -v, --version"
	echo "    Display the version"
	echo "  -u, --start"
	echo "    Start Tor"
	echo "  -d, --stop"
	echo "    Stop ..."
	echo "  -s, --status"
	echo "    status"
	echo "  -c, --config"
	echo "    config ddtorrc"
	echo "  -h, --help"
	echo "    Display example and start ddtor."

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
		echo "tor active "
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
		echo "tor is not started please start with XXX command"
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
			echo "maybe ISP Block bridge send email to torproject@org and chenge bridge in /etc/tor/torc config"
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
	echo "this func help script"
}

function parse_arg() {
	echo "this func pars_arguman"
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
		shift # past argument
		;;
	*)
		echo "somthing wrong..."
		exit 1
		shift # past argument
		;;
	esac
done

#
