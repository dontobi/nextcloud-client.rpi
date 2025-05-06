#!/bin/sh

LOG_DATE_FORMAT="%m-%d %H:%M:%S"

if [ -z "$NC_USER" ]; then
  echo "[ error ]: Username NC_USER (required) is empty. Exiting." | ts "${LOG_DATE_FORMAT}"
  exit 1
fi
if [ -z "$NC_PASS" ]; then
  echo "[ error ]: Password NC_PASS (required) is empty. Exiting." | ts "${LOG_DATE_FORMAT}"
  exit 1
fi
if [ -z "$NC_URL" ]; then
  echo "[ error ]: Nextcloud URL NC_URL (required) is empty. Exiting." | ts "${LOG_DATE_FORMAT}"
  exit 1
fi

getent group "$USER_GID" > /dev/null || addgroup -g "$USER_GID" "$USER"
getent passwd "$USER_UID" > /dev/null || adduser -u "$USER_UID" "$USER" -D -H -G "$USER"

[ -d /settings ] || mkdir -p /settings
chown -R "$USER_UID":"$USER_GID" /settings

if [ -e "/settings/exclude" ]; then
	EXCLUDE="/settings/exclude"
else
	echo "[ info ]: Exclude file /settings/exclude not found." | ts "${LOG_DATE_FORMAT}"
fi

if [ -e "/settings/unsyncfolders" ]; then
	UNSYNCEDFOLDERS="/settings/unsyncfolders"
else
	echo "[ info ]: Unsyncedfolders file /settings/unsyncfolders not found." | ts "${LOG_DATE_FORMAT}"
fi

[ -n "$NC_PATH" ] && echo "[ info ]: Remote root folder overridden to '$NC_PATH'" | ts "${LOG_DATE_FORMAT}"
[ "$NC_SILENT" = "true" ] && echo "[ info ]: Silent mode enabled" | ts "${LOG_DATE_FORMAT}"
[ "$NC_HIDDEN" = "true" ] && echo "[ info ]: Sync hidden files enabled" | ts "${LOG_DATE_FORMAT}"
[ "$NC_TRUST_CERT" = "true" ] && echo "[ info ]: Trust any SSL certificate" | ts "${LOG_DATE_FORMAT}"

echo "[ info ]: Starting Nextcloud client..." | ts "${LOG_DATE_FORMAT}"

while true
do
	[ "$NC_SILENT" = "true" ] && echo "[ info ]: Start sync from '$NC_URL' to '$NC_SOURCE_DIR'" | ts "${LOG_DATE_FORMAT}"

	set --
	[ "$NC_HIDDEN" = "true" ] && set -- "$@" "-h"
	[ "$NC_SILENT" = "true" ] && set -- "$@" "--silent"
	[ "$NC_TRUST_CERT" = "true" ] && set -- "$@" "--trust"
	[ -n "$NC_PATH" ] && set -- "$@" "--path" "$NC_PATH"
	[ -n "$EXCLUDE" ] && set -- "$@" "--exclude" "$EXCLUDE"
	[ -n "$UNSYNCEDFOLDERS" ] && set -- "$@" "--unsyncedfolders" "$UNSYNCEDFOLDERS"
	set -- "$@" "--non-interactive" "-u" "$NC_USER" "-p" "$NC_PASS" "$NC_SOURCE_DIR" "$NC_URL"
	nextcloudcmd "$@"

	[ "$NC_SILENT" = "true" ] && echo "[ info ]: Sync done" | ts "${LOG_DATE_FORMAT}"

	if [ "$NC_EXIT" = true ] ; then
		if [ "$NC_SILENT" != "true" ] ; then
			echo "[ info ]: NC_EXIT is true so exiting... bye!" | ts "${LOG_DATE_FORMAT}"
		fi
		exit
	fi
	echo "[ info ]: Wait ${NC_INTERVAL:-60}s until next sync" | ts "${LOG_DATE_FORMAT}"
	sleep "${NC_INTERVAL:-60}"
done