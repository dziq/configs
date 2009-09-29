#eval `cat $HOME/.fehbg` &
exec kdeinit4 &
#exec /usr/lib/wicd/wicd-client.py &
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval `dbus-launch --sh-syntax --exit-with-session`
fi
setxkbmap -option terminate:ctrl_alt_bksp &
exec startfluxbox
