#!/usr/bin/env sh
set -eu
: "${USER:?env USER is not set}"

if [ ! -e /data/alfis.toml ]; then
    echo "Creating /data/alfis.toml from default configuration"
    cp /usr/share/alfis/alfis.toml /data/alfis.toml
fi

chown -R $USER:$USER /data
