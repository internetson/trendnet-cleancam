#!/bin/sh

brightness=`/sbin/cfg -a r -p /server video.ini video brightness`
contrast=`/sbin/cfg -a r -p /server video.ini video contrast`
saturation=`/sbin/cfg -a r -p /server video.ini video saturation`
flip=`/sbin/cfg -a r -p /server video.ini video flip`
mirror=`/sbin/cfg -a r -p /server video.ini video mirror`
flicker=`/sbin/cfg -a r -p /server video.ini video frequency`

[ -z "$brightness" ] && brightness=8
[ -z "$contrast" ] && contrast=32
[ -z "$saturation" ] && saturation=36
[ -z "$flip" ] && flip=0
[ -z "$mirror" ] && mirror=0
[ -z "$flicker" ] && flicker=1

/sbin/psensor -brightness=$brightness
/sbin/psensor -contrast=$contrast
/sbin/psensor -saturation=$saturation
/sbin/psensor -vflip=$flip
/sbin/psensor -hmirror=$mirror
/sbin/psensor -flicker=$flicker

# Apply OSD settings from video.ini
cd /server && ./notify 9 1 2>/dev/null
