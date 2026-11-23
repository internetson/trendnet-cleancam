#!/bin/sh

. /etc/init.d/defaults

DEV=`/sbin/cfg -a r net.conf NETWORK "Wan Dev"`
ip_policy=`/sbin/cfg -a r net.conf WAN Policy`
ip_addr=`/sbin/cfg -a r net.conf WAN "IP Addr"`
netmask_wan=`/sbin/cfg -a r net.conf WAN Netmask`
default_router=`/sbin/cfg -a r net.conf WAN Gateway`
bonding=0

#
# Setup Hostname
#
write_hosts()
{
        # check WLAN supported
	/sbin/get_wlan
        if [ $? = 1 ]; then
		upnp="WL_UPNP"
        else
		upnp="UPNP"
        fi
	hostname=`/sbin/cfg -a r info.conf $upnp ModelName`
	cnt=1
	mac=""
	while [ "$cnt" -lt 7 ]
	do
        	mac=$mac`echo $macaddress | cut -d: -f$cnt`
		cnt=$(($cnt+1))
	done
	echo "Setting Hostname: ${hostname}-$mac"
        /bin/hostname "${hostname}-$mac"
        /bin/echo "127.0.0.1            localhost               localhost" > /etc/hosts
        /bin/echo "$host_ip             `/bin/hostname`         `/bin/hostname`" >> /etc/hosts
}

macaddress=`/sbin/cfg -a r net.conf NETWORK "mac addr"`
region=`/sbin/cfg -a r net.conf WLAN Region`

#
# Setup Interface Addresses
#
/sbin/ifconfig lo 127.0.0.1 netmask 255.0.0.0

# check WLAN supported
/sbin/get_wlan
if [ $? = 1 ]; then
	# This is RALINK
	WLAN_DEV=ra0
	/sbin/insmod /lib/modules/rt61.o
	# write region,  ra0 must be "up" for region setting
	/sbin/ifconfig ra0 up
	/sbin/racfg region $region
	/sbin/ifconfig ra0 down
	bonding=1
fi

/sbin/cfg -a w net.conf NETWORK "bonding" $bonding 

# config wireless 
# 1. change DEV to bond0
# 2. net.conf [NETWORK] bonding = 1

if [ $bonding = 1 -a $ip_policy != "pppoe" ]; then
	lan_mac_addr=`/sbin/iff_get -h $DEV`
	/sbin/ifconfig bond0 hw ether $lan_mac_addr
	/sbin/ifconfig $WLAN_DEV down
	/sbin/ifconfig $WLAN_DEV hw ether $lan_mac_addr
	# config bonding before wlan config, or wlan wouldn't work ??
	/sbin/ifconfig $DEV 0.0.0.0
	/sbin/ifconfig $WLAN_DEV 0.0.0.0
	/sbin/ifconfig bond0 ${ip_addr} netmask ${netmask_wan} up
	/sbin/ifenslave -E bond0 $DEV
	/sbin/ifenslave -E bond0 $WLAN_DEV

	# start up wireless
	/sbin/wlan_up
	DEV=bond0
fi

# network interface Setup
if [ $ip_policy = "static" ]; then
	echo "Setting fixed IP Address ...."
	/sbin/ifconfig $DEV ${ip_addr} netmask ${netmask_wan}
	/sbin/route add default gw ${default_router}
elif [ $ip_policy = "dhcpc" ]; then
	if [ -f /usr/share/udhcpc/default.script ]; then
		echo "Starting DHCP Client ...."
		/etc/rc.d/init.d/udhcpc.sh start
	fi
elif [ $ip_policy = "pppoe" ]; then
	echo "Starting PPPoE ...."
	if [ -r /etc/rc.d/init.d/pppoe.sh ]; then
		echo "Starting PPPoE Connection ...."
		/etc/rc.d/init.d/pppoe.sh start
		if [ $? = 0 ]; then
			# now use ppp0 as active one
			DEV=ppp0
			/sbin/pppoenotify
		else
			/sbin/ifconfig eth0 $default_ip netmask $default_mask 
		fi
	fi
fi

# Broadcast route for discover
/sbin/route add -host 255.255.255.255 $DEV
write_hosts

#
# Start DNS Relay Daemon
# 
if [ $ip_policy = "static" ]; then 
	echo "Starting DNS Proxy ...."
	/etc/rc.d/init.d/dnrd.sh start
fi


#
# Start NTP Client, Time Server. run in background
#
	/etc/rc.d/init.d/ntpc.sh 10 > /dev/null 2>&1 &

#
# Start upnp igd
#
	/etc/rc.d/init.d/upnp_igdd.sh startdelay &
