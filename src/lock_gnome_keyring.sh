SESSIONS=$(/usr/bin/w -sh ${USER} | /usr/bin/wc -l)
if [ -d "/run/user/${UID}" ]; then
  DBUS_ENV="/run/user/${UID}/dbus_env"
else
  DBUS_ENV='~/.dbus_env'
fi
if [ ${SESSIONS} -le 1 ]; then
	/bin/rm -f ${DBUS_ENV}
	/usr/bin/pkill -U ${USER} -f  /usr/bin/gnome-keyring-daemon
fi

