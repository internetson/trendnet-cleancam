#!/bin/sh

start() {
	/sbin/syslogd -C -m 0
	sleep 3
	/sbin/clean_ipc 2>/dev/null

	cp -f /server/camsvr /tmp/camsvr
	chmod +x /tmp/camsvr

	# Apply OSD font
	inv=`/sbin/cfg -a r -p /server video.ini osd invert`
	if [ "$inv" = "1" ]; then
		cp -f /server/digits_inv.bmp /tmp/digits.bmp
	else
		cp -f /server/digits_norm.bmp /tmp/digits.bmp
	fi

	# Apply OSD corner: 0=Top-Left, 1=Top-Right, 2=Bottom-Left, 3=Bottom-Right
	corner=`/sbin/cfg -a r -p /server video.ini osd corner`
	if [ -n "$corner" ]; then
		/sbin/set_osd_corner "$corner" /tmp/camsvr
	fi

	cd /server; LD_PRELOAD=/lib/libha_osd.so /tmp/camsvr &
	sleep 1
	# init sensor default values
	/etc/init.d/sensorctl.sh
}

stop() {
	for i in audio.cgi mpeg4.cgi mjpeg.cgi rtspd; do
		p=`pidof $i`
		[ -n "$p" ] && kill $p 2>/dev/null
	done
	retry=5
	while [ "$retry" -gt 0 ]
	do
		p=`pidof camsvr`
		[ -n "$p" ] && /bin/kill $p 2>/dev/null
		sleep 1
		if [ -z "`pidof camsvr`" ]; then
			echo "camsvr shutdown success!"
			sendmsg hwmon 50 0
			break
		fi
		retry=$(($retry - 1))
	done
	killall -9 camsvr 2>/dev/null
	/sbin/clean_ipc 2>/dev/null
	killall syslogd 2>/dev/null
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
