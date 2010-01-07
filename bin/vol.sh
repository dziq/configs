#-GENERAL MAIN-----
VOLMOVE="4" # 
MUTEFILE="/tmp/xbindkeys.mute.tmp"
MIXER="Master Playback Volume"

#-OSD METHOD-------
OSD="dzen2"
#-+-OSD: libnotify-
OSDFILE="/tmp/xbindkeys.osd.tmp"
NSLEEP=(3 3)     # "delay sleep" & "delay window"
#-+-OSD: dzen2-----
DSLEEP="1"      # sleep $SECS
BG="#363636"        # background colour of window
FG="#ffffff"        # foreground colour of text/icon
BAR_BG="#141414"    # background colour of volume bar
BAR_FG="#ffffff"    # foreground colour of volume bar
XPOS="850"          # horizontal positioning
YPOS="700"          # vertical positioning
HEIGHT="15"         # window height
#WIDTH="250"         # window width
WIDTH="250"
BAR_WIDTH="210"     # width of volume bar
ICONPREFIX=~/.xbindkeysrc.icon.vol
FONT="-*-fixed-*-*-*-*-10-*-*-*-*-*-iso10646-1"
FONT="-*-fixed-*-*-*-*-10-*-*-*-*-*-iso10646-1"
PIPE="/tmp/dvolpipe"


case $OSD in
	"libnotify")
		if [ -f $OSDFILE ]; then
			kill `cat $OSDFILE`
			rm $OSDFILE
		fi

		printvol() {
			case $2 in
				"normal") c="Poziom głośniści: $1" ;;
				"mute")   c="Wyciszenie.." ;;
				"unmute") c="Anulowanie wyciszenia.."
			esac
			if [ ! -f $OSDFILE ]; then
				echo $$ > $OSDFILE
				sleep ${NSLEEP[0]}s
				rm $OSDFILE
				notify-send -t ${NSLEEP[1]}000 $"$c"
			fi
		}
	;;
	"dzen2")
		printvol() {
			if [ "$1" = "0" ]; then
				ICON="$ICONPREFIX-mute.xbm"
			else
				ICON="$ICONPREFIX-normal.xbm"
			fi

			#Using named pipe to determine whether previous call still exists
			#Also prevents multiple volume bar instances
			if [ ! -e "$PIPE" ]; then
			  mkfifo "$PIPE"
		  	(dzen2 -tw "$WIDTH" -h "$HEIGHT" -x "$XPOS" -y "$YPOS" -fn "$FONT" -bg "$BG" -fg "$FG" < "$PIPE" 
			   rm -f "$PIPE") &
			fi

			#Feed the pipe!
			(echo "$1" | gdbar -l "^i(${ICON})" -fg "$BAR_FG" -bg "$BAR_BG" -w "$BAR_WIDTH" ; sleep "$DSLEEP") > "$PIPE" &
		}
esac

GETVOL() {
	amixer cget name="$MIXER"|sed '/:[[:space:]]values=/!d; s/.*values=\(.*\)/\1/g'
}

SETVOL() {
	amixer cset name="$MIXER" $1|sed '/:[[:space:]]values=/!d; s/.*values=\(.*\)/\1/g'
}
function mute {
	if [ "$(GETVOL)" = "0" ]; then 
	  if [ -e "$MUTEFILE" ]; then 
			local -i VOL
  	  VOL="$(SETVOL $(cat $MUTEFILE))"
			printvol "$VOL" "unmute"
	    rm $MUTEFILE
	  fi
	else
	  GETVOL > $MUTEFILE 
	  SETVOL 0
		printvol "0" "mute"
	fi
}
function vol {
	local -i VOL
	VOL="$(SETVOL $[$(GETVOL)${1}VOLMOVE])"
	printvol "$VOL" "normal"
}

if   [ "$1" = "+" ]; then vol +
elif [ "$1" = "-" ]; then vol -
elif [ "$1" = "mute" ]; then mute
fi

