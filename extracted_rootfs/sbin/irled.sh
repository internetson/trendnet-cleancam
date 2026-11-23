#!/bin/sh
# irled.sh - High-level IR LED & Night Mode Manager with Debounce/Hysteresis
# TRENDnet TV-IP121W Pro

PIDFILE="/var/run/ir_auto.pid"

kill_daemon() {
    if [ -f "$PIDFILE" ]; then
        PID=$(cat "$PIDFILE")
        [ -n "$PID" ] && kill "$PID" 2>/dev/null
        rm -f "$PIDFILE"
    fi
    # Also kill any stray background daemon loops
    for p in $(pidof irled.sh); do
        if [ "$p" != "$$" ]; then
            kill "$p" 2>/dev/null
        fi
    done
}

get_config() {
    MODE=$(/sbin/cfg -a r -p /server video.ini video ir_mode)
    [ -z "$MODE" ] && MODE=$(/sbin/cfg -a r sys.conf SYSTEM IR)
    [ "$MODE" = "1" ] && MODE="auto"
    [ "$MODE" = "0" ] && MODE="off"
    [ -z "$MODE" ] && MODE="auto"

    NIGHT=$(/sbin/cfg -a r -p /server video.ini video night_mode)
    [ -z "$NIGHT" ] && NIGHT=2

    DELAY=$(/sbin/cfg -a r -p /server video.ini video ir_delay)
    [ -z "$DELAY" ] && DELAY=5
}

case "$1" in
    on)
        kill_daemon
        get_config
        [ -n "$2" ] && NIGHT="$2"
        /sbin/ir_ctrl on >/dev/null 2>&1
        /sbin/psensor -night="$NIGHT" >/dev/null 2>&1
        /sbin/cfg -a w -p /server video.ini video ir_mode "on"
        /sbin/cfg -a w sys.conf SYSTEM IR "2"
        /sbin/cfg -a w -p /server video.ini video night_mode "$NIGHT"
        ;;

    off)
        kill_daemon
        /sbin/ir_ctrl off >/dev/null 2>&1
        /sbin/psensor -night=0 >/dev/null 2>&1
        /sbin/cfg -a w -p /server video.ini video ir_mode "off"
        /sbin/cfg -a w sys.conf SYSTEM IR "0"
        ;;

    auto)
        kill_daemon
        get_config
        [ -n "$2" ] && NIGHT="$2"
        [ -n "$3" ] && DELAY="$3"
        /sbin/cfg -a w -p /server video.ini video ir_mode "auto"
        /sbin/cfg -a w sys.conf SYSTEM IR "1"
        /sbin/cfg -a w -p /server video.ini video night_mode "$NIGHT"
        /sbin/cfg -a w -p /server video.ini video ir_delay "$DELAY"
        /sbin/irled.sh daemon &
        ;;

    daemon)
        echo "$$" > "$PIDFILE"
        get_config
        dark_cnt=0
        light_cnt=0

        # Check initial ambient state (with IR off)
        /sbin/ir_ctrl off >/dev/null 2>&1
        usleep 80000 2>/dev/null
        STAT=$(/sbin/ir_ctrl status 2>/dev/null)
        case "$STAT" in
            *SENSOR=0*) # Dark
                /sbin/ir_ctrl on >/dev/null 2>&1
                /sbin/psensor -night="$NIGHT" >/dev/null 2>&1
                cur_led=1
                ;;
            *)          # Light
                /sbin/ir_ctrl off >/dev/null 2>&1
                /sbin/psensor -night=0 >/dev/null 2>&1
                cur_led=0
                ;;
        esac

        while true; do
            sleep 1
            if [ "$cur_led" -eq 0 ]; then
                # IR is OFF: sensor reads pure ambient light
                STAT=$(/sbin/ir_ctrl status 2>/dev/null)
                case "$STAT" in
                    *SENSOR=0*) # Dark
                        dark_cnt=$((dark_cnt + 1))
                        if [ "$dark_cnt" -ge "$DELAY" ]; then
                            /sbin/ir_ctrl on >/dev/null 2>&1
                            /sbin/psensor -night="$NIGHT" >/dev/null 2>&1
                            cur_led=1
                            dark_cnt=0
                            light_cnt=0
                        fi
                        ;;
                    *)
                        dark_cnt=0
                        ;;
                esac
            else
                # IR is ON: check every DELAY seconds by briefly probing ambient light (80ms)
                light_cnt=$((light_cnt + 1))
                if [ "$light_cnt" -ge "$DELAY" ]; then
                    light_cnt=0
                    /sbin/ir_ctrl off >/dev/null 2>&1
                    usleep 80000 2>/dev/null
                    STAT=$(/sbin/ir_ctrl status 2>/dev/null)
                    case "$STAT" in
                        *SENSOR=1*) # Real ambient daylight detected!
                            /sbin/psensor -night=0 >/dev/null 2>&1
                            cur_led=0
                            dark_cnt=0
                            ;;
                        *)          # Still dark: immediately restore IR LED
                            /sbin/ir_ctrl on >/dev/null 2>&1
                            ;;
                    esac
                fi
            fi
        done
        ;;

    status)
        get_config
        STAT=$(/sbin/ir_ctrl status 2>/dev/null)
        LED=0
        SENSOR="light"
        case "$STAT" in
            *LED=1*) LED=1 ;;
            *LED=0*) LED=0 ;;
        esac
        case "$STAT" in
            *SENSOR=0*) SENSOR="dark" ;;
            *SENSOR=1*) SENSOR="light" ;;
        esac
        if [ "$LED" -eq 1 -a "$MODE" = "auto" ]; then
            SENSOR="dark"
        fi
        echo "{\"mode\":\"$MODE\",\"led\":$LED,\"sensor\":\"$SENSOR\",\"night\":$NIGHT,\"delay\":$DELAY}"
        ;;

    init)
        get_config
        case "$MODE" in
            on)   /sbin/irled.sh on "$NIGHT" ;;
            off)  /sbin/irled.sh off ;;
            *)    /sbin/irled.sh auto "$NIGHT" "$DELAY" ;;
        esac
        ;;

    *)
        echo "Usage: /sbin/irled.sh on|off|auto|status|init"
        exit 1
        ;;
esac
