#!/bin/bash

foreground="#afd700"
background="#151515"
font="-*-fixed-*-*-*-*-10-*-*-*-*-*-iso10646-1"
interval=1

## select player: mocp, mpd, amarok2
player_type="mpd"

color1="#d6156c"

## some additional envy's

## functions
function clock {
    clock=`date +"%H:%M"`
}

function media_player {
    
    function mocp_player {
        state=`mocp -i | awk '/State/ {print $2}'`
        played_now="`mocp -i | sed -ne 's/^Artist: \(.*\)$/\1/p'` - `mocp -i | sed -ne 's/^SongTitle: \(.*\)$/\1/p'`"
        if [ "${state}" = "PLAY" ]; then
            media_player="^fg($color1)[ PLAYING ]^fg() $played_now"
        elif [ "${state}" = "PAUSE" ]; then
            media_player="^fg($color1)[ PAUSED ]^fg() $played_now"
        else
            media_player="^fg($color1)[ STOPPED ]^fg() nothing is played now"
        fi
    }
    
    function mpd_player {
        state=`mpc | awk '/(playing|paused)/ { print $1 }' | sed -e 's/\[//' -e 's/\]//'`
        played_now=`mpc | line`
        
        if [ "${state}" = "playing" ]; then
            media_player="^fg($color1)[ PLAYING ]^fg() $played_now"
        elif [ "${state}" = "paused" ]; then
            media_player="^fg($color1)[ PAUSED ]^fg() $played_now"
        else
            media_player="^fg($color1)[ STOPPED ]^fg() nothing is played now"
        fi
    }
  
    function amarok2_player {
        state=`qdbus org.kde.amarok /Player GetMetadat`
        played_now=`qdbus org.kde.amarok /Player GetMetadata | awk '/artist|title/' | sed -e 's/artist\:\ //' -e 's/title\:\ / \-\ /' | awk '{printf("%s", $0) }'`
    
        media_player="^fg($color1)[ PLAYING ]^fg() $played_now"
    }
    
    ${player_type}_player
    
}

function network {
    
    rx1o=`cat /sys/class/net/eth0/statistics/rx_bytes`
    tx1o=`cat /sys/class/net/eth0/statistics/tx_bytes`
    
    sleep 1
    
    rx1n=`cat /sys/class/net/eth0/statistics/rx_bytes`
    tx1n=`cat /sys/class/net/eth0/statistics/tx_bytes`
    
    download="$(( $(( $rx1n - $rx1o )) / 1024 / $interval ))"
    upload="$(( $(( $tx1n  - $tx1o )) / 1024 / $interval ))"
    
}

function battery {
  bat="$(echo `hal-device | grep charge_level.percentage | awk '{print $3}'`%)"
}

## core script

while true; do
## exec modules
    network
    media_player
    clock
    battery    
    echo -e "$media_player | download: ^fg($color1)${download}kb/s^fg() upload: ^fg($color1)${upload}kb/s^fg() | bat: ^fg($color1)$bat^fg() | $clock "
    
    ## uncomment if you don't use network func
    #sleep $interval
done | dzen2 -x 305 -h 14 -ta right -fn "$font" -fg "$foreground" -bg "$background"

