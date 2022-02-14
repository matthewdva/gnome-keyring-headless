#!/bin/bash

function new-dbus-launch () {
   [[ ${UID} != 0 ]] && pkill -9 -u ${USER} dbus-daemon
   /bin/rm -f ${DBUS_ENV}
   /usr/bin/dbus-launch > ${DBUS_ENV}
   cat >> ${DBUS_ENV} <<EOE
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID
export GNOME_KEYRING_CONTROL=${GNOME_KEYRING_CONTROL}
export XDG_RUNTIME_DIR
export XDG_SESSION_ID
EOE
   . ${DBUS_ENV}
}

function validate-dbus-session () {
     PROC=$(/bin/ps -ef | /bin/grep -v grep | /bin/grep ${DBUS_SESSION_BUS_PID})
     RC=$?
     [[ ${RC} != 0 ]] && return 1
     [[ ${PROC} =~ (^[[:alnum:]]+)[[:space:]]+(([[:digit:]]+)[[:space:]]+).+(dbus-daemon) ]]
     PUSER=${BASH_REMATCH[1]}
     PID=${BASH_REMATCH[3]}
     BIN=${BASH_REMATCH[4]}

     [[ -z ${BIN} ]] && return 1
     [[ ${USER} != ${PUSER} ]] && return 1
     [[ ${PID} -ne ${DBUS_SESSION_BUS_PID} ]] && return 1
     
     return 0
}
   
[[ ! -z ${SUDO_USER} ]] && return 0

DBUS_ENV="/run/user/${UID}/db-env"

# Gnome Keyring Daemon will fail to start properly unless these 2
# Directories exist.
[[ ! -d ~/.cache ]] && mkdir ~/.cache
[[ ! -d ~/.local ]] && mkdir ~/.local

if [ -f ${DBUS_ENV} ]; then
  . ${DBUS_ENV}
  validate-dbus-session
  rc=$?
  if [ ${rc} != 0 ]; then
    new-dbus-launch
  fi
else
  new-dbus-launch
fi

unset BIN
unset PUSER
unset PID

trap "/bin/bash /etc/profile.d/logoff.d/lock_gnome_keyring.sh" EXIT
