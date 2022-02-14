SESSIONS=$(/bin/w -sh ${USER} | /bin/wc -l)
DBUS_ENV="/run/user/${UID}/db-env"

if [ ${SESSIONS} -le 1 ]; then
	/bin/rm -f ${DBUS_ENV}
	/usr/bin/pkill -U ${USER} -f  /usr/bin/gnome-keyring-daemon
fi

