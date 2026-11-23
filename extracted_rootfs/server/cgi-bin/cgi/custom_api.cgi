#!/bin/sh
# Custom Modern API handler for TV-IP121W Pro v1.1.2

echo -ne "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nConnection: close\r\nAccess-Control-Allow-Origin: *\r\nCache-Control: no-cache, no-store, must-revalidate\r\n\r\n"

# Read POST body if method is POST
POST_BODY=""
if [ "$REQUEST_METHOD" = "POST" ]; then
    read -r POST_BODY
fi

get_val() {
    target="$1"
    OLD_IFS="$IFS"
    IFS="&"
    res=""
    for pair in $QUERY_STRING $POST_BODY; do
        k="${pair%%=*}"
        v="${pair#*=}"
        if [ "$k" = "$target" ]; then
            res="$v"
            break
        fi
    done
    IFS="$OLD_IFS"
    echo "$res"
}

ACTION=$(get_val "action")

case "$ACTION" in
    login)
        u=$(get_val "user")
        p=$(get_val "pass")
        if [ "$u" = "admin" -a "$p" = "admin" ]; then
            echo '{"status":"ok","user":"admin","token":"YWRtaW46YWRtaW4=","message":"Авторизация успешна"}'
        else
            echo '{"status":"error","message":"Неверное имя пользователя или пароль"}'
        fi
        ;;
    get)
        v_res=$(/sbin/cfg -a r -p /server profile.ini 0 resolution)
        v_fps=$(/sbin/cfg -a r -p /server profile.ini 0 framerate)
        v_qual=$(/sbin/cfg -a r -p /server profile.ini 0 quality)
        v_ratio=$(/sbin/cfg -a r -p /server profile.ini 0 ipratio)
        
        img_bri=$(/sbin/cfg -a r -p /server video.ini video brightness)
        img_con=$(/sbin/cfg -a r -p /server video.ini video contrast)
        img_sat=$(/sbin/cfg -a r -p /server video.ini video saturation)
        img_flip=$(/sbin/cfg -a r -p /server video.ini video flip)
        img_mir=$(/sbin/cfg -a r -p /server video.ini video mirror)
        img_flick=$(/sbin/cfg -a r -p /server video.ini video frequency)
        
        osd_en=$(/sbin/cfg -a r -p /server video.ini osd enable)
        osd_op=$(/sbin/cfg -a r -p /server video.ini osd opaque)
        osd_cor=$(/sbin/cfg -a r -p /server video.ini osd corner)
        osd_inv=$(/sbin/cfg -a r -p /server video.ini osd invert)
        
        aud_mic=$(/sbin/cfg -a r -p /server video.ini audio microphone)
        aud_vol=$(/sbin/cfg -a r -p /server video.ini audio volume)
        
        net_dev=$(/sbin/cfg -a r net.conf NETWORK "Wan Dev")
        net_pol=$(/sbin/cfg -a r net.conf WAN Policy)
        net_ip=$(/sbin/cfg -a r net.conf WAN "IP Addr")
        net_mask=$(/sbin/cfg -a r net.conf WAN Netmask)
        net_gw=$(/sbin/cfg -a r net.conf WAN Gateway)
        net_hport=$(/sbin/cfg -a r net.conf WAN "Http Port")
        net_rport=$(/sbin/cfg -a r net.conf WAN "RTSP Port")
        net_dns1=$(/sbin/cfg -a r net.conf "DNS PROXY" Primary)
        net_dns2=$(/sbin/cfg -a r net.conf "DNS PROXY" Secondary)
        net_mac=$(/sbin/cfg -a r net.conf NETWORK "mac addr")
        
        wf_en=$(/sbin/cfg -a r net.conf WLAN Enable)
        wf_ssid=$(/sbin/cfg -a r net.conf WLAN ESSID)
        wf_chan=$(/sbin/cfg -a r net.conf WLAN Channel)
        wf_auth=$(/sbin/cfg -a r net.conf WLAN AuthMode)
        wf_sec=$(/sbin/cfg -a r net.conf WLAN SecMethod)
        
        sys_name=$(/sbin/cfg -a r sys.conf SYSTEM CameraName)
        sys_ir=$(/sbin/cfg -a r sys.conf SYSTEM IR)
        sys_tz=$(/sbin/cfg -a r sys.conf DATETIME TimeZone)
        sys_ntp=$(/sbin/cfg -a r sys.conf DATETIME "NTP IP")
        sys_sched=$(/sbin/cfg -a r sys.conf DATETIME "Sync Schedule")
        
        cur_time=$(date "+%Y-%m-%d %H:%M:%S")
        uptime_sec=$(cut -d' ' -f1 /proc/uptime)
        
        ir_info=$(/sbin/irled.sh status 2>/dev/null)
        [ -z "$ir_info" ] && ir_info='{"mode":"auto","led":0,"sensor":"unknown","night":2,"delay":5}'
        
        cat <<JSON_DATA_EOF
{
  "status": "ok",
  "video": {
    "resolution": "${v_res:-0}",
    "framerate": "${v_fps:-30}",
    "quality": "${v_qual:-4}",
    "ipratio": "${v_ratio:-10}"
  },
  "image": {
    "brightness": "${img_bri:-8}",
    "contrast": "${img_con:-32}",
    "saturation": "${img_sat:-36}",
    "flip": "${img_flip:-0}",
    "mirror": "${img_mir:-0}",
    "frequency": "${img_flick:-1}"
  },
  "osd": {
    "enable": "${osd_en:-0}",
    "opaque": "${osd_op:-0}",
    "corner": "${osd_cor:-0}",
    "invert": "${osd_inv:-0}"
  },
  "audio": {
    "microphone": "${aud_mic:-1}",
    "volume": "${aud_vol:-90}"
  },
  "network": {
    "dev": "${net_dev:-eth0}",
    "policy": "${net_pol:-dhcpc}",
    "ip": "${net_ip:-192.168.10.30}",
    "netmask": "${net_mask:-255.255.255.0}",
    "gateway": "${net_gw:-192.168.10.1}",
    "httpport": "${net_hport:-80}",
    "rtspport": "${net_rport:-554}",
    "dns1": "${net_dns1:-}",
    "dns2": "${net_dns2:-}",
    "mac": "${net_mac:-}"
  },
  "wifi": {
    "enable": "${wf_en:-1}",
    "ssid": "${wf_ssid:-IS 2.4 GHz ((main))}",
    "channel": "${wf_chan:-6}",
    "authmode": "${wf_auth:-3}",
    "secmethod": "${wf_sec:-3}"
  },
  "system": {
    "name": "${sys_name:-TV-IP121W}",
    "ir": "${sys_ir:-1}",
    "timezone": "${sys_tz:-GMT-8}",
    "ntp_ip": "${sys_ntp:-pool.ntp.org}",
    "sync_schedule": "${sys_sched:-6}",
    "time": "${cur_time}",
    "uptime": "${uptime_sec:-0}",
    "version": "1.1.2-custom-rtsp-pro"
  },
  "ir": $ir_info
}
JSON_DATA_EOF
        ;;

    set_video)
        res=$(get_val "resolution")
        fps=$(get_val "framerate")
        qual=$(get_val "quality")
        [ -n "$res" ] && /sbin/cfg -a w -p /server profile.ini 0 resolution "$res"
        [ -n "$fps" ] && /sbin/cfg -a w -p /server profile.ini 0 framerate "$fps"
        [ -n "$qual" ] && /sbin/cfg -a w -p /server profile.ini 0 quality "$qual"
        cd /server && ./notify 9 1 >/dev/null 2>&1
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Параметры видео сохранены"}'
        ;;

    set_image)
        bri=$(get_val "brightness")
        con=$(get_val "contrast")
        sat=$(get_val "saturation")
        flp=$(get_val "flip")
        mir=$(get_val "mirror")
        flk=$(get_val "frequency")
        [ -n "$bri" ] && /sbin/cfg -a w -p /server video.ini video brightness "$bri" && /sbin/psensor -brightness="$bri"
        [ -n "$con" ] && /sbin/cfg -a w -p /server video.ini video contrast "$con" && /sbin/psensor -contrast="$con"
        [ -n "$sat" ] && /sbin/cfg -a w -p /server video.ini video saturation "$sat" && /sbin/psensor -saturation="$sat"
        [ -n "$flp" ] && /sbin/cfg -a w -p /server video.ini video flip "$flp" && /sbin/psensor -vflip="$flp"
        [ -n "$mir" ] && /sbin/cfg -a w -p /server video.ini video mirror "$mir" && /sbin/psensor -hmirror="$mir"
        [ -n "$flk" ] && /sbin/cfg -a w -p /server video.ini video frequency "$flk" && /sbin/psensor -flicker="$flk"
        cd /server && ./notify 9 1 >/dev/null 2>&1
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Параметры изображения применены"}'
        ;;

    reset_image)
        /sbin/cfg -a w -p /server video.ini video brightness "8"
        /sbin/cfg -a w -p /server video.ini video contrast "32"
        /sbin/cfg -a w -p /server video.ini video saturation "36"
        /sbin/cfg -a w -p /server video.ini video flip "0"
        /sbin/cfg -a w -p /server video.ini video mirror "0"
        /sbin/cfg -a w -p /server video.ini video frequency "1"
        /sbin/cfg -a w sys.conf SYSTEM IR "1"
        
        /sbin/psensor -brightness=8
        /sbin/psensor -contrast=32
        /sbin/psensor -saturation=36
        /sbin/psensor -vflip=0
        /sbin/psensor -hmirror=0
        /sbin/psensor -flicker=1
        /sbin/camstate IR 1
        
        cd /server && ./notify 9 1 >/dev/null 2>&1
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Заводские настройки изображения восстановлены (четкая картинка)"}'
        ;;

    set_osd)
        en=$(get_val "enable")
        op=$(get_val "opaque")
        cor=$(get_val "corner")
        inv=$(get_val "invert")
        
        [ -n "$en" ] && /sbin/cfg -a w -p /server video.ini osd enable "$en"
        [ -n "$op" ] && /sbin/cfg -a w -p /server video.ini osd opaque "$op"
        
        restart_camsvr=0
        if [ -n "$cor" ]; then
            /sbin/cfg -a w -p /server video.ini osd corner "$cor"
            killall camsvr 2>/dev/null
            sleep 1
            [ ! -f /tmp/camsvr ] && cp /server/camsvr /tmp/camsvr && chmod +x /tmp/camsvr
            /sbin/set_osd_corner "$cor" >/dev/null 2>&1
            restart_camsvr=1
        fi
        
        if [ -n "$inv" ]; then
            /sbin/cfg -a w -p /server video.ini osd invert "$inv"
            if [ "$inv" = "1" ]; then
                cp /server/digits_inv.bmp /tmp/digits.bmp
            else
                cp /server/digits_norm.bmp /tmp/digits.bmp
            fi
            restart_camsvr=1
        fi
        
        if [ "$restart_camsvr" = "1" ]; then
            killall camsvr 2>/dev/null
            sleep 1
            cd /server && /tmp/camsvr &
            sleep 1
            /etc/init.d/sensorctl.sh >/dev/null 2>&1
        else
            cd /server && ./notify 9 1 >/dev/null 2>&1
        fi
        
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Параметры OSD применены"}'
        ;;

    get_ir)
        ir_info=$(/sbin/irled.sh status 2>/dev/null)
        [ -z "$ir_info" ] && ir_info='{"mode":"auto","led":0,"sensor":"unknown","night":2,"delay":5}'
        echo "{\"status\":\"ok\",\"ir\":$ir_info}"
        ;;

    set_ir)
        mode=$(get_val "mode")
        night=$(get_val "night")
        delay=$(get_val "delay")
        ir=$(get_val "ir")
        
        # Backward compatibility with legacy ?action=set_ir&ir=0|1|2
        if [ -z "$mode" -a -n "$ir" ]; then
            if [ "$ir" = "1" ]; then
                mode="auto"
            elif [ "$ir" = "2" ]; then
                mode="on"
            else
                mode="off"
            fi
        fi
        
        [ -z "$mode" ] && mode="auto"
        
        /sbin/irled.sh "$mode" "$night" "$delay" >/dev/null 2>&1
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo "{\"status\":\"ok\",\"mode\":\"$mode\",\"message\":\"Настройки ИК-подсветки применены\"}"
        ;;

    set_audio)
        mic=$(get_val "microphone")
        vol=$(get_val "volume")
        [ -n "$mic" ] && /sbin/cfg -a w -p /server video.ini audio microphone "$mic"
        [ -n "$vol" ] && /sbin/cfg -a w -p /server video.ini audio volume "$vol"
        /etc/rc.d/init.d/audio.sh start >/dev/null 2>&1
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Параметры звука сохранены"}'
        ;;

    set_network)
        pol=$(get_val "policy")
        ip=$(get_val "ip")
        mask=$(get_val "netmask")
        gw=$(get_val "gateway")
        dns1=$(get_val "dns1")
        dns2=$(get_val "dns2")
        hport=$(get_val "httpport")
        rport=$(get_val "rtspport")
        [ -n "$pol" ] && /sbin/cfg -a w net.conf WAN Policy "$pol"
        [ -n "$ip" ] && /sbin/cfg -a w net.conf WAN "IP Addr" "$ip"
        [ -n "$mask" ] && /sbin/cfg -a w net.conf WAN Netmask "$mask"
        [ -n "$gw" ] && /sbin/cfg -a w net.conf WAN Gateway "$gw"
        [ -n "$dns1" ] && /sbin/cfg -a w net.conf "DNS PROXY" Primary "$dns1"
        [ -n "$dns2" ] && /sbin/cfg -a w net.conf "DNS PROXY" Secondary "$dns2"
        [ -n "$hport" ] && /sbin/cfg -a w net.conf WAN "Http Port" "$hport"
        [ -n "$rport" ] && /sbin/cfg -a w net.conf WAN "RTSP Port" "$rport"
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Сетевые параметры сохранены. Вступят в силу после перезагрузки."}'
        ;;

    set_wifi)
        en=$(get_val "enable")
        ssid=$(get_val "ssid")
        chan=$(get_val "channel")
        auth=$(get_val "authmode")
        sec=$(get_val "secmethod")
        pass=$(get_val "password")
        [ -n "$en" ] && /sbin/cfg -a w net.conf WLAN Enable "$en"
        [ -n "$ssid" ] && /sbin/cfg -a w net.conf WLAN ESSID "$ssid"
        [ -n "$chan" ] && /sbin/cfg -a w net.conf WLAN Channel "$chan"
        [ -n "$auth" ] && /sbin/cfg -a w net.conf WLAN AuthMode "$auth"
        [ -n "$sec" ] && /sbin/cfg -a w net.conf WLAN SecMethod "$sec"
        [ -n "$pass" ] && /sbin/cfg -a w net.conf WLAN Password "$pass"
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        /sbin/wlan_up >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Параметры Wi-Fi сохранены"}'
        ;;

    set_time)
        manual_time=$(get_val "datetime")
        tz=$(get_val "timezone")
        ntp_ip=$(get_val "ntp_ip")
        sched=$(get_val "sync_schedule")
        [ -n "$manual_time" ] && /bin/date -s "$manual_time" 2>/dev/null
        [ -n "$tz" ] && /sbin/cfg -a w sys.conf DATETIME TimeZone "$tz" && /sbin/settz
        [ -n "$ntp_ip" ] && /sbin/cfg -a w sys.conf DATETIME "NTP IP" "$ntp_ip"
        [ -n "$sched" ] && /sbin/cfg -a w sys.conf DATETIME "Sync Schedule" "$sched"
        /etc/init.d/savecfg.sh >/dev/null 2>&1 &
        echo '{"status":"ok","message":"Настройки времени обновлены"}'
        ;;

    reboot)
        echo '{"status":"ok","message":"Перезагрузка камеры..."}'
        (sleep 2 && /sbin/reboot) >/dev/null 2>&1 &
        ;;

    *)
        echo '{"status":"error","message":"Неизвестное действие"}'
        ;;
esac
