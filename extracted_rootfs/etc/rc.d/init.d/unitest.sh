#!/bin/sh

test_mode()
{
	echo "testing mode..."
	/sbin/sendmsg hwmon 80 1 0
}

normal_mode()
{
	echo "normal mode..."
	/sbin/sendmsg hwmon 80 0 0
}

system_mode()
{
	echo "system mode"
}

usb_test()
{
	echo -n "USB testing..."
	mount | grep "/dev/sda1" > /dev/null 2>&1
	retval=$?
	if [ $retval = 0 ]; then 
		# USB mounted
		cp /etc/info.conf /mnt/usb > /dev/null 2>&1
		sync
		cat /mnt/usb/info.conf > /dev/null 2>&1
		retval=$?
		if [ $retval = 0 ]; then 
			#success
			retval=1
			echo "OK"
		else
			retval=0
			echo "NG"
		fi
	else
		#fail
		retval=0
		echo "NG"
	fi
	exit $retval
}

rtc_test()
{
	echo -n "rtc testing..."
	/sbin/rtcfg -a 2099:00:00:00:00:00 > /dev/null
	/sbin/rtcfg -r | grep 2099 > /dev/null
	retval=$?
	if [ $retval = 0 ]; then 
		#success
		retval=1
		echo "OK"
	else
		#fail
		retval=0
		echo "NG"
	fi
	# anyway change back to system clock
	/sbin/rtcfg -w > /dev/null
	exit $retval
}

region_test()
{
	echo "wireless region: $1"
	/sbin/cfg -a w net.conf WLAN Region $1
	/etc/init.d/savecfg.sh
}

case "$1" in

	test)
		test_mode
		;;
	normal)
		normal_mode
		;;
	usb)
		usb_test
		;;
	rtc)
		rtc_test
		;;
	region)
		region_test $2
		;;
	system)
		system_mode $2
		;;
	*)	
		echo "no such test case"
esac

