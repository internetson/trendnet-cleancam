#!/bin/sh

time_protocol=`/sbin/cfg -a r sys.conf DATETIME "Protocol"`
retry=3
retrysleep=60

case "$time_protocol" in
  1)
	hostname=`/sbin/cfg -a r sys.conf DATETIME "NTP IP"`
	if [ $? = 0 ] ; then
		/bin/kill `pidof ntpclient` 
		# some delay to avoid wireless connection not finished
		if [ -n "$1" ]; then
			sleep $1 
		fi
		while [ "$retry" -gt 0 ]; do
	  		/usr/sbin/ntpclient -s -i 30 -h "$hostname"
			# if query is OK, set the hwclock
			if [ $? = 0 ]; then
				/usr/bin/logger -t ipcam "NTP date/time setting finish"
				/sbin/rtcfg -w
				exit 0
			else
				/usr/bin/logger -t ipcam "NTP date/time setting fail"
				retry=$(($retry -1))
				sleep $retrysleep
			fi
		done
	fi
	;;

  *)
	echo "No protocol find"
	exit 1
esac

