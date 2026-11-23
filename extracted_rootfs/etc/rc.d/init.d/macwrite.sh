#!/bin/sh

dev=eth0

die() {
	echo $@
	exit 1
}

bond_up() {
	/sbin/ifconfig bond0 down
	ifconfig bond0 hw ether $1
	/sbin/ifconfig bond0 up
	/sbin/ifconfig eth0 0.0.0.0
	/sbin/ifconfig ra0 0.0.0.0
	/sbin/ifenslave -E bond0 eth0
	/sbin/ifenslave -E bond0 ra0

	/sbin/wlan_up
}

lan_mac_write()
{
	/sbin/ifconfig eth0 > /dev/null 2> /dev/null
	retval=$?
	if [ $retval = 0 ] ; then
	/sbin/ifconfig eth0 down > /dev/null 2> /dev/null
	fi

	# set mac address
	/sbin/cfg -a w net.conf NETWORK "mac addr" $1
	ifconfig eth0 hw ether $1
	ifconfig eth0 up
}

wlan_mac_write()
{
	lan_mac_write $1
	bond_up $1
}

[ -z $1 ] && die "need mac address"

# check bond exist or not
/sbin/ifconfig bond0 > /dev/null 2> /dev/null
retval=$?
#release bond
if [ $retval = 0 ] ; then
	/sbin/ifconfig bond0 down > /dev/null 2> /dev/null
fi

/sbin/get_wlan
retval=$?

if [ $retval = 0 ] ; then
	lan_mac_write $1
else
	wlan_mac_write $1
	dev=bond0
fi

/sbin/route add -host 255.255.255.255 $dev

