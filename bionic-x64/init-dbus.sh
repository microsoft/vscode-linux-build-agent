#!/bin/bash

NONROOT_USER=builduser
LOG=/tmp/container-init.log

# Execute the command it not already running
startInBackgroundIfNotRunning()
{
	log "Starting $1."
	echo -e "\n** $(date) **" | sudoIf tee -a /tmp/$1.log > /dev/null
	if ! pidof $1 > /dev/null; then
		keepRunningInBackground "$@"
		while ! pidof $1 > /dev/null; do
			sleep 1
		done
		log "$1 started."
	else
		echo "$1 is already running." | sudoIf tee -a /tmp/$1.log > /dev/null
		log "$1 is already running."
	fi
}

# Keep command running in background
keepRunningInBackground()
{
	($2 sh -c "while :; do echo [\$(date)] Process started.; $3; echo [\$(date)] Process exited!; sleep 5; done 2>&1" | sudoIf tee -a /tmp/$1.log > /dev/null & echo "$!" | sudoIf tee /tmp/$1.pid > /dev/null)
}

# Use sudo to run as root when required
sudoIf()
{
    if [ "$(id -u)" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Use sudo to run as non-root user if not already running
sudoUserIf()
{
    if [ "$(id -u)" -eq 0 ]; then
        sudo -u ${NONROOT_USER} "$@"
    else
        "$@"
    fi
}

# Log messages
log()
{
    echo -e "[$(date)] $@" | sudoIf tee -a $LOG > /dev/null
}

log "** SCRIPT START **"

# Start dbus.
log 'Running "/etc/init.d/dbus start".'
if [ -f "/var/run/dbus/pid" ] && ! pidof dbus-daemon  > /dev/null; then
	sudoIf rm -f /var/run/dbus/pid
fi
sudoIf /etc/init.d/dbus start 2>&1 | sudoIf tee -a /tmp/dbus-daemon-system.log > /dev/null
while ! pidof dbus-daemon > /dev/null; do
	sleep 1
done

# Set up Xvfb.
startInBackgroundIfNotRunning "Xvfb" sudoIf "Xvfb :10 -ac -screen 0 1920x1080x16 +extension RANDR"

# Run whatever was passed in
log "Executing \"$@\"."
"$@"
log "** SCRIPT EXIT **"
