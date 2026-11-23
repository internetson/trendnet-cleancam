#!/bin/sh

start() {
	rmmod rt61
	rm -f /lib/modules/rt61.o
	# change pppoe interface depend on current connect policy
	BONDING=`/sbin/cfg -a r net.conf NETWORK "bonding"`
	ip_policy=`/sbin/cfg -a r net.conf WAN "Policy"`
	if [ "$ip_policy" = "pppoe" ]; then
		DEV=ppp0
	else
		if [ $BONDING = 1 ]; then
			DEV=bond0
		else
			DEV=eth0
		fi
	fi
	#log
	/usr/bin/logger -t ipcam "PPPoE start"
	/sbin/cfg -a w ddns.conf "" interface $DEV
	/usr/sbin/adsl-start
}

stop() {
	/usr/bin/logger -t ipcam "PPPoE stop"
	/usr/sbin/adsl-stop
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
