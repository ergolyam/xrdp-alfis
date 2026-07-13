#!/usr/bin/env sh
set -eu
: "${USER:?env USER is not set}"
: "${USER_UID:?env USER_UID is not set}"
: "${USER_GID:?env USER_GID is not set}"

if [ ! -e /data/alfis.toml ]; then
    echo "Creating /data/alfis.toml from default configuration"
    cp /usr/share/alfis/alfis.toml /data/alfis.toml
    chown "${USER_UID}:${USER_GID}" /data/alfis.toml
fi

[ "$(stat -c '%u:%g' /data)" = "${USER_UID}:${USER_GID}" ] ||
    echo "Changing access rights for the /data directory"; chown -R "${USER_UID}:${USER_GID}" /data
