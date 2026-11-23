#!/bin/sh

primary=`/sbin/cfg -a r net.conf "DNS PROXY" Primary`
secondary=`/sbin/cfg -a r net.conf "DNS PROXY" Secondary`

# use the /etc/resolv.conf directly 
start() {
	RESOLV="/etc/resolv.conf"
	DNS="$primary $secondary"
	#echo $DNS
	rm -f /etc/resolv.conf
	echo -n > $RESOLV
 	for i in $DNS; do
 	       echo "nameserver $i" >> $RESOLV
	done
}


stop() {
	/usr/sbin/dnrd -k > /dev/null 2>&1
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
