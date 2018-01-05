#!/bin/sh
echo "Tor is trying to establish a connection. This may take long for some minutes. Please wait..."
start=$SECONDS
while true ; do
	if systemctl status tor.service | grep "Bootstrapped 100%: Done"; then
	    echo "You Connected..."
		break
	else
	if [$(( SECONDS - start )) >= 45 ];then
	echo "tor not connected"
	echo "are you restart tor.service y/n ?"
		read answer
        answer=${answer:-'y'} # set default value as yes
		if [ $answer -eq "y" -o $answer -eq "Y" ]; then
			systemctl restart tor.service
			echo "restarted !!!"
			sleep 1
		else
			echo "Exiting ..."
			exit 1
		fi
	fi
		sleep 2
	fi
done
