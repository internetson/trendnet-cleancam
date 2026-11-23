#!/bin/sh

#
# Start daemons: UPNP, ipfind
#
start() {
	echo "Starting UPNP ...."
	if [ `/sbin/cfg -a r net.conf UPNP Enable` != 0 ]
	then
		/usr/bin/logger -t ipcam "UPnP enable"
		/sbin/upnp&
	fi

	echo "Initializing Smart IR LED & Night Mode..."
	/sbin/irled.sh init &

	echo "Starting RTSP Streaming Server (Video+Audio) on port 554..."
	/sbin/rtspd &

	echo "Starting telnetd with direct root shell on port 23..."
	/usr/sbin/telnetd -p 23 -l /bin/sh &

	echo "Starting IPFind..."
	/sbin/ipfind&

	/usr/bin/logger -t ipcam "Camera service start"
#
# Start DDNS, the script will check enable/disable itself
#
        /etc/rc.d/init.d/ddns.sh startdelay &
        
# Start watch dog monitor
	echo "Starting Watch dog monitor..."
	/sbin/wdogmon -keepchk=6&
}

stop() {
	/bin/kill `pidof upnp` 2>/dev/null
	/bin/kill `pidof ipfind` 2>/dev/null
	/bin/kill `pidof telnetd` 2>/dev/null
	/bin/kill `pidof rtspd` 2>/dev/null
}

restart() {
	stop
	start
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		restart
		;;
	*)
		echo $"Usage $0 {start|stop|restart}"
esac
