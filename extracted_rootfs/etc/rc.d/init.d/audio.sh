#!/bin/sh
# 
# audio: audio related stuffs
#

RETVAL=0
spvol=`/sbin/cfg -a r -p /server video.ini audio volume`
speaker=`/sbin/cfg -a r -p /server video.ini audio speaker`

umask 077

case "$1" in
  start)
	echo $"Starting audio adjusting ---->"
	# adjust microphone volume to max
	#/sbin/mixer2 -g 50
	/sbin/mixer2 -3 20 -g 100 -x 15
	# adjust speaker volume
	if [ $speaker = 1 ] ; then
		/sbin/mixer2 -v $spvol
	fi
	RETVAL=$?
	echo 
	exit $RETVAL
	;;
  stop)
	# donthing
esac
