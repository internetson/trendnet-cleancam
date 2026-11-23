#!/bin/sh

# read eth0 mac address
mac=`/sbin/iff_get -h eth0`
region=`/sbin/cfg -a r net.conf WLAN Region`
issoft=0

# process 'soft' factory reset
#if [ ! -z $1 -a $1 = "soft" ]; then
if [ ! -z $1 ]; then
	# soft keep IP addr, subnetmask, broadcast, route
	if [ $1 = "soft" ]; then
	echo "it's soft..."
	policy=`/sbin/cfg -a r net.conf WAN Policy`
	ipaddr=`/sbin/cfg -a r net.conf WAN "IP Addr"`
	netmask=`/sbin/cfg -a r net.conf WAN Netmask`
	gateway=`/sbin/cfg -a r net.conf WAN Gateway`
	issoft=1
	fi
fi

cd /tmp/config; /bin/tar zxvf /etc/factory_default.tgz 2>/dev/null 1>/dev/null
# write back mac address to /etc/net.conf
#/etc/init.d/macwrite.sh $mac
cfg -a w net.conf NETWORK "mac addr" $mac
cfg -a w net.conf WLAN Region $region

if [ $issoft = 1 ]; then
	cfg -a w net.conf WAN Policy $policy
	cfg -a w net.conf WAN "IP Addr" $ipaddr
	cfg -a w net.conf WAN Netmask $netmask
	cfg -a w net.conf WAN Gateway $gateway
fi

# save config to flash
/etc/init.d/savecfg.sh
retval=$?
echo "remember to reboot your camera..."
exit $retval 
