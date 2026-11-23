#!/bin/sh

RETVAL=0

umask 077

case "$1" in
  start)
	echo $"Starting bkcfg:---->"
	/sbin/bkcfg -r /tmp/config.tgz

	cd /tmp; tar zxvf config.tgz

	facinit=`cfg -a r sys.conf SYSTEM "factory"`
	echo "by firmware upgrade...factory" $facinit
	if [ "$facinit" = "1" ]; then
		# use  factory default settings after firmware upgrade
		echo "use factory default forced by firmware upgrade..."
		/etc/init.d/factory_reset.sh 
	fi

	#
	# create device nodes
	#
	mknod /dev/ptya0 c 2 176
	mknod /dev/ptya1 c 2 177
	mknod /dev/ttya0 c 3 176
	mknod /dev/ttya1 c 3 177

	mknod /dev/hwmon c 10 64
	mknod /dev/msgeng c 10 65

	mkdir /dev/pts
	mknod /dev/pts/0 c 136 0
	mknod /dev/pts/1 c 136 1
	mknod /dev/pts/2 c 136 2
	mknod /dev/ppp c 108 0
	# read mac address and set mac addr first
	macaddr=`cfg -a r net.conf NETWORK "mac addr"`
	macret=$?
	if [ $macret = 0 ]; then
		/sbin/ifconfig eth0 hw ether $macaddr
	fi
	
	# This model can't read date/time from RTC
	# set init date
	/bin/date 010100002007
	# set timezome
	/sbin/settz

	echo
	exit $RETVAL
	;;
  stop)
	echo $"Shutting down tmpfs: ---->"
	# donothing 
	echo	
        exit $RETVAL
	;;
esac
