#!/usr/bin/env sh
set -eu
: "${USER_UID:?env USER_UID is not set}"
: "${USER_GID:?env USER_GID is not set}"

DATA_DIR="/data"

if [ ! -e "${DATA_DIR}/alfis.toml" ]; then
    echo "Creating ${DATA_DIR}/alfis.toml from default configuration"
    cp /usr/share/alfis/alfis.toml "${DATA_DIR}/alfis.toml"
    chown "${USER_UID}:${USER_GID}" "${DATA_DIR}/alfis.toml"
fi

if [ "$(stat -c '%u:%g' "${DATA_DIR}")" != "${USER_UID}:${USER_GID}" ]; then
    echo "Changing access rights for the ${DATA_DIR} directory"
    chown -R "${USER_UID}:${USER_GID}" "${DATA_DIR}"
fi
