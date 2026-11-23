#!/bin/sh

port=`/sbin/cfg -a r net.conf WAN "Http Port"`

start() {
	echo -n "Starting http:"
	cd /server; ./httpd $port&
}

stop() {
	kill `pidof httpd`
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
		exit 1
esac

exit $?
