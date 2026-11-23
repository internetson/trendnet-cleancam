#!/bin/sh

. /etc/init.d/defaults
DEV=`/sbin/cfg -a r net.conf NETWORK "Wan Dev"`
BONDING=`/sbin/cfg -a r net.conf NETWORK "bonding"`
hostname=`/sbin/cfg -a r sys.conf SYSTEM CameraName`
modelname=`/sbin/cfg -a r info.conf INFO ModelName`


bond_up() {
	/sbin/ifconfig bond0 down
	/sbin/ifconfig bond0 up
	/sbin/ifconfig eth0 0.0.0.0
	/sbin/ifconfig ra0 0.0.0.0
	/sbin/ifenslave -E bond0 eth0
	/sbin/ifenslave -E bond0 ra0

	/sbin/wlan_up
}

start() {

	if [ $BONDING = 1 ]; then
		DEV=bond0
	fi
	if [ -z $hostname ]; then
		#use default model name as default
		hostname=$modelname
	fi

	retry=3
	while [ "$retry" -gt 0 ]
	do
		# polling
		# use poll method to acquire IP address
		/sbin/ifconfig $DEV > /dev/urandom
		/sbin/udhcpc -n -i $DEV -H "$hostname" -p /var/run/udhcpc.pid 
		if [ $? = 0 ]; then
			break
		fi
		retry=$(($retry -1))
		sleep 3
	done
        # if dhcp fail, then do below actions
	if [ $retry = 0 ]; then
		hwid=`/sbin/iff_get -d $DEV`
		/sbin/ifconfig $DEV  $default_ip netmask $default_mask 
		if [ $BONDING = 1 ]; then
			bond_up
		fi
		/sbin/route add default gw $default_gw
		# log
		/usr/bin/logger -t ipcam "IP address acquire fail, default:$default_ip"

		exit 1
	else
		# monitoring!
		# udhcpc will keep request dhcp server if fail to get ip
		/bin/kill `pidof udhcpc`
		/sbin/udhcpc -i $DEV -H "$hostname" -p /var/run/udhcpc.pid 
		if [ $? = 0 ]; then
			if [ $BONDING = 1 ]; then
				# re-bonding will dele route info, re-route!
				gw=`/sbin/iff_get -g bond0`
				bond_up
				/sbin/route add default gw $gw
			fi
		fi
		#log
		/usr/bin/logger -t ipcam "IP address acquire success"
		exit 0
	fi
}

killproc() {
	pid=
	if [ -f /var/run/$1.pid ]; then
		local line p
		read line < /var/run/$1.pid
		kill -9 $line
	fi
	rm -f /var/run/$1.pid
}

stop() {
	killproc udhcpc
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
