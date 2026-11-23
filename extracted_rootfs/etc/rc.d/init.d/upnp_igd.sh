
#!  /bin./bash

wan_service="IP"
port=`/sbin/cfg -a r net.conf WAN "Http Port"`
model=`/sbin/cfg -a r sys.conf SYSTEM "CameraName"`

# commands
GetSpecificPortMap=0
AddPortMap=1
GetExternalIP=2
DelPortMap=3
GetDefaultService=4

upnp_portmap()
{
	# query the port is available
	/sbin/upnp_igd $1 $GetSpecificPortMap $2 TCP
	retval=$?
	if [ $retval = 202 ]; then # ret is 714 - (256*2) = 202:)
		# the port is empty, set port map now!
		/sbin/upnp_igd $1 $AddPortMap $2 TCP $3 $2
		retval=$?
		if [ $retval = 0 ] ; then
		/usr/bin/logger -t ipcam "UPnP port mapping setting finish"
		else
		/usr/bin/logger -t ipcam "UPnP port mapping setting fail"
		fi
		return $retval
	elif [ $retval = 0 ]; then
		# specific port is open
		/usr/bin/logger -t ipcam "UPnP specific port:$2 already open"
	else
		/usr/bin/logger -t ipcam "UPnP port mapping setting fail"
	fi
	return $retval
}


if [ -z $model ]; then
	get_wlan
	retval=$?
	if [ retval = 0 ]; then
		model=`/sbin/cfg -a r info.conf UPNP "ModelName"`
	else
		model=`/sbin/cfg -a r info.conf WL_UPNP "ModelName"`
	fi
fi

upnp_igd()
{
	/usr/bin/logger -t ipcam "UPnP port($1) mapping setting start"
	upnp_portmap $wan_service $1 $model
	retval=$?
	return $retval 
}

#
# Start UPNP
#
start() {
	echo "Starting UPNP ...."
	if [ `/sbin/cfg -a r net.conf UPNP Enable` = 0 ]
	then
		echo disabled
		exit 0
	fi
	upnp_igd $port
	retval=$?
	exit $retval
}

stop() {
	echo nothing...
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
